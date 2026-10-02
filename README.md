# Claude šablonas

GitHub šablonas naujiems projektams. Kiekvienas iš jo sukurtas repo iš karto turi Claude taisykles ir 27 skill'us.

**Kas yra skill'as?** Tai instrukcijų lapelis Claude'ui: kaip gerai atlikti vieną darbą. Claude jį pasiima pats, kai darbas tinka. Kaip receptas iš receptų knygos: kai kepi pyragą, atsiverti pyrago receptą.

## Kas viduje

```
.claude/
├── settings.json             ← saugo nuo dublikatų, išjungia Superpowers telemetriją
├── atnaujinti-skills.sh      ← vienu paleidimu atnaujina skill'us
└── skills/                   ← 27 skill'ai
    ├── brainstorming, writing-plans, test-driven-development, ...
    │                         ← 15 Superpowers skill'ų (darbo eiga)
    ├── ponytail, ponytail-review, ponytail-audit, ...
    │                         ← 6 Ponytail skill'ai (paprastesnis kodas)
    ├── impeccable            ← gražus svetainių dizainas
    ├── diagram-design        ← diagramos ir schemos
    ├── humanizer             ← tekstas, kuris neskamba kaip AI
    ├── security-audit        ← saugumo patikra
    ├── i-have-adhd           ← trumpi atsakymai žingsniais
    └── lietuviskas-tekstas   ← tavo lietuviško teksto taisyklės
CLAUDE.md                     ← projekto taisyklės AI
.gitattributes                ← kad skriptai veiktų ir Windows'e
.gitignore
README.md
```

## Skill'ai: ką daro ir kaip juos kviesti

Daugumą skill'ų Claude pasiima pats. Kai kuriuos gali iškviesti ir ranka, parašęs `/vardas`.

