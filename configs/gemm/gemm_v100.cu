// gemm_v100.cu — tensor-rate proof for Volta sm_70 (fleet journal №008).
// Mirrors the 3060-repo harness measurements, Linux/nvcc form:
//   A) FP16 in, FP32 accumulate (the path Strata uses)      -> expect full Volta tensor rate
//   B) FP16 in, FP16 accumulate (control)                    -> historically full-rate on Volta
//   C) COMPUTE_16F explicit on cublasGemmEx (the "formal gap" from the 3060 runbook: on
//      Ampere GeForce cuBLAS 12 refused it, rc 15; on Volta it is the stock mode — record which)
//   D) FP32 pedantic SGEMM (control, non-tensor)             -> ~14-15 TF/s class
//   E) BF16 attempt: Volta has no BF16 tensor — error/accept must be recorded, not guessed.
#include <cublas_v2.h>
#include <cuda_fp16.h>
#include <cuda_runtime.h>
#include <cstdio>
#include <cstring>
#include <chrono>
#include <vector>

#define CK(x) do { auto e=(x); if(e){printf("FATAL %s -> %d\n",#x,(int)e); return 1;} } while(0)

int main(int argc, char** argv) {
    int N = argc > 1 ? atoi(argv[1]) : 4096;
    double secs = argc > 2 ? atof(argv[2]) : 15.0;
    cublasHandle_t h; CK(cublasCreate(&h));
    size_t nn = (size_t)N * N;
    void *dA, *dB, *dC32, *dC16;
    CK(cudaMalloc(&dA, nn * 2)); CK(cudaMalloc(&dB, nn * 2));
    CK(cudaMalloc(&dC32, nn * 4)); CK(cudaMalloc(&dC16, nn * 2));
    CK(cudaMemset(dA, 0x3c, nn * 2)); CK(cudaMemset(dB, 0x3c, nn * 2));
    float f32 = 1.f, fzero = 0.f;

    auto run = [&](const char* label, auto body) -> void {
        // warmup 2s
        for (int i = 0; i < 50; i++) if (body()) break;
        cudaDeviceSynchronize();
        auto t0 = std::chrono::steady_clock::now();
        long iters = 0; int err = 0;
        while (true) {
            for (int b = 0; b < 100; b++) { if (body()) { err = 1; break; } iters++; }
            if (err) break;
            cudaDeviceSynchronize();
            auto el = std::chrono::duration<double>(std::chrono::steady_clock::now() - t0).count();
            if (el >= secs) break;
        }
        cudaDeviceSynchronize();
        double el = std::chrono::duration<double>(std::chrono::steady_clock::now() - t0).count();
        if (err) { printf("%-28s : refused/failed (rc above)\n", label); return; }
        double tf = (double)iters * (2.0 * N * N * N) / el / 1e12;
        printf("%-28s : %8.2f TF/s  (%ld iters, %.1fs)\n", label, tf, iters, el);
    };

    // A) fp16 x fp16 -> fp32, COMPUTE_32F
    run("A. FP16 in, FP32 accum", [&]{
        return cublasGemmEx(h, CUBLAS_OP_N, CUBLAS_OP_N, N, N, N, &f32,
            dA, CUDA_R_16F, N, dB, CUDA_R_16F, N, &fzero,
            dC32, CUDA_R_32F, N, CUBLAS_COMPUTE_32F, CUBLAS_GEMM_DEFAULT) != CUBLAS_STATUS_SUCCESS; });

    // B) fp16 in/out, default-compute (fp16 accumulate historically)
    run("B. FP16 in, FP16 out", [&]{
        __half h1 = __float2half(1.f), h0 = __float2half(0.f);
        return cublasGemmEx(h, CUBLAS_OP_N, CUBLAS_OP_N, N, N, N, &h1,
            dA, CUDA_R_16F, N, dB, CUDA_R_16F, N, &h0,
            dC16, CUDA_R_16F, N, CUBLAS_COMPUTE_16F, CUBLAS_GEMM_DEFAULT) != CUBLAS_STATUS_SUCCESS; });

    // C) same as B explicitly — Volta must ACCEPT (record rc if not)
    run("C. COMPUTE_16F explicit", [&]{
        __half h1 = __float2half(1.f), h0 = __float2half(0.f);
        return cublasGemmEx(h, CUBLAS_OP_N, CUBLAS_OP_N, N, N, N, &h1,
            dA, CUDA_R_16F, N, dB, CUDA_R_16F, N, &h0,
            dC16, CUDA_R_16F, N, CUBLAS_COMPUTE_16F, CUBLAS_GEMM_DEFAULT) != CUBLAS_STATUS_SUCCESS; });

    // D) fp32 pedantic control
    run("D. FP32 pedantic", [&]{
        return cublasSgemm(h, CUBLAS_OP_N, CUBLAS_OP_N, N, N, N, &f32,
            (const float*)dA, N, (const float*)dB, N, &fzero, (float*)dC32, N) != CUBLAS_STATUS_SUCCESS; });

    // E) bf16 attempt on sm_70 (expect refusal; record)
    run("E. BF16 in, FP32 accum", [&]{
        return cublasGemmEx(h, CUBLAS_OP_N, CUBLAS_OP_N, N, N, N, &f32,
            dA, CUDA_R_16BF, N, dB, CUDA_R_16BF, N, &fzero,
            dC32, CUDA_R_32F, N, CUBLAS_COMPUTE_32F, CUBLAS_GEMM_DEFAULT) != CUBLAS_STATUS_SUCCESS; });

    cublasDestroy(h);
    return 0;
}
