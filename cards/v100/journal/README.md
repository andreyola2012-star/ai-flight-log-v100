# Flight log / Бортовой журнал

Index of dated entries. Language policy: root README is EN-first with a RU duplicate; entries are
written in the operator's language with an EN one-liner here (full RU→EN dubbing per entry is the
next step). Append-only — corrections are new entries, see [`../../RULES.md`](../../RULES.md).

| № | Date | Engine | Class | EN one-liner | RU |
| --- | --- | --- | --- | --- | --- |
| [001](entries/001.md) | 2026-11-05 | 0.1.56→0.1.57-cuda12 | driver/config/hw/operator | V100 brought up: what blocked it (595 no-Volta, x1 link, 187 W ghost service, user_args), n=1 first numbers prefill 998–1633 / decode 75–81 | карта встала: чем не работала; первые цифры |
| [002](entries/002.md) | 2026-11-05 | 0.1.57-cuda12 | bench/success | standard-v1 complete, 21/21, sanity 12/12: prefill 1280/1584, decode 72/91, TTFT 0.7–10.4 (n=3) | протокол пройден с первого раза |
| [003](entries/003.md) | 2026-11-05 | 0.1.57 | bench/success | needle 32k/128k × depths 10/50/90: 6/6 FOUND; fresh-read prefill 1560/1364 tok/s; depth-90 arm is prefix-contaminated, 10%-only for the anchor | иглы 6/6, в якорь идут только 10% рукава |

Machine feed: [`journal.jsonl`](journal.jsonl). Raw bench data: [`../results/`](../results/).
