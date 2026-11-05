# AI Flight Log — бортовой журнал работы с ИИ

Append-only flight log of running AI on real desktop hardware: one hand, several cards, dated
entries, failures logged with the same rank as successes. Not a benchmark dump — a journal you can
follow release to release. Each card is a section; every section has its own anchor line
(one configuration re-measured on every stable engine release, so its row is comparable over
time) and its own raw data under `results/`.

**How to read an entry**: [journal/RULES.md](journal/RULES.md) — 8 rules; the two that shape
everything: (1) entries are never edited after publication, corrections are new entries;
(2) every failure names its symptom ("how you know it's this") and its workaround.
Index + machine feed: [journal/README.md](journal/README.md) · [journal/journal.jsonl](journal/journal.jsonl).

## Sections (cards)

| § | Card | Status | Section |
| --- | --- | --- | --- |
| 1 | Tesla V100 SXM2 32GB (Volta, sm_70) | active — standard-v1 complete | [sections/v100.md](sections/v100.md) |
| 2 | RTX 3060 12GB (unlocked) | archived at [rtx3060-strata-tuning](https://github.com/ildargiv/rtx3060-strata-tuning), will fold in | №004+ |
| 3 | CMP 90HX | archived at [cmp90hx-strata-tuning](https://github.com/ildargiv/cmp90hx-strata-tuning), will fold in | later |

## Current (2026-11-05)

- §1 entry №002: Strata **standard-v1 complete**, 21/21 requests, sanity 12/12 — prefill
  1280/1584 tok/s (4K/16K), decode 72–91, TTFT 0.7–10.4 s, n=3, idle server. Top of the
  community V100 corridor (1127–1633 / 54–77).
- Entry №003: needle 32k/128k × depths 10/50/90 — **6/6 FOUND**.
- Entry №001: what blocked the card from coming up (driver 595 not knowing Volta, 187 W ghost
  capping, adapter link x1, config regeneration wiping hand-edits) — all with repro steps.

## Follow

Watch → Releases: each release is an entry. Mini-posts for communities: [outreach/](outreach/).

---

# Русская версия (кратко)

**Бортовой журнал работы с ИИ**: живые замеры ИИ на десктопном железе, append-only (записи не
переписываются, исправления — новые записи), неудача — запись того же ранга, что и успех, с
признаком и обходом. Карта = раздел; у раздела якорная линия (одна конфигурация, перезамеряемая
на каждый стабильный релиз движка). Сейчас: §1 Tesla V100 SXM2-32GB — пройдена standard-v1
(prefill 1280/1584, decode 72–91, sanity 12/12), иглы 6/6; §2/§3 — существующие репо про 3060 и
CMP 90HX, переедут сюда позже. Подписка — на Releases. Правила: `journal/RULES.md`.
