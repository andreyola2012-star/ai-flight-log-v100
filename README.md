# AI Flight Log — бортовой журнал работы с ИИ

Append-only flight log of running AI on real desktop hardware. One hand, several cards — and
**every card gets its own journal**: its own dated entries, its own feed, its own raw results.
Common rules for all journals: [`RULES.md`](RULES.md), entry template: [`TEMPLATE.md`](TEMPLATE.md).
Not a benchmark dump: a failed measurement is a first-class entry with the same rank as a passing
one — with the symptom ("how you know it's this") and the workaround ("what to do instead").

## Cards / Карты

| Card | Journal | Engine anchor | Status |
| --- | --- | --- | --- |
| Tesla V100 SXM2 32GB (Volta, sm_70) | [`cards/v100/`](cards/v100/) | IQ3_XXS · 262K · `--kv int8` · bit-exact sm_70 switches | **live**, standard-v1 complete |
| RTX 3060 12GB (Ampere, unlocked) | opens as `cards/3060/` | — | archive: [rtx3060-strata-tuning](https://github.com/ildargiv/rtx3060-strata-tuning) |
| CMP 90HX (GA102, eFuse-limited) | opens as `cards/cmp90hx/` | — | archive: [cmp90hx-strata-tuning](https://github.com/ildargiv/cmp90hx-strata-tuning) |

## Current (2026-11-05)

- **V100 №002**: Strata standard-v1 — **complete, 21/21, sanity 12/12**, n=3: prefill
  1,280/1,584 tok/s (4K/16K prompts), decode 72–91 tok/s, TTFT 0.7–10.4 s. Top of the community
  V100 corridor. [`cards/v100/journal/entries/002.md`](cards/v100/journal/entries/002.md)
- **V100 №003**: needle 32k/128k × depths 10/50/90 — **6/6 FOUND**.
  [`.../003.md`](cards/v100/journal/entries/003.md)
- **V100 №001**: what blocked the card from coming up (driver 595 not knowing Volta; a leftover
  187 W power cap; SXM2 adapter seating that gave `Link x1`; config regeneration wiping hand
  edits) — each with repro steps. [`.../001.md`](cards/v100/journal/entries/001.md)

## Follow / Подписка

Watch → Releases: each release is an entry in some card's journal. Community posts announcing the
log (EN+RU): [`outreach/`](outreach/).

---

# Русская версия (кратко)

Бортовой журнал работы с ИИ: живой append-only дневник замеров и настройки ИИ на десктопном железе.
На каждую карту — свой журнал (свои датированные записи, свой feed, своё сырье); правила общие
(`RULES.md`): записи не переписываются задним числом, исправление — новая запись; неудача —
запись того же ранга, что успех, с признаком и обходом. Активная карта: **Tesla V100 SXM2-32GB**
(журнал `cards/v100/`) — пройдена standard-v1 (prefill 1280/1584, decode 72–91, sanity 12/12,
n=3), иглы 6/6, запись №001 — хроника «чем карта не работала». Журналы 3060 и CMP 90HX —
существующие репо, переедут сюда отдельными картами. Подписка — на Releases.
