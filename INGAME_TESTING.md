# Ingame Testing – PaTiLead

World of Warcraft: Forever
Interface: 16001

Diese Datei dokumentiert ausschließlich Tests im echten WoW-Client.

Automatisierte Tests, CI und Code Review zählen NICHT als Ingame-Verifikation.
Regeln und Eintragen von Ergebnissen: [PaTiAdmin/docs/TESTING.md](https://github.com/patpaskoch/PaTiAdmin/blob/main/docs/TESTING.md#in-game-test-files).

PaTiLead ist das frühere PaTiGroup (umbenannt 2026-10-02). Die alten `PT-GROUP-001…102` stehen unten als RETIRED
(Legacy) und werden nie wiederverwendet; kein früheres `[x]` wurde übertragen. Das neue PaTiGroup (Party Awareness)
zählt ab `PT-GROUP-200`.

## Legende

- [ ] offen / noch nicht bestätigt
- [x] vom Owner im echten Client bestätigt
- ❌ FAIL = im echten Client fehlgeschlagen
- 🔧 FIX IMPLEMENTED = Codefix vorhanden, Retest noch offen
- ✅ VERIFIED = erfolgreich im echten Client bestätigt
- MANUAL RETEST REQUIRED = erneuter Test notwendig

## Installation / Laden

- [ ] PT-LEAD-001 Fresh Install aus dem Release-ZIP: genau ein Ordner `PaTiLead/`, Addon lädt allein
- [ ] PT-LEAD-002 PaTiLead erscheint in der AddOn-Liste mit Beschreibung („Gruppe führen: …“)
- [ ] PT-LEAD-003 AddOn-Liste: noch ohne eigenes Icon, aber keine weiße oder fehlende Textur (eigene Grafik folgt)
- [ ] PT-LEAD-004 Login ohne Lua-Fehler
- [ ] PT-LEAD-005 `/reload` ohne Lua-Fehler
- [ ] PT-LEAD-006 Erster Start nach der Umbenennung: Standard-Einstellungen (alte PaTiGroup-Einstellungen werden
  bewusst nicht übernommen), keine Fehlermeldung; alter Ordner `PaTiGroup/` vorher durch den neuen ersetzt

## Fenster

- [ ] PT-LEAD-010 `/plead`, `/patilead` und `/plead toggle` blenden das Fenster ein und aus; `/plead show`, `/plead hide`
- [ ] PT-LEAD-011 Fenster am Header verschieben (entsperrt)
- [ ] PT-LEAD-012 Position bleibt nach `/reload`
- [ ] PT-LEAD-013 Lock/Unlock (••• und `/plead lock` / `unlock`): gesperrt nicht verschiebbar
- [ ] PT-LEAD-014 Größe (Scale) wirkt
- [ ] PT-LEAD-015 Einstellungen öffnen (`/plead settings` und •••) und speichern: Pull-Buttons, Gruppeninfo, Notiz,
  Marker-Reihenfolge
- [ ] PT-LEAD-016 Collapse/Expand über •••, Zustand bleibt nach `/reload`
- [ ] PT-LEAD-017 Test Mode `/plead test` zeigt Beispieldaten
- [ ] PT-LEAD-018 Panel-Deckkraft 30–100 %: nur der Hintergrund ändert sich
- [ ] PT-LEAD-020 `/plead reset` setzt die Position zurück; `/plead about`, `/plead changelog` ohne Fehler

## SavedVariables

- [ ] PT-LEAD-030 Einstellungen und Notiz bleiben nach `/reload` (`PaTiLeadDB`)
- [ ] PT-LEAD-031 Einstellungen bleiben nach Relog
- [ ] PT-LEAD-033 „Standard wiederherstellen“ setzt die Einstellungen zurück, Notiz bleibt

## Sprachen

- [ ] PT-LEAD-040 deDE: alle Texte deutsch
- [ ] PT-LEAD-041 Sprache enUS in den Einstellungen: nach `/reload` englisch
- [ ] PT-LEAD-042 zhCN/zhTW/koKR: Englisch als Rückfall, keine Schlüsselnamen oder Kästchen
- [ ] PT-LEAD-043 Keine abgeschnittenen wichtigen Texte (deDE), auch der Tastenbelegungs-Hinweis

## Marker

- [ ] PT-LEAD-050 Alle 8 Marker setzen jeweils den richtigen Marker auf das aktuelle Ziel
- [ ] PT-LEAD-051 Entfernen (Clear) nimmt den Marker vom Ziel
- [ ] PT-LEAD-052 Reset All entfernt alle acht Marker von allen Zielen
- [ ] PT-LEAD-053 Auswahl und Reihenfolge der Marker aus den Einstellungen gilt

## Ready Check / Pull Timer

- [ ] PT-LEAD-060 Ready Check startet (als Leiter oder Assistent)
- [ ] PT-LEAD-061 Ready-Check-Ergebnis erscheint wie gewohnt in WoW
- [ ] PT-LEAD-062 Pull 3
- [ ] PT-LEAD-063 Pull 5
- [ ] PT-LEAD-064 Pull 10
- [ ] PT-LEAD-065 Ohne Gruppe, ohne Leitung/Assistent oder im Kampf: Klick auf Ready Check/Pull tut nichts
- [ ] PT-LEAD-066 Pull-Buttons in den Einstellungen ausblendbar

## Rollen / Leader / Assist

- [ ] PT-LEAD-070 Aktuelles Ziel mit seinem Marker wird angezeigt
- [ ] PT-LEAD-071 Gruppenleiter wird angezeigt
- [ ] PT-LEAD-072 Assistenten werden angezeigt
- [ ] PT-LEAD-073 Rollenanzahl stimmt und ändert sich bei Gruppenänderung
- [ ] PT-LEAD-074 Notiz wird angezeigt und gespeichert (nur lokal)

## Keybindings

- [ ] PT-LEAD-080 Einträge (alle 8 Marker, Entfernen, PaTiLead anzeigen/ausblenden) im WoW-Tastaturbelegungs-Menü unter
  „PaTiLead“
- [ ] PT-LEAD-081 Der in den Einstellungen genannte Menüpfad stimmt (echten Pfad melden)
- [ ] PT-LEAD-082 Gesetzte Tasten funktionieren
- [ ] PT-LEAD-083 Das Addon setzt keine Taste von selbst
- [ ] PT-LEAD-084 Das Addon erstellt oder ändert kein Makro (`/plead debug` zeigt, ob `PaTiG_Reset` noch existiert)

## Combat / Sicherheit

- [ ] PT-LEAD-090 Kein Lua-Fehler im Kampf
- [ ] PT-LEAD-091 Keine `ADDON_ACTION_BLOCKED` / `ADDON_ACTION_FORBIDDEN`
- [ ] PT-LEAD-092 `taint.log` (`/console taintLog 1`) ohne PaTiLead-Eintrag
- [ ] PT-LEAD-093 Im Kampf: Ausblenden, Collapse, Test Mode gesperrt mit Hinweis; Marker-Reihenfolge und Größe
  werden erst nach dem Kampf angewendet
- [ ] PT-LEAD-094 Marker funktionieren im Kampf

## Combined

- [ ] PT-LEAD-100 Zusammen mit allen PaTi-Addons geladen: kein Lua-Fehler
- [ ] PT-LEAD-101 Keine Slash-Command-Kollision: `/plead`, `/patilead` antworten nur PaTiLead; `/pg` öffnet das neue
  PaTiGroup
- [ ] PT-LEAD-102 Eigene Einstellungen speichern nur PaTiLead-Werte; Fenster erscheint in PaTiSuite als „Lead“
- [ ] PT-LEAD-103 PaTiLead und das neue PaTiGroup gleichzeitig: beide Fenster getrennt, keine Einstellung des einen
  verändert das andere

## Legacy – frühere PaTiGroup-Tests (RETIRED)

Diese IDs gehörten der früheren PaTiGroup-Implementierung (heute PaTiLead). Sie bleiben als Historie stehen, werden
nie wiederverwendet und gelten weder für PaTiLead noch für das neue PaTiGroup.

### Legacy: Installation / Laden
- ~~PT-GROUP-001 Fresh Install aus dem Release-ZIP: genau ein Ordner `PaTiGroup/`, Addon lädt allein~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-001
- ~~PT-GROUP-002 PaTiGroup erscheint in der AddOn-Liste mit Beschreibung~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-002
- ~~PT-GROUP-003 Icon in der AddOn-Liste korrekt, keine weiße oder fehlende Textur~~
  - ✅ VERIFIED 2026-10-02
  - Owner: die Icons erscheinen im Spiel in der AddOn-Liste korrekt.
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); die Grafik gehört jetzt zum neuen PaTiGroup (dort PT-GROUP-203, offen), PaTiLead bekommt eine eigene (PT-LEAD-003)
- ~~PT-GROUP-004 Login ohne Lua-Fehler~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-004
- ~~PT-GROUP-005 `/reload` ohne Lua-Fehler~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-005

