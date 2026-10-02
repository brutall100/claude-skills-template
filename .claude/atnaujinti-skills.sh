#!/usr/bin/env bash
# Lietuviškos kabutės „…“ pranešimuose yra sąmoningos (teksto viduje).
# shellcheck disable=SC1111
#
# atnaujinti-skills.sh: parsiunčia naujausias skill'ų versijas iš jų autorių
# GitHub repozitorijų ir nukopijuoja jas į .claude/skills/.
#
# Paleidimas (iš bet kurio aplanko):
#   bash .claude/atnaujinti-skills.sh
#
# Po to pažiūrėk, kas pasikeitė, ir tik tada daryk commit:
#   git status
#   git diff --stat
#
# Kaip veikia:
#   1. Atsisiunčia kiekvieną šaltinį į laikiną aplanką (projekte dar nieko nekeičia).
#   2. Paruošia skill'ų aplankus ir prideda autorių licencijos failus.
#   3. Kiekviename skill'o aplanke palieka failą .saltinis: iš kur ir kokia versija.
#   4. Tik jei viskas pavyko, pakeičia senas kopijas naujomis.
# Tavo paties skill'ų (aplankų be .saltinis failo) scenarijus neliečia.
#
# Reikia: bash ir git. Windows'e paleisk per Git Bash.

set -euo pipefail

# Šaltiniai. Formatas: "savininkas/repo|kelias repozitorijoje|skill'o aplanko vardas"
#   - kelias su "/*" gale: imami visi to aplanko poaplankiai, kuriuose yra SKILL.md;
#   - kelias į failą (SKILL.md): failas įdedamas į nurodytą aplanką.
# Norėdamas pašalinti skill'ų rinkinį, ištrink jo eilutę ir paleisk scenarijų.
SALTINIAI=(
  "obra/superpowers|skills/*|"
  "DietrichGebert/ponytail|skills/*|"
  "ayghri/i-have-adhd|skills/i-have-adhd|i-have-adhd"
  "cloudflare/security-audit-skill|skills/security-audit|security-audit"
  "cathrynlavery/diagram-design|skills/diagram-design|diagram-design"
  "blader/humanizer|SKILL.md|humanizer"
  "pbakaus/impeccable|.claude/skills/impeccable|impeccable"
)

klaida() {
  echo "Klaida: $*" >&2
  echo "Projekte niekas nepakeista." >&2
  exit 1
}

command -v git >/dev/null 2>&1 || klaida "nerastas git. Įsidiek jį ir bandyk dar kartą."

SKILLS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/skills"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
PARUOSTA="$TMP/paruosta"
mkdir -p "$PARUOSTA" "$SKILLS"

# Paruošia vieną skill'ą laikiname aplanke.
# Argumentai: repo, commit, data, šaltinio kelias diske, kelias repozitorijoje, vardas, klono aplankas
paruosk() {
  local repo="$1" commit="$2" data="$3" saltinis="$4" kelias="$5" vardas="$6" klonas="$7"
  local tikslas="$PARUOSTA/$vardas" f yra_licencija=""

  if [ -e "$tikslas" ]; then
    klaida "du šaltiniai turi skill'ą tuo pačiu vardu „${vardas}“."
  fi
  mkdir -p "$tikslas"

  if [ -d "$saltinis" ]; then
    cp -R "$saltinis/." "$tikslas/"
  elif [ -f "$saltinis" ]; then
    cp "$saltinis" "$tikslas/SKILL.md"
  else
    klaida "$repo neturi „${kelias}“. Gal autorius pakeitė failų išdėstymą?"
  fi
  [ -f "$tikslas/SKILL.md" ] || klaida "$repo/$kelias neturi SKILL.md failo."

  # Autorių licencijos failai privalo keliauti kartu su kopija.
  for f in "$klonas"/LICENSE* "$klonas"/LICENCE* "$klonas"/COPYING* "$klonas"/NOTICE* "$klonas"/THIRD_PARTY_LICENSES*; do
    [ -f "$f" ] || continue
    [ -e "$tikslas/$(basename "$f")" ] || cp "$f" "$tikslas/"
  done
  for f in "$tikslas"/LICENSE* "$tikslas"/LICENCE* "$tikslas"/COPYING*; do
    if [ -f "$f" ]; then yra_licencija=1; fi
  done
  [ -n "$yra_licencija" ] || klaida "$repo neturi licencijos failo, todėl jo kopijuoti negalima."

  cat > "$tikslas/.saltinis" <<EOF
# Šį skill'ą nukopijavo .claude/atnaujinti-skills.sh.
# Ranka nekeisk: kitą kartą atnaujinus pakeitimai dings.
repo: https://github.com/$repo
path: $kelias
commit: $commit
commit_date: $data
EOF
}

