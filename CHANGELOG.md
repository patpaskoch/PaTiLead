# Changelog

Format: `## [Unreleased]` / `## [x.y.z] - YYYY-MM-DD` with Added, Changed, Fixed, Removed, Known Issues.
History before this file: `git log`.

## [Unreleased] — planned 0.5.0
### Added
- All eight raid markers plus Clear; marker choice and order in the settings.
- Current target with its marker, group leader/assists and role counts; local note.
- Settings modal (pull buttons, group info, note, lock, language, scale), test mode, saved position (PaTiGroupDB).
- Key bindings for every marker, Clear and Show/Hide in WoW's key binding menu.
- Settings: own "Key bindings" section with a highlighted help note ("ESC > Key Bindings > PaTiGroup", fallback
  path via Options) instead of the small grey hint line.
- `/pg settings, test, lock, unlock, reset, debug, version, about, changelog`; English texts, German translation.
### Changed
- AddOns list description in English with a German translation (`## Notes-deDE`); README rewritten for players
  (features, installation, first steps, commands, known limitations).
- New PaTiShared look: header with ••• menu instead of the close button, flat buttons.
- Reset All runs the /tm commands as secure macrotext; the character macro PaTiG_Reset is no longer created or edited.
- Collapse/Expand in the ••• menu: only the header stays; saved in PaTiGroupDB.collapsed (old saves: expanded).
  Disabled in combat (the bar holds secure buttons). Restore Defaults expands the bar.
### Fixed
- Target marker, names, roles and leader/assist flags are checked for restricted (secret) values before they
  are compared or tested; unreadable values show as "no marker" / "no role".
- Leader/assist detection also accepts the value 1 that older client APIs return (the secret-value fix above
  briefly required exactly true).
### Removed
- Automatic binding of Ctrl + Left click to Quick Skull on login (an existing binding keeps working), SaveBindings on login,
  and the removal of an ALT-G binding on login.
### Known Issues
- Not tested in game yet: marker/clear/reset via secure buttons, key bindings, macrotext support of this client.
