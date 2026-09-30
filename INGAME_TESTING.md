# Ingame Testing – PaTiGroup

World of Warcraft: Forever
Interface: 16001

Diese Datei dokumentiert ausschließlich Tests im echten WoW-Client.

Automatisierte Tests, CI und Code Review zählen NICHT als Ingame-Verifikation.
Regeln und Eintragen von Ergebnissen: [PaTiAdmin/docs/TESTING.md](https://github.com/patpaskoch/PaTiAdmin/blob/main/docs/TESTING.md#in-game-test-files).

## Legende

- [ ] offen / noch nicht bestätigt
- [x] vom Owner im echten Client bestätigt
- ❌ FAIL = im echten Client fehlgeschlagen
- 🔧 FIX IMPLEMENTED = Codefix vorhanden, Retest noch offen
- ✅ VERIFIED = erfolgreich im echten Client bestätigt
- MANUAL RETEST REQUIRED = erneuter Test notwendig

## Installation / Laden

- [ ] PT-GROUP-001 Fresh Install aus dem Release-ZIP: genau ein Ordner `PaTiGroup/`, Addon lädt allein
- [ ] PT-GROUP-002 PaTiGroup erscheint in der AddOn-Liste mit Beschreibung
- [ ] PT-GROUP-003 Icon in der AddOn-Liste korrekt, keine weiße oder fehlende Textur
- [ ] PT-GROUP-004 Login ohne Lua-Fehler
- [ ] PT-GROUP-005 `/reload` ohne Lua-Fehler

## Fenster

- [ ] PT-GROUP-010 `/pg`, `/ptg`, `/patigroup` und `/pg toggle` blenden das Fenster ein und aus; `/pg show`, `/pg hide`
- [ ] PT-GROUP-011 Fenster am Header verschieben (entsperrt)
- [ ] PT-GROUP-012 Position bleibt nach `/reload`
- [ ] PT-GROUP-013 Lock/Unlock (••• und `/pg lock` / `unlock`): gesperrt nicht verschiebbar
- [ ] PT-GROUP-014 Größe (Scale) wirkt
- [ ] PT-GROUP-015 Einstellungen öffnen (`/pg settings` und •••) und speichern: Pull-Buttons, Gruppeninfo, Notiz,
  Marker-Reihenfolge
- [ ] PT-GROUP-016 Collapse/Expand über •••, Zustand bleibt nach `/reload`
- [ ] PT-GROUP-017 Test Mode `/pg test` zeigt Beispieldaten
- [ ] PT-GROUP-018 Panel-Deckkraft 30–100 %: nur der Hintergrund ändert sich
- [ ] PT-GROUP-019 Keine Einrast-Einstellung mehr, Fenster frei verschiebbar
- [ ] PT-GROUP-020 `/pg reset` setzt die Position zurück; `/pg about`, `/pg changelog` ohne Fehler

## SavedVariables

- [ ] PT-GROUP-030 Einstellungen und Notiz bleiben nach `/reload`
- [ ] PT-GROUP-031 Einstellungen bleiben nach Relog
- [ ] PT-GROUP-032 Update mit alten Einstellungen (0.4 oder älter): Werte bleiben, eine alte Strg+Linksklick-Belegung
  funktioniert weiter
- [ ] PT-GROUP-033 „Standard wiederherstellen“ setzt die Einstellungen zurück

## Sprachen

- [ ] PT-GROUP-040 deDE: alle Texte deutsch
- [ ] PT-GROUP-041 Sprache enUS in den Einstellungen: nach `/reload` englisch
- [ ] PT-GROUP-042 zhCN/zhTW/koKR: Englisch als Rückfall, keine Schlüsselnamen oder Kästchen
- [ ] PT-GROUP-043 Keine abgeschnittenen wichtigen Texte (deDE), auch der Tastenbelegungs-Hinweis

## Marker

- [ ] PT-GROUP-050 Alle 8 Marker setzen jeweils den richtigen Marker auf das aktuelle Ziel
- [ ] PT-GROUP-051 Entfernen (Clear) nimmt den Marker vom Ziel
- [ ] PT-GROUP-052 Reset All entfernt alle acht Marker von allen Zielen
- [ ] PT-GROUP-053 Auswahl und Reihenfolge der Marker aus den Einstellungen gilt

## Ready Check / Pull Timer

- [ ] PT-GROUP-060 Ready Check startet (als Leiter oder Assistent)
- [ ] PT-GROUP-061 Ready-Check-Ergebnis erscheint wie gewohnt in WoW
- [ ] PT-GROUP-062 Pull 3
- [ ] PT-GROUP-063 Pull 5
- [ ] PT-GROUP-064 Pull 10
- [ ] PT-GROUP-065 Ohne Gruppe, ohne Leitung/Assistent oder im Kampf: Klick auf Ready Check/Pull tut nichts
- [ ] PT-GROUP-066 Pull-Buttons in den Einstellungen ausblendbar

## Rollen / Leader / Assist

- [ ] PT-GROUP-070 Aktuelles Ziel mit seinem Marker wird angezeigt
- [ ] PT-GROUP-071 Gruppenleiter wird angezeigt
- [ ] PT-GROUP-072 Assistenten werden angezeigt
- [ ] PT-GROUP-073 Rollenanzahl stimmt und ändert sich bei Gruppenänderung
- [ ] PT-GROUP-074 Notiz wird angezeigt und gespeichert (nur lokal)

## Keybindings

- [ ] PT-GROUP-080 Einträge (alle Marker, Entfernen, PaTiGroup anzeigen/ausblenden) im echten WoW-Tastaturbelegungs-Menü
- [ ] PT-GROUP-081 Der in den Einstellungen genannte Menüpfad stimmt (echten Pfad melden)
- [ ] PT-GROUP-082 Gesetzte Tasten funktionieren
- [ ] PT-GROUP-083 Das Addon setzt keine Taste von selbst
- [ ] PT-GROUP-084 Das Addon erstellt oder ändert kein Makro (`/pg debug` zeigt, ob `PaTiG_Reset` noch existiert)

## Combat / Sicherheit

- [ ] PT-GROUP-090 Kein Lua-Fehler im Kampf
- [ ] PT-GROUP-091 Keine `ADDON_ACTION_BLOCKED` / `ADDON_ACTION_FORBIDDEN`
- [ ] PT-GROUP-092 `taint.log` (`/console taintLog 1`) ohne PaTiGroup-Eintrag
- [ ] PT-GROUP-093 Im Kampf: Ausblenden, Collapse, Test Mode gesperrt mit Hinweis; Marker-Reihenfolge und Größe
  werden erst nach dem Kampf angewendet
- [ ] PT-GROUP-094 Marker funktionieren im Kampf

## Combined

- [ ] PT-GROUP-100 Zusammen mit allen PaTi-Addons geladen: kein Lua-Fehler
- [ ] PT-GROUP-101 Keine Slash-Command-Kollision: `/pg`, `/ptg`, `/patigroup` antworten nur PaTiGroup
- [ ] PT-GROUP-102 Eigene Einstellungen speichern nur PaTiGroup-Werte; Fenster erscheint in PaTiSuite
