# AGENTS.md — PaTiGroup

**Read the suite rules first: [`../../PaTiAdmin/AGENTS.md`](../../PaTiAdmin/AGENTS.md).** They apply here in full.
Addon facts: `../../PaTiAdmin/docs/ARCHITECTURE.md` · open issues: `../../PaTiAdmin/docs/FOLLOW_UPS.md`.

## This addon
- Purpose: raid markers, ready check, pull timer, group overview for leaders. The player picks the target and clicks.
- Files: `Logic.lua` (settings, marker order, reset text — pure, tested) · `Bar.lua` (window, secure buttons, layout, paint) ·
  `PaTiGroup.lua` (settings, commands, bindings names, events) · `Bindings.xml` · `Locales/` · `Shared/` (synced, never edit).
- SavedVariables: `PaTiGroupDB` (per character), schema 1 — see `Logic.DEFAULTS`, `markers` = 8 slots (raid target index or 0), `note`.
- Secure: `PaTiGroupMarker1..8`, `PaTiGroupClear` (type raidtarget, action set, marker 0 = clear), `PaTiGroupReset`
  (type macro, macrotext /tm), binding buttons `PaTiGroupQuickSkull`, `PaTiGroupBindMarker1..7`, `PaTiGroupBindClear`
  (keep these names: players' key bindings point at them). Layout/attributes only out of combat (`Bar.Layout`).
- Never: call SetRaidTarget from Lua, bind keys, call SaveBindings, create or edit macros, mark automatically.
- Slash: `/pg`, `/ptg`, `/patigroup`.

## Checks
`bash ../../PaTiAdmin/tools/check.sh .` before every commit. Manual WoW tests: `../../PaTiAdmin/docs/TESTING.md`.
