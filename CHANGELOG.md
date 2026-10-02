# Changelog

Format: `## [Unreleased]` / `## [x.y.z] - YYYY-MM-DD` with Added, Changed, Fixed, Removed, Known Issues.
History before this file: `git log`.

## [Unreleased] — planned 0.5.0
### Added
- Window settings (PaTiShared): panel opacity 30–100 % (default 75 %, the header stays opaque). The window registers
  itself for the optional PaTiSuite control panel, which shows/hides it with this addon's own rules. (Snapping to
  other PaTi windows was tried and removed again: it did not work in the client.)
- MIT license (`LICENSE`, not part of the release zip).
- All eight raid markers plus Clear; marker choice and order in the settings.
- Current target with its marker, group leader/assists and role counts; local note.
- Settings modal (pull buttons, group info, note, lock, language, scale), test mode, saved position (PaTiLeadDB).
- Key bindings for every marker, Clear and Show/Hide in WoW's key binding menu.
- Settings: own "Key bindings" section with a highlighted help note ("ESC > Key Bindings > PaTiLead", fallback
  path via Options) instead of the small grey hint line.
- `/plead settings, test, lock, unlock, reset, debug, version, about, changelog`; English texts, German translation.
- Own icon (owner-provided 2026-10-02, PaTiSuite style: crown over the group with raid markers, red and gold):
  `Media/icon.tga` + `## IconTexture`, platform images in `assets/`.
### Changed
- **Renamed from PaTiGroup to PaTiLead** (2026-10-02, repository and Git history kept): addon folder, TOC, frames,
  key binding entries and buttons (`PaTiLeadMarker1..8`, `PaTiLeadBindMarker1..8`, `PaTiLeadBindClear`), slash commands
  `/plead` and `/patilead` (`/pg`, `/ptg`, `/patigroup` now belong to the new PaTiGroup). SavedVariables are now
  `PaTiLeadDB`: nothing is taken over from the old `PaTiGroupDB` (pre-release reset, owner decision 2026-10-02) —
  settings, note and key bindings start fresh.
- AddOns list description in English with a German translation (`## Notes-deDE`); README rewritten for players
  (features, installation, first steps, commands, known limitations).
- New PaTiShared look: header with ••• menu instead of the close button, flat buttons.
- Reset All runs the /tm commands as secure macrotext; the character macro PaTiG_Reset is no longer created or edited.
- Collapse/Expand in the ••• menu: only the header stays; saved in PaTiLeadDB.collapsed (old saves: expanded).
  Disabled in combat (the bar holds secure buttons). Restore Defaults expands the bar.
### Fixed
- Hardening: a broken SavedVariables save (not a table, a broken schema or scale) no longer breaks the login; only the broken value is replaced, every valid setting (also `false`) stays, and the migration is idempotent (tests/robustness_spec.lua).
- Settings: the first section title showed the key "GENERAL" (no text for it); now "General" / "Allgemein".
- Target marker, names, roles and leader/assist flags are checked for restricted (secret) values before they
  are compared or tested; unreadable values show as "no marker" / "no role".
- Leader/assist detection also accepts the value 1 that older client APIs return (the secret-value fix above
  briefly required exactly true).
### Removed
- Automatic binding of Ctrl + Left click to Quick Skull on login, SaveBindings on login,
  and the removal of an ALT-G binding on login.
- The group icon moved to the new PaTiGroup.
### Known Issues
- Not tested in game yet: marker/clear/reset via secure buttons, key bindings, macrotext support of this client.
