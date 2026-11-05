# Note on this dataset (№011 WIP)

- `arms_off.jsonl` + `arms_on.jsonl` (pair2): both are STOCK runs — `env_proof.txt` says
  `stage[on]: GDN=absent`. The migration-aware `runtime restart` rebuilds the launch config from
  the preset, and the preset's `env` edits do not propagate to the engine's environ. So pair2's
  "on" side is not an A/B arm; treat both files as a **stock-vs-stock control**: medians 1677.5→
  pattern identical in both runs (rep1 hot → rep4 cold-ish), spread ~9% — a fresh noise estimate.
- `arms_on_verified.jsonl` (pending): direct launch with STRATA_GDN_REC_WARP=2 in the environment,
  verified via /proc/<engine>/environ before measuring.