| Skill'as | Ką daro (paprastai) | Kaip kviesti | Autorius |
|---|---|---|---|
| **Superpowers** (15 skill'ų) | Prieš darbą paklausia ir suplanuoja, testus rašo pirma, klaidų ieško nuosekliai, prieš sakydamas „padaryta“ — patikrina | Pats | [obra/superpowers](https://github.com/obra/superpowers) |
| **Ponytail** (6 skill'ai) | Rašo kuo mažiau kodo. Šiame šablone — švelnus `lite` lygis: pasiūlo paprastesnį variantą, o renkiesi tu | Pats; `/ponytail-review`, `/ponytail-audit`; išjungti — „stop ponytail“ | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) |
| **Impeccable** | Padeda daryti gražias svetaines: dizaino patikra ir 24 komandos | `/impeccable init` (pirmą kartą), `/impeccable polish`, `/impeccable audit` | [pbakaus/impeccable](https://github.com/pbakaus/impeccable) |
| **Diagram Design** | Nupiešia diagramas (daugiau nei 40 rūšių) kaip HTML/SVG failus | „Nupiešk diagramą...“ | [cathrynlavery/diagram-design](https://github.com/cathrynlavery/diagram-design) |
| **Humanizer** | Perrašo tekstą, kad neskambėtų kaip AI (ieško 26 požymių). Lietuviškam tekstui svarbesnis `lietuviskas-tekstas`, nes Humanizer trintų teisingus lietuviškus brūkšnius (—) ir kabutes („…“) | `/humanizer` | [blader/humanizer](https://github.com/blader/humanizer) |
| **Security Audit** | Ieško saugumo spragų kode. Sukūrė Cloudflare | „Padaryk saugumo auditą“ | [cloudflare/security-audit-skill](https://github.com/cloudflare/security-audit-skill) |
| **I Have ADHD** | Trumpi atsakymai: pirma veiksmas, žingsniai sunumeruoti | `/i-have-adhd`; išjungti — „stop adhd mode“ | [ayghri/i-have-adhd](https://github.com/ayghri/i-have-adhd) |
| **lietuviskas-tekstas** | Lietuviško teksto taisyklės: kabutės, datos, pinigai, mygtukai | Pats | Tavo |

## Kodėl skill'ai nukopijuoti, o ne įdiegti kaip pluginai

- **Pluginas** — kaip programėlė: ją reikia įsidiegti kiekviename kompiuteryje atskirai. O claude.ai/code (naršyklėje ar telefone) projekto pluginai išvis neveikia.
- **Nukopijuotas skill'as** — kaip knyga kuprinėje: keliauja kartu su projektu ir veikia visur: terminale, VS Code, naršyklėje, telefone.
- **Saugiau:** kopija pati nepasikeičia. Kai atnaujini, prieš priimdamas pakeitimus matai juos `git diff`.

Prieš dedant į šabloną buvo patikrinta, ar skill'ai siunčia ką nors į internetą, paleidžia automatines komandas ar turi paslėptų nurodymų Claude'ui. Nieko pavojingo nerasta. Vienintelė išimtis, kurios viduje nematyti: Impeccable variklis, kurį jis atsisiunčia iš savo GitHub (žr. „Svarbu“).

## Kaip paversti šablonu (vieną kartą)

GitHub: **Settings** → **General** → pažymėk **Template repository**.

## Kaip naudoti

Naršyklėje: **Use this template** → **Create a new repository**.

Arba terminale:
```
gh repo create naujas-projektas --template brutall100/claude-skills-template --private --clone
```

Tada atidaryk `CLAUDE.md` ir užpildyk projekto informaciją.

Pirmą kartą atidarius projektą, Claude Code paklaus, ar pasitiki šiuo aplanku. Atsakyk „taip“: tik tada įsijungs projekto nustatymai.

## Kaip atnaujinti skill'us

```
bash .claude/atnaujinti-skills.sh
git diff --stat
```

Scenarijus atsisiunčia naujausias versijas iš autorių GitHub ir pakeičia senas kopijas. Jei kas nors nepavyksta (pvz., nėra interneto), projekte nieko nepakeičia. Jei nauja versija nepatinka, dar nepadaręs commit sugrąžink senąją: `git checkout -- .claude/skills` (naujai atsiradusius aplankus ištrink ranka).

- Kiekviename nukopijuotame skill'e yra failas `.saltinis`: iš kur skill'as ir kokia jo versija.
- Tavo paties skill'ų (be `.saltinis` failo) scenarijus neliečia.
- Nukopijuotų skill'ų ranka nekeisk: kitą kartą atnaujinus pakeitimai dings. Nori, kad skill'as elgtųsi kitaip? Įrašyk taisyklę į `CLAUDE.md` skyrių „Skill'ai“: ji svarbesnė už skill'us. Taip čia padaryta su Ponytail `lite` ir Humanizer.
- Atnaujink šabloną, ir visi nauji projektai gaus naujas versijas. Seną projektą atnaujinsi, paleidęs tą patį scenarijų jame.
- Windows'e scenarijų paleisk per Git Bash.

## Kaip pridėti naują skill

Sukurk aplanką `.claude/skills/<pavadinimas>/` ir jame `SKILL.md`:

```markdown
---
name: pavadinimas
description: Kada AI turi naudoti šį skill (viena aiški eilutė).
---

# Instrukcijos
...
```

## Svarbu

- Nauji repo gauna šablono **kopiją**. Pakeitus šabloną, seni repo nepasikeis.
- `.claude/settings.json` šiame projekte išjungia tuos pačius skill'us, įdiegtus kaip pluginus (jei kada nors juos įsidiegei kompiuteryje). Taip jie nesidubliuoja su kopijomis. Jei kurio nors plugino norisi, ištrink jo eilutę.
- Superpowers telemetrija išjungta (`SUPERPOWERS_DISABLE_TELEMETRY`). Kai naudojamas pasirenkamas „vaizdinis pagalbininkas“, ji įkelia autorių logotipą, kad jie suskaičiuotų naudotojus. Jei nori jiems padėti, ištrink tą eilutę.
- Superpowers planus ir aprašymus saugo aplanke `docs/superpowers/`.
- Impeccable pirmą kartą atsisiunčia savo variklį iš savo GitHub ir patikrina jo kontrolinę sumą.
- Security Audit ataskaitas pagal nutylėjimą rašo už projekto ribų: `~/security-audit-skill/<projektas>/`. Jam reikia Node.js.

## Licencijos

Kiekvieno nukopijuoto skill'o aplanke yra jo autoriaus licencija (`LICENSE`). Visi nukopijuoti skill'ai turi MIT licenciją, išskyrus Impeccable: jo licencija Apache-2.0 (kartu su `NOTICE.md`).
