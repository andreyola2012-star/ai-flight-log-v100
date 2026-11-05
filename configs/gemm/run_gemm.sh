#!/bin/bash
# №008 runner: tensor-rate proof on Volta. Requires: CUDA 12 toolkit installed,
# Strata server STOPPED (card must be otherwise idle). Fleet rule: clocks/power sampled
# during each run; three repetitions; server never running alongside.
set -e
D=$(dirname "$0")
LOG=~/Документы/Проект\ по\ умолчанию/ai-flight-log-v100/results/gemm
mkdir -p "$LOG"

# safety: refuse to start if an engine is alive
if ps -eo cmd | grep -q '[c]omponents/engine/0.1.57.*--serve'; then
  echo "СТРАТЕГИЯ: движок жив — остановить профиль перед замером"; exit 1
fi

~/.local/share/strata/terminal/current/python/bin/python3 -m pip --version >/dev/null 2>&1 || true
nvcc --version | grep release | awk '{print "nvcc:", $NF}'
g++ --version | head -1 | awk '{print "host gcc:", $3}'

# CUDA 12.9 keeps gcc support to <=13; jammy gcc 11 fits
nvcc -O3 -arch=sm_70 "$D/gemm_v100.cu" -lcublas -o "$D/gemm_v100"

for i in 1 2 3; do
  ( nvidia-smi --query-gpu=timestamp,clocks.sm,clocks.mem,power.draw,temperature.gpu \
      --format=csv,noheader -lms 500 > "$LOG/power-run$i.csv" 2>/dev/null & echo $! > /tmp/gemm-dmon.pid )
  "$D/gemm_v100" 4096 15 | tee "$LOG/gemm-run$i.txt"
  kill "$(cat /tmp/gemm-dmon.pid)" 2>/dev/null || true
  sleep 5
done
grep -h ':' "$LOG"/gemm-run*.txt | head -20
