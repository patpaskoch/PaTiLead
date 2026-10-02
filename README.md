# PaTiLead

<img src="assets/icon-128.png" width="96" alt="PaTiLead icon">

Lead your group in World of Warcraft: Forever (Interface 16001): raid target markers, ready check and pull timer.
You pick a target and click a marker — PaTiLead never marks, binds keys or creates macros by itself.

> Status: in development, not yet released. Not yet tested in game since the rework.
>
> PaTiLead is the former **PaTiGroup** (renamed 2026-10-02, history kept). The name PaTiGroup now belongs to a new,
> small party-awareness addon (who is tank, healer, what the tank targets). Settings of the old PaTiGroup are not
> taken over: PaTiLead starts with its own `PaTiLeadDB`.

## Features
- All eight markers plus Clear; choose which markers appear and in which order
- Reset All removes all eight markers from all targets
- Ready check and pull 3 / 5 / 10 for leader and assistants (pull buttons can be hidden)
- Current target with its marker, group leader, assistants and role counts
- A short note, stored only on your PC
- ••• menu: Settings, Lock, Collapse, Test Mode, Hide. Settings: language, scale, what to show.
  Languages: English, Deutsch (others fall back to English)

## Key bindings
Every marker, Clear and Show/Hide PaTiLead can get its own key in WoW's key binding menu:

**ESC > Key Bindings > PaTiLead** (German client: **ESC > Tastaturbelegung > PaTiLead**; some clients:
ESC > Options > Key Bindings). The exact path in the Forever client is not yet confirmed.

PaTiLead never sets a key. Keys bound to the old PaTiGroup entries must be bound again under PaTiLead.

## PaTiSuite

This addon is part of the **PaTiSuite** — a collection of small addons for World of Warcraft: Forever.
Each one is installed on its own and works on its own; none of them is needed by another.

- [PaTiSuite](https://github.com/patpaskoch/PaTiSuite) – optional control panel to show and hide the PaTi windows
- [PaTiHeal](https://github.com/patpaskoch/PaTiHeal) – healing: party frames, heal target, click casting, HoTs, dispels
- [PaTiAuras](https://github.com/patpaskoch/PaTiAuras) – buffs, procs, tracking, group buffs and weapon imbues
- [PaTiTank](https://github.com/patpaskoch/PaTiTank) – tank HUD and aggro monitor
- [PaTiRota](https://github.com/patpaskoch/PaTiRota) – your own skill priority with cooldowns and fixed cast buttons
- [PaTiGroup](https://github.com/patpaskoch/PaTiGroup) – party awareness: tank, healer, roles and the tank's target
- **PaTiLead** – lead the group: raid markers, ready check and pull timer *(this addon)*
- [PaTiQuest](https://github.com/patpaskoch/PaTiQuest) – selected quest and its objectives
- [PaTiDungeon](https://github.com/patpaskoch/PaTiDungeon) – instance, group and combat status
- [PaTiSocial](https://github.com/patpaskoch/PaTiSocial) – "Party Social": quick emote and message buttons
- [PaTiAlerts](https://github.com/patpaskoch/PaTiAlerts) – one window for open problems

### Goes well with (optional)

- [PaTiGroup](https://github.com/patpaskoch/PaTiGroup) – shows everyone the tank's target and its marker
- [PaTiSuite](https://github.com/patpaskoch/PaTiSuite) – shows and hides this window together with the other PaTi windows

## Installation
1. Download the release zip (`PaTiLead-<version>.zip`).
2. Unpack it and copy the folder `PaTiLead` into `World of Warcraft/<client>/Interface/AddOns/`.
3. Start WoW and enable PaTiLead in the AddOns list.

## First steps
- Target an enemy, click a marker
- `/plead settings` → marker order; the "Key bindings" section shows where to bind keys
- `/plead test` shows example data

## Settings
`/plead settings` or ••• → Settings: pull buttons, group info, note, window lock, language, scale, marker
order, and the **Key bindings** note with the menu path.
- **Window:** panel opacity (30–100 %)

## Commands
`/plead` or `/patilead` — alone or `toggle`: show/hide · `settings` · `test` · `show` · `hide` · `lock` · `unlock` ·
`reset` (position) · `debug` · `version` · `about` · `changelog`

The bar cannot be shown, hidden, collapsed or rearranged in combat (it has secure buttons).

## Known limitations
- Markers, Reset All and key bindings are not yet tested in game since the rework.
- Up to version 0.4 the old PaTiGroup created the macro `PaTiG_Reset`. It is no longer used or changed; you may
  delete it (`/plead debug` shows whether it still exists).

## Development

Architecture, tests and engineering rules of the suite: [PaTiAdmin](https://github.com/patpaskoch/PaTiAdmin). PaTiAdmin is not a WoW addon — players do not install it. The shared UI code (PaTiShared) is already embedded in this addon's `Shared/` folder; there is nothing extra to install.

## License
MIT — see [LICENSE](LICENSE). Copyright (c) 2026 Patrick Koch.
