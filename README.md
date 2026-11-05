# AI Flight Log — Tesla V100 SXM2 32 GB (Volta, sm_70)

Measured on 2026-11-05 by **ildargiv**, ongoing. Third card in the fleet line:
[rtx3060-strata-tuning](https://github.com/ildargiv/rtx3060-strata-tuning) →
[cmp90hx-strata-tuning](https://github.com/ildargiv/cmp90hx-strata-tuning) → this one.

This repo is a **flight log**, not a one-shot benchmark: dated entries, append-only, and a failed
measurement is a first-class entry with the same rank as a passing one. Rules:
[`journal/RULES.md`](journal/RULES.md), template: [`journal/TEMPLATE.md`](journal/TEMPLATE.md),
index + machine-readable feed: [`journal/README.md`](journal/README.md) /
[`journal/journal.jsonl`](journal/journal.jsonl). Anchor line (comparable over time): one V100
SXM2-32GB, Qwen3.8-Flash-Next IQ3_XXS, 262,144 context, `--kv int8`, bit-exact sm_70 switches on.

## Hardware and software

- GPU: Tesla V100 SXM2 32 GB, GV100GL, PCI ID `10de:1db5`, subsystem `10de:1249`, SXM2-to-PCIe
  adapter. Link: PCIe 3.0 x16 (`LnkSta 8GT/s x16`; first seating read **x1** — see entry №001).
  ECC enabled, 0 errors. Power limit 300 W. No outputs (compute-only); display runs on the iGPU.
- CPU: Ryzen 5 5600G (6c/12t, Cezanne iGPU drives the desktop). RAM 96 GB (16+32+16+32, 3200 MT/s).
- OS: Ubuntu 22.04.5, kernel 6.8.0-138, Secure Boot off. Driver `nvidia-driver-580-server`
  **580.178.04** — R580 is the last NVIDIA branch with Volta; the `-open` module is Turing+ only.
- Strata: terminal/app 0.2.10, engine **0.1.57 linux-x86_64-cuda-cuda12** from the signed feed
  (release binaries 404 for the cuda12 asset; the feed carries it). No host CUDA toolkit needed.

## Model and configuration

Qwen3.8-Flash-Next GSQ-RCO IQ3_XXS (71 GB, 2 shards, native-experts), pack `iq3_xxs`, dflash2/MTP
drafting, context 262144, `--kv int8 --kv-resident 32768`, expert-cache auto (~19.25 GiB VRAM,
11,857 experts), conversation cache 12 slots / 16 GiB (`user_args`), env:
`STRATA_SM70_TABLE=1 STRATA_FUSE_DECODE=1 STRATA_ARGMAX_ROWS_SM70=1 STRATA_GR_NORM_FAST=1`
(all bit-exact per `docs/NVIDIA_V100.md`). No `STRATA_ROUTE_PRIOR` (3060-era compensation).
Full snippets: [`configs/`](configs/).

## Method

Engine's own timings; fresh-nonce prompts (`0 reused` on fresh arms), warm-up discarded; standard
protocol via `strata bench run` (suite standard-v1). Details per entry.

## Results

**№002 — standard-v1, complete, 21/21 requests, sanity 12/12** (median, min–max, n=3; 2 min 25 s
after model load; idle server):

| Case | Prompt tok/s | Decode tok/s | TTFT s |
| --- | --- | --- | --- |
| prompt-4k | 1,280 (1238–1288) | 72.8 (72.3–80.4) | 3.22 |
| prompt-16k | 1,584 (1558–1656) | 71.9 (71.7–75.1) | 10.37 |
| short | n/a per protocol | 90.8 (83.0–93.5) | 0.71 |

Raw: [`results/2026-11-05-standard-v100-sxm2-r1/`](results/2026-11-05-standard-v100-sxm2-r1/).
Community V100-32GB corridor (other hosts): prefill 1127–1633, decode 54–77 — we sit at its top.
Our RTX 3060 (unlocked fast config): prefill 684–745 → ~1.9–2.3×, decode 61 → 1.18–1.48× without
the quality-suspect prior.

**№001 first pass (n=1, nonce):** prefill 998/1535/1633 tok/s at 1.7K/8.4K/25K tokens, decode
75.5–81.1; dialogue continuation reused 47,218/47,265 prompt tokens (TTFT 2 s at 47K). Needle sweep
(`tools/needle_bench.py`, 32k/128k × depths 10/50/90): **6/6 found**; 262k skipped (label exceeds
the 262,144 context) — entry №003.

## Gotchas (the failures, in order — each one is an entry with repro steps)

1. Driver 595-open: Volta simply not supported (branch + open-module), `nvidia-smi` dead on arrival.
2. GitHub release has no cuda12 engine (404); the signed feed does.
3. `setup.py --cuda 12` doesn't see the components manager and tries to re-download the 47 GB
   model → symlink `engine-cuda12/` + `--gguf-dir`.
4. A 3060-era systemd service silently capped the V100 at 187 W on first test restart.
5. SXM2 adapter first seating: `LnkSta x1 (downgraded)` → decode 47.5 instead of 75+.
6. Runtime regenerates launch configs from presets: hand-edit `args` gets wiped — `user_args`
   only; profile migration needs `--allow-source-migration --if-source-sha256` from `--plan`.
7. Operator mistakes kept in the log too (sudo -S vs heredoc stdin collision; wrong pid kill;
   autostart racing a manual server start).

## What this card is not

No unlock needed or possible (Volta has no GeForce half-rate gate — tensor is full rate stock;
mma_rate proof pending). No BF16/INT8 tensor, no CUDA 13, no DeepSeek V4.1-Flash class packs —
Volta support is security-only to ~2028, and this log documents the tail end honestly.

## License

Text, scripts, configs, results: MIT. Model weights, packs and NVIDIA components keep their own licenses.

---

# Русская версия (кратко)

Живой бортовой журнал третьей карты парка: Tesla V100 SXM2 32 GB (Volta, sm_70), Strata 0.1.57
(готовый cuda12-движок из подписного фида), драйвер 580.178.04-server (последняя ветка с Volta),
Ubuntu 22.04, 5600G, 96 ГБ RAM 3200. Правила журнала: append-only; неудачная запись = равноценная
запись с признаком и обходом; якорная линия — IQ3_XXS/262K/`--kv int8`/бит-в-бит sm_70-тумблеры.

**standard-v1 (протокол): complete, 21/21, sanity 12/12, n=3:** prefill **1280** (4k) / **1584**
(16k) tok/s, decode **72.8** / **71.9**, короткий прогон 90.8, TTFT 0.7–10.4 с — верх community-
коридора V100 (1127–1633 / 54–77). Против нашей разблокированной 3060: prefill ×1.9–2.3, decode
×1.18–1.48, и без подозрительного prior. Первый диалоговый тест: из 47265 токенов продолжения
движок дочитал **47** — кэш разговоров работает.

Неудачи, вошедшие в журнал: 595 не знает Volta; cuda12-движка нет на GitHub-релизах (есть в фиде);
setup перекачивает модель (лечится `--gguf-dir`); сервис-наследие резал карту до 187 Вт; первое
посаживание адаптера — линк ×1 (decode падал до 47.5); ручные правки конфигов затираются runtime'ом
(канал `user_args`); плюс операторские ошибки без купюр. Иглы 32k/128k × глубины 10/50/90 —
**6/6** (262k пропущено: метка больше контекста; запись №003).

Подписка: Watch → Releases, каждый выпуск = запись журнала. Мини-статьи для постов:
[`outreach/`](outreach/).