# 1–2. Atsisiunčiam ir paruošiam viską laikinai.
n=0
for irasas in "${SALTINIAI[@]}"; do
  IFS='|' read -r repo kelias vardas <<<"$irasas"
  n=$((n + 1))
  klonas="$TMP/repo-$n"

  echo "→ Siunčiu $repo ..."
  # core.autocrlf=false: failai atsisiunčiami tokie, kokie yra (Windows'e skriptai nesugenda).
  # GIT_TERMINAL_PROMPT=0: git neklausia slaptažodžio, jei repozitorijos nebėra.
  GIT_TERMINAL_PROMPT=0 GIT_LFS_SKIP_SMUDGE=1 \
    git -c core.autocrlf=false -c core.eol=lf clone --quiet --depth 1 "https://github.com/$repo.git" "$klonas" \
    || klaida "nepavyko atsisiųsti $repo. Patikrink internetą ir ar ši repozitorija dar egzistuoja."
  commit="$(git -C "$klonas" rev-parse HEAD)"
  data="$(git -C "$klonas" log -1 --format=%cs)"

  case "$kelias" in
    */\*)
      tevas="${kelias%/\*}"
      kiek=0
      for d in "$klonas/$tevas"/*/; do
        [ -f "$d/SKILL.md" ] || continue
        d="${d%/}"
        paruosk "$repo" "$commit" "$data" "$d" "$tevas/$(basename "$d")" "$(basename "$d")" "$klonas"
        kiek=$((kiek + 1))
      done
      [ "$kiek" -gt 0 ] || klaida "$repo aplanke „${tevas}“ nerasta nė vieno skill'o."
      ;;
    *)
      paruosk "$repo" "$commit" "$data" "$klonas/$kelias" "$kelias" "$vardas" "$klonas"
      ;;
  esac
done

# 3. Saugiklis: neperrašom tavo paties skill'ų.
for naujas in "$PARUOSTA"/*/; do
  vardas="$(basename "$naujas")"
  if [ -d "$SKILLS/$vardas" ] && [ ! -f "$SKILLS/$vardas/.saltinis" ]; then
    klaida ".claude/skills/$vardas yra tavo paties skill'as, o šaltinis turi tokį patį vardą. Pervadink savąjį ir paleisk iš naujo."
  fi
done

# 4. Keičiam senas kopijas naujomis (liečiam tik aplankus su .saltinis).
for senas in "$SKILLS"/*/; do
  [ -f "$senas/.saltinis" ] || continue
  rm -rf -- "${senas%/}"
done
for naujas in "$PARUOSTA"/*/; do
  mv -- "${naujas%/}" "$SKILLS/"
done

echo
echo "Atnaujinta. Nukopijuoti skill'ai:"
for d in "$SKILLS"/*/; do
  [ -f "$d/.saltinis" ] || continue
  printf '  %-32s %s @ %s\n' "$(basename "$d")" \
    "$(sed -n 's#^repo: https://github.com/##p' "$d/.saltinis")" \
    "$(sed -n 's/^commit: \(.......\).*/\1/p' "$d/.saltinis")"
done
echo
echo "Toliau: pažiūrėk pakeitimus (git status, git diff --stat). Jei viskas gerai, padaryk commit."
