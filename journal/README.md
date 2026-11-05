# Flight log / Бортовой журнал

Index of dated entries. Language policy: root README is EN-first with a RU duplicate; entries are
written in the operator's language with an EN one-liner here (full RU→EN dubbing per entry is the
next step). Append-only — corrections are new entries, see [`../RULES.md`](../RULES.md).

| № | Date | Engine | Class | EN one-liner | RU |
| --- | --- | --- | --- | --- | --- |
| [001](entries/001.md) | 2026-11-05 | 0.1.56→0.1.57-cuda12 | driver/config/hw/operator | V100 brought up: what blocked it (595 no-Volta, x1 link, 187 W ghost service, user_args), n=1 first numbers prefill 998–1633 / decode 75–81 | карта встала: чем не работала; первые цифры |
| [002](entries/002.md) | 2026-11-05 | 0.1.57-cuda12 | bench/success | standard-v1 complete, 21/21, sanity 12/12: prefill 1280/1584, decode 72/91, TTFT 0.7–10.4 (n=3) | протокол пройден с первого раза |
| [003](entries/003.md) | 2026-11-05 | 0.1.57 | bench/success | needle 32k/128k × depths 10/50/90: 6/6 FOUND; fresh-read prefill 1560/1364 tok/s; depth-90 arm is prefix-contaminated, 10%-only for the anchor | иглы 6/6, в якорь идут только 10% рукава |

Machine feed: [`journal.jsonl`](journal.jsonl). Raw bench data: [`../results/`](../results/).
| [004](entries/004.md) | 2026-11-05 | 0.1.57 | bench/success | needle 200,852 tokens x depths 10/50/90: 3/3; anchor prefill curve 1560/1364/1271 tok/s | полная контекстная линия 26.5K/106K/201K закрыта |
| [005](entries/005.md) | 2026-11-05 | 0.1.57 | bench/success | decode anchor n=4 idle: 70.4/68.6/63.4 tok/s at 4.5K/35K/139K (short arm not anchorable, spec-acceptance noise 73-114); prefill plateau re-confirmed | якорь декода зафиксирован, короткий рукав — шум спекуляции |
| [006](entries/006.md) | 2026-11-05 | 0.1.57 | failure-expected | paired A/B PF_WMMA at 35K n=4: prefill -0.1% vs claimed +10%, decode within noise; switch stays off | обещанного профита нет — дефолты остаются |
| [007](entries/007.md) | 2026-11-05 | 0.1.57 | neutral | engine calibrate: defaults hold (settings {}, nothing to apply); lead found: conv-cache may squeeze expert cache 15162->11857 | калибровка подтвердила дефолты; найдена улика по hit-rate |
|[008](entries/008.md) | 2026-11-05 | cuBLAS harness | INVALID — see 008-И | published before the run finished; its 134.5 / BF16 numbers were never measured | отменена корректировкой |
| [008-И](entries/008-И.md) | 2026-11-05 | cuBLAS harness | correction | real GEMM: fp16→fp32 med 90.75 TF/s; COMPUTE_16F accepted; D/E = harness bug; RULES: no entry before raw files | реальные числа; правила ужесточены |
| [009](entries/009.md) | 2026-11-05 | 0.1.57 | correction | conv-cache squeeze hypothesis refuted: expert cache 15289 both arms; hit-rate mystery = double-launch artifact; A kept by choice (capacity, not on/off) | гипотеза не выдержала A/B; загадка hit-rate закрыта |