### Legacy: Fenster
- ~~PT-GROUP-010 `/pg`, `/ptg`, `/patigroup` und `/pg toggle` blenden das Fenster ein und aus; `/pg show`, `/pg hide`~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-010
- ~~PT-GROUP-011 Fenster am Header verschieben (entsperrt)~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-011
- ~~PT-GROUP-012 Position bleibt nach `/reload`~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-012
- ~~PT-GROUP-013 Lock/Unlock (••• und `/pg lock` / `unlock`): gesperrt nicht verschiebbar~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-013
- ~~PT-GROUP-014 Größe (Scale) wirkt~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-014
- ~~PT-GROUP-015 Einstellungen öffnen (`/pg settings` und •••) und speichern: Pull-Buttons, Gruppeninfo, Notiz, Marker-Reihenfolge~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-015
- ~~PT-GROUP-016 Collapse/Expand über •••, Zustand bleibt nach `/reload`~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-016
- ~~PT-GROUP-017 Test Mode `/pg test` zeigt Beispieldaten~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-017
- ~~PT-GROUP-018 Panel-Deckkraft 30–100 %: nur der Hintergrund ändert sich~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-018
- ~~PT-GROUP-019 Keine Einrast-Einstellung mehr, Fenster frei verschiebbar~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-019
- ~~PT-GROUP-020 `/pg reset` setzt die Position zurück; `/pg about`, `/pg changelog` ohne Fehler~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-020

