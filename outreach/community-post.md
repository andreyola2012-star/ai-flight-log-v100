# Community post — English (Strata discussions/issues, r/LocalLLaMA, HN-adjacent)

**Tesla V100 32GB still isn't dead: full Strata standard-v1 run + an honest flight log**

We put a V100-SXM2-32GB into a Ryzen 5600G box (Ubuntu 22.04, driver 580.178.04-server — the last
branch that knows Volta) and ran Strata's standard-v1 protocol on the ready-made
linux-x86_64-cuda-cuda12 engine from the signed feed. First results:

- prefill **1,280** tok/s (4k prompt) and **1,584** tok/s (16k), n=3, spread <4%
- decode **72–91** tok/s, TTFT 0.7–10.4 s, 12/12 sanity checks, 21/21 requests, no failures
- dialogue continuation of a 47K-token prompt re-read **47 tokens of 47,265** — the conversation
  cache and checkpoints do what the docs say
- bit-exact sm_70 switches (`STRATA_SM70_TABLE` etc.) on; no unlock, none needed — Volta tensor
  cores are full rate stock

But the point of this repo is what the benchmark numbers hide: every failure is a dated,
same-rank entry with the symptom and the workaround. What we ate on the way: driver 595 silently
not supporting Volta (open module is Turing+), the cuda12 engine 404-ing on GitHub releases while
the signed feed carries it, `setup.py` trying to re-download 47 GB of model until you point it at
`--gguf-dir`, a leftover power-limit service capping the card to 187 W, an SXM2 adapter seating
that gave `Link x1 (downgraded)` and silently cost 35% of decode — plus my own operator mistakes,
logged verbatim.

It's a living log: one anchor line (IQ3_XXS, 262K, `--kv int8`) re-measured every stable engine
release, experiments as separate entries, corrections only as new entries. If you have a V100 in a
desktop, or you're deciding whether Volta's security-support tail (to ~2028) is worth riding,
watch the releases — each one is an entry.

Repo: **<REPO_URL>** · Needle sweep (32k/128k/262k × depths) lands as entry №003.

---

# Пост на русском (Habr/4pda/телеграм-каналы)

**Tesla V100 32GB ещё жив: полный прогон Strata standard-v1 и честный бортовой журнал**

V100-SXM2-32GB в десктопе на 5600G (Ubuntu 22.04, драйвер 580.178.04-server — последняя ветка,
знающая Volta), движок cuda12 из подписного фида Strata. Результат протокола (n=3, idle): prefill
**1280** ток/с на 4K и **1584** на 16K, decode **72–91**, TTFT 0.7–10.4 с, sanity 12/12, ноль
фейлов. Продолжение диалога на 47K токенов дочитало **47 из 47265** — кэш разговоров работает как
в документации. Разблокировки не нужно: Volta считает tensor полной скоростью из коробки.

Главное в репозитории — не таблицы, а журнал: каждая неудача — датированная запись того же ранга,
что и успех, с признаком и обходом. По дороге мы съели: драйвер 595, который в принципе не видит
Volta; cuda12-движок, отсутствующий на GitHub-релизах (лежит в фиде); setup, пересылающий 47 ГБ
модели; сервис-наследие от прошлой карты, обрезавший V100 до 187 Вт; посадку адаптера с линком
×1, тихо укусившую 35% декода — и собственные операторские ошибки без купюр.

Правила: append-only (исправления — новые записи), якорная линия замеряется на каждый стабильный
релиз движка. Подписывайтесь на Releases — каждый выпуск = запись. Если у вас V100 в ящике или вы
думаете, стоит ли оседлать хвост поддержки Volta (security-обновления до ~2028) —
**<REPO_URL>**, иглы 32k/128k/262k доедут записью №003.
