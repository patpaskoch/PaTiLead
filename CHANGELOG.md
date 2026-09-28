# Changelog

Format: `## [Unreleased]` / `## [x.y.z] - YYYY-MM-DD` with Added, Changed, Fixed, Removed, Known Issues.
History before this file: `git log`.

## [Unreleased] — planned 0.5.0
### Added
- All eight raid markers plus Clear; marker choice and order in the settings.
- Current target with its marker, group leader/assists and role counts; local note.
- Settings modal (pull buttons, group info, note, lock, language, scale), test mode, saved position (PaTiGroupDB).
- Key bindings for every marker, Clear and Show/Hide in WoW's key binding menu.
- `/pg settings, test, lock, unlock, reset, debug, version, about, changelog`; English texts, German translation.
### Changed
- New PaTiShared look: header with ••• menu instead of the close button, flat buttons.
- Reset All runs the /tm commands as secure macrotext; the character macro PaTiG_Reset is no longer created or edited.
### Fixed
- Target marker, names, roles and leader/assist flags are checked for restricted (secret) values before they
  are compared or tested; unreadable values show as "no marker" / "no role".
### Removed
- Automatic binding of Ctrl + Left click to Quick Skull on login (an existing binding keeps working), SaveBindings on login,
  and the removal of an ALT-G binding on login.
### Known Issues
- Not tested in game yet: marker/clear/reset via secure buttons, key bindings, macrotext support of this client.