### Legacy: SavedVariables
- ~~PT-GROUP-030 Einstellungen und Notiz bleiben nach `/reload`~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-030
- ~~PT-GROUP-031 Einstellungen bleiben nach Relog~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-031
- ~~PT-GROUP-032 Update mit alten Einstellungen (0.4 oder älter): Werte bleiben, eine alte Strg+Linksklick-Belegung funktioniert weiter~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-032
- ~~PT-GROUP-033 „Standard wiederherstellen“ setzt die Einstellungen zurück~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-033

### Legacy: Sprachen
- ~~PT-GROUP-040 deDE: alle Texte deutsch~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-040
- ~~PT-GROUP-041 Sprache enUS in den Einstellungen: nach `/reload` englisch~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-041
- ~~PT-GROUP-042 zhCN/zhTW/koKR: Englisch als Rückfall, keine Schlüsselnamen oder Kästchen~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-042
- ~~PT-GROUP-043 Keine abgeschnittenen wichtigen Texte (deDE), auch der Tastenbelegungs-Hinweis~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-043

### Legacy: Marker
- ~~PT-GROUP-050 Alle 8 Marker setzen jeweils den richtigen Marker auf das aktuelle Ziel~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-050
- ~~PT-GROUP-051 Entfernen (Clear) nimmt den Marker vom Ziel~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-051
- ~~PT-GROUP-052 Reset All entfernt alle acht Marker von allen Zielen~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-052
- ~~PT-GROUP-053 Auswahl und Reihenfolge der Marker aus den Einstellungen gilt~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-053

### Legacy: Ready Check / Pull Timer
- ~~PT-GROUP-060 Ready Check startet (als Leiter oder Assistent)~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-060
- ~~PT-GROUP-061 Ready-Check-Ergebnis erscheint wie gewohnt in WoW~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-061
- ~~PT-GROUP-062 Pull 3~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-062
- ~~PT-GROUP-063 Pull 5~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-063
- ~~PT-GROUP-064 Pull 10~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-064
- ~~PT-GROUP-065 Ohne Gruppe, ohne Leitung/Assistent oder im Kampf: Klick auf Ready Check/Pull tut nichts~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-065
- ~~PT-GROUP-066 Pull-Buttons in den Einstellungen ausblendbar~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-066

### Legacy: Rollen / Leader / Assist
- ~~PT-GROUP-070 Aktuelles Ziel mit seinem Marker wird angezeigt~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-070
- ~~PT-GROUP-071 Gruppenleiter wird angezeigt~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-071
- ~~PT-GROUP-072 Assistenten werden angezeigt~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-072
- ~~PT-GROUP-073 Rollenanzahl stimmt und ändert sich bei Gruppenänderung~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-073
- ~~PT-GROUP-074 Notiz wird angezeigt und gespeichert (nur lokal)~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-074

### Legacy: Keybindings
- ~~PT-GROUP-080 Einträge (alle Marker, Entfernen, PaTiGroup anzeigen/ausblenden) im echten WoW-Tastaturbelegungs-Menü~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-080
- ~~PT-GROUP-081 Der in den Einstellungen genannte Menüpfad stimmt (echten Pfad melden)~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-081
- ~~PT-GROUP-082 Gesetzte Tasten funktionieren~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-082
- ~~PT-GROUP-083 Das Addon setzt keine Taste von selbst~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-083
- ~~PT-GROUP-084 Das Addon erstellt oder ändert kein Makro (`/pg debug` zeigt, ob `PaTiG_Reset` noch existiert)~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-084

### Legacy: Combat / Sicherheit
- ~~PT-GROUP-090 Kein Lua-Fehler im Kampf~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-090
- ~~PT-GROUP-091 Keine `ADDON_ACTION_BLOCKED` / `ADDON_ACTION_FORBIDDEN`~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-091
- ~~PT-GROUP-092 `taint.log` (`/console taintLog 1`) ohne PaTiGroup-Eintrag~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-092
- ~~PT-GROUP-093 Im Kampf: Ausblenden, Collapse, Test Mode gesperrt mit Hinweis; Marker-Reihenfolge und Größe werden erst nach dem Kampf angewendet~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-093
- ~~PT-GROUP-094 Marker funktionieren im Kampf~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-094

### Legacy: Combined
- ~~PT-GROUP-100 Zusammen mit allen PaTi-Addons geladen: kein Lua-Fehler~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-100
- ~~PT-GROUP-101 Keine Slash-Command-Kollision: `/pg`, `/ptg`, `/patigroup` antworten nur PaTiGroup~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-101
- ~~PT-GROUP-102 Eigene Einstellungen speichern nur PaTiGroup-Werte; Fenster erscheint in PaTiSuite~~
  - RETIRED 2026-10-02 – Test der früheren PaTiGroup-Implementierung (jetzt PaTiLead); ersetzt durch PT-LEAD-102
