# AGENTS.md — PaTiLead

**Read the suite rules first: [`../../PaTiAdmin/AGENTS.md`](../../PaTiAdmin/AGENTS.md).** They apply here in full.
Addon facts: `../../PaTiAdmin/docs/ARCHITECTURE.md` · open issues: `../../PaTiAdmin/docs/FOLLOW_UPS.md`.

## This addon
- Purpose: **lead the group** — raid markers, Clear / Reset All, ready check, pull timer, leader/assist info, local
  note. The player picks the target and clicks. (Former name PaTiGroup until 2026-10-02; the name PaTiGroup now
  belongs to the party-awareness addon. Do not add awareness features here, do not add lead actions there.)
- Files: `Logic.lua` (settings, marker order, reset text — pure, tested) · `Bar.lua` (window, secure buttons, layout, paint) ·
  `PaTiLead.lua` (settings, commands, bindings names, events) · `Bindings.xml` · `Locales/` · `Shared/` (synced, never edit).
- SavedVariables: `PaTiLeadDB` (per character), schema 1 — see `Logic.DEFAULTS`, `markers` = 8 slots (raid target index or 0), `note`.
- Secure: `PaTiLeadMarker1..8`, `PaTiLeadClear` (type raidtarget, action set, marker 0 = clear), `PaTiLeadReset`
  (type macro, macrotext /tm), binding buttons `PaTiLeadBindMarker1..8`, `PaTiLeadBindClear`
  (keep these names: players' key bindings point at them). Layout/attributes only out of combat (`Bar.Layout`).
- Never: call SetRaidTarget from Lua, bind keys, call SaveBindings, create or edit macros, mark automatically.
- Slash: `/plead`, `/patilead`.

## Checks
`bash ../../PaTiAdmin/tools/check.sh .` before every commit. Manual WoW tests: `INGAME_TESTING.md`.
