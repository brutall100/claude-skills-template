# Projekto taisyklės AI

Šį failą Claude perskaito kiekvienos sesijos pradžioje. Užpildyk jį pagal projektą.

## Apie projektą

- **Pavadinimas:** (įrašyk)
- **Kam skirtas:** (įrašyk, pvz. „kliento svetainė kirpyklai“)
- **Technologijos:** (įrašyk, pvz. Deno, PostgreSQL, HTML/CSS)

## Kaip dirbti

- Su manimi kalbėk lietuviškai, paprastai.
- Vartotojui matomi tekstai — lietuviškai (žr. skill `lietuviskas-tekstas`).
- Prieš didelius pakeitimus parodyk planą.
- Rašyk kuo paprastesnį kodą, kuris veikia.
- Neištrink duomenų ir nekeisk `.env` be mano leidimo.

## Komandos

- Paleisti: (įrašyk)
- Testai: (įrašyk)
- Diegimas: (įrašyk)

## Skill'ai

Skill'ai yra aplanke `.claude/skills/`. Jei jų patarimai prieštarauja vienas kitam, galioja šios taisyklės:

1. **Darbo eiga — Superpowers.** Prieš kurdamas paklausk ir suplanuok, testus rašyk pirma, klaidos priežasties ieškok nuosekliai, o prieš sakydamas „padaryta“ — patikrink.
2. **Kodo dydis — Ponytail, lygis `lite`.** Daryk, ko prašau, bet vienu sakiniu pasiūlyk paprastesnį variantą; renkuosi aš. Lygius `full` ar `ultra` naudok tik kai paprašysiu. Ponytail trumpina kodą, ne paaiškinimus: visada paaiškink, ką padarei ir kodėl.
3. **Lietuviškas tekstas — `lietuviskas-tekstas` svarbiau už `humanizer`.** Lietuviški brūkšniai (—) ir kabutės („…“) yra teisingi, jų netrink.
4. **`i-have-adhd`** — tik kai paprašau (`/i-have-adhd`).
5. **`security-audit`** — pilną saugumo auditą daryk tik kai paprašau.
6. Kai skill'e parašyta `superpowers:<vardas>`, tai skill'as `<vardas>` iš `.claude/skills/`. Failai, kuriuos mini žemiau įkeltas tekstas, yra aplanke `.claude/skills/using-superpowers/`.

Superpowers pagrindinės taisyklės (įkeliamos automatiškai kiekvienos sesijos pradžioje):

@.claude/skills/using-superpowers/SKILL.md
