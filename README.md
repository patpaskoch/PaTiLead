# PaTiGroup

Raid target markers, ready check and pull timer for World of Warcraft: Forever (Interface 16001). You pick a target
and click a marker — PaTiGroup never marks, binds keys or creates macros by itself.

> Status: in development, not yet released. Not yet tested in game since the rework.

## Features
- All eight markers plus Clear; choose which markers appear and in which order
- Reset All removes all eight markers from all targets
- Ready check and pull 3 / 5 / 10 for leader and assistants (pull buttons can be hidden)
- Current target with its marker, group leader, assistants and role counts
- A short note, stored only on your PC
- ••• menu: Settings, Lock, Collapse, Test Mode, Hide. Settings: language, scale, what to show.
  Languages: English, Deutsch (others fall back to English)

## Key bindings
Every marker, Clear and Show/Hide PaTiGroup can get its own key in WoW's key binding menu:

**ESC > Key Bindings > PaTiGroup** (German client: **ESC > Tastaturbelegung > PaTiGroup**; some clients:
ESC > Options > Key Bindings). The exact path in the Forever client is not yet confirmed.

PaTiGroup never sets a key. An old Ctrl + Left Click binding from version 0.4 or earlier keeps working and can be
changed there.

## Installation
1. Download the release zip (`PaTiGroup-<version>.zip`).
2. Unpack it and copy the folder `PaTiGroup` into `World of Warcraft/<client>/Interface/AddOns/`.
3. Start WoW and enable PaTiGroup in the AddOns list.

## First steps
- Target an enemy, click a marker
- `/pg settings` → marker order; the "Key bindings" section shows where to bind keys
- `/pg test` shows example data

## Commands
`/pg`, `/ptg` or `/patigroup` — alone: show/hide · `settings` · `test` · `show` · `hide` · `lock` · `unlock` ·
`reset` (position) · `debug` · `version` · `about` · `changelog`

The bar cannot be shown, hidden, collapsed or rearranged in combat (it has secure buttons).

## Known limitations
- Markers, Reset All and key bindings are not yet tested in game since the rework.
- Up to version 0.4 PaTiGroup created the macro `PaTiG_Reset`. It is no longer used or changed; you may delete it
  (`/pg debug` shows whether it still exists).
