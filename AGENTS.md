# AGENTS.md — PaTiGroup

**Read the suite rules first: [`../../PaTiAdmin/AGENTS.md`](../../PaTiAdmin/AGENTS.md).** They apply here in full
(independence, combat lockdown, no automation, localization, tests, Definition of Done, VALIDATION output).
Addon facts: `../../PaTiAdmin/docs/ARCHITECTURE.md` · open issues: `../../PaTiAdmin/docs/FOLLOW_UPS.md`.

## This addon
- Purpose: manual raid markers, ready check and pull countdown for group leaders.
- SavedVariables: none yet (position is not saved).
- Secure / combat-sensitive: four marker buttons + `PaTiGroupQuickSkull` (SecureActionButtonTemplate, type raidtarget), reset button running the character macro `PaTiG_Reset`. `SetRaidTarget` is protected in this client — never call it from Lua.
- Slash commands: `/pg`, `/ptg`, `/patigroup` — show|an, hide|aus, toggle. Binding `PATIGROUP_TOGGLE` (Bindings.xml).
- Login side effects: creates/updates the macro, binds Ctrl+Left click only if unbound, calls SaveBindings (FOLLOW_UPS F8). Never overwrite a player's existing binding.

## Checks
`bash ../../PaTiAdmin/tools/check.sh .` before every commit. Manual WoW tests: `../../PaTiAdmin/docs/TESTING.md`.
