# PaTiGroup

Zielmarker, Ready Check und Pull-Countdown für den WoW-Forever-Client (Interface 16001).
Du wählst selbst ein Ziel und klickst einen Marker – PaTiGroup markiert, belegt und erstellt nichts automatisch.

## Funktionen
- Alle acht Zielmarker plus „Entfernen“; welche Marker in welcher Reihenfolge erscheinen, legst du in den Einstellungen fest
- „Alle entfernen“ nimmt alle acht Marker von allen Zielen (führt `/tm`-Befehle direkt über einen geschützten Button aus)
- Ready Check sowie Pull 3 / 5 / 10 für Gruppenleiter und Assistenten (Pull-Buttons abschaltbar)
- Aktuelles Ziel mit seinem Marker, Gruppenleitung und Rollen (Tank / Heiler / Schaden)
- Kurze Notiz, nur lokal auf diesem PC gespeichert
- Menü `•••`: Einstellungen, Sperren, Testmodus, Ausblenden; Position, Größe und Sprache werden gespeichert

## Tastenbelegung
Spielmenü → Tastaturbelegung → **PaTiGroup**: jeder Marker, „Entfernen“ und „Ein-/Ausblenden“.
PaTiGroup vergibt **keine** Taste von selbst. Bis Version 0.4 wurde Strg + Linksklick automatisch auf den
Totenkopf gelegt, falls frei – eine solche vorhandene Belegung funktioniert weiter und lässt sich dort ändern.

## Makro
Bis Version 0.4 legte PaTiGroup das Charakter-Makro `PaTiG_Reset` an. Das ist nicht mehr nötig und wird weder
erstellt noch verändert; ein vorhandenes Makro kannst du löschen (`/pg debug` zeigt, ob es noch existiert).

## Befehle
`/pg`, `/ptg`, `/patigroup` — ohne Zusatz ein-/ausblenden; `show`, `hide`, `test`, `lock`, `unlock`, `reset` (Position),
`settings`, `debug`, `version`, `about`, `changelog`. Im Kampf lässt sich die Leiste nicht ein-/ausblenden oder umbauen.
