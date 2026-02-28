#!/usr/bin/env zsh
# add_all_nominateds.sh
# Usage:
#   EMAIL=you@example.com PASSWORD=yourpassword ./add_all_nominateds.sh
#
# Requires: curl, jq, awk

BASE="http://localhost:8080"
LOGIN_URL="$BASE/login"
CATEGORIES_URL="$BASE/categories"
ADD_URL="$BASE/add_nominateds_names"
COOKIE_JAR="./cookies.txt"

if [[ -z "$EMAIL" || -z "$PASSWORD" ]]; then
  echo "Please set EMAIL and PASSWORD environment variables. Example:"
  echo "  EMAIL=you@example.com PASSWORD=secret $0"
  exit 1
fi

# cleanup old cookie jar
rm -f "$COOKIE_JAR"

echo "Logging in as $EMAIL..."
curl -c "$COOKIE_JAR" -s -X POST "$LOGIN_URL" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}" > /dev/null

# extract csrf token from cookie jar
CSRF=$(awk '/csrf_token/{print $7; exit}' "$COOKIE_JAR")
if [[ -z "$CSRF" ]]; then
  echo "Failed to obtain csrf_token cookie. Check login response and COOKIE_SECURE / http/https settings."
  exit 1
fi
echo "Got CSRF token: $CSRF"

# helper: lookup category id by name
get_cat_id() {
  local name="$1"
  curl -b "$COOKIE_JAR" -s "$CATEGORIES_URL" | jq -r --arg name "$name" '.[] | select(.name==$name) | .id' | head -n1
}

# helper: post names for a category
post_names() {
  local category="$1"
  shift
  local -a names=("$@")
  if [[ ${#names[@]} -eq 0 ]]; then
    echo "No names provided for category $category"
    return
  fi

  local cid
  cid=$(get_cat_id "$category")
  if [[ -z "$cid" ]]; then
    echo "Category '$category' not found. Skipping."
    return
  fi
  echo "Category '$category' -> id $cid"

  # build JSON array from names
  local names_json
  names_json=$(printf '%s\n' "${names[@]}" | jq -R . | jq -s .)

  # build body and POST
  local body
  body=$(jq -n --arg id "$cid" --argjson names "$names_json" '{category_id:($id|tonumber), names:$names}')
  echo "Posting ${#names[@]} nominateds to category '$category'..."
  curl -b "$COOKIE_JAR" -s -X POST "$ADD_URL" \
    -H "Content-Type: application/json" \
    -H "X-CSRF-Token: $CSRF" \
    -d "$body" | jq
  echo
}

# Define the categories and names (from your list)
declare -A CATS

CATS["3"]="Timothée Chalamet – Marty Supreme|Leonardo DiCaprio – One Battle After Another|Ethan Hawke – Blue Moon|Michael B. Jordan – Sinners|Wagner Moura – The Secret Agent"
CATS["Best Actress"]="Jessie Buckley – Hamnet|Rose Byrne – If I Had Legs I'd Kick You|Kate Hudson – Song Sung Blue|Renate Reinsve – Sentimental Value|Emma Stone – Bugonia"
CATS["Best Supporting Actor"]="Benicio Del Toro – One Battle After Another|Jacob Elordi – Frankenstein|Delroy Lindo – Sinners|Sean Penn – One Battle After Another|Stellan Skarsgård – Sentimental Value"
CATS["Best Supporting Actress"]="Elle Fanning – Sentimental Value|Inga Ibsdotter Lilleaas – Sentimental Value|Amy Madigan – Weapons|Wunmi Mosaku – Sinners|Teyana Taylor – One Battle After Another"
CATS["Best Director"]="Chloé Zhao – Hamnet|Josh Safdie – Marty Supreme|Paul Thomas Anderson – One Battle After Another|Joachim Trier – Sentimental Value|Ryan Coogler – Sinners"
CATS["Best Animated Feature Film"]="Arco|Elio|KPop Demon Hunters|Little Amélie or the Character of Rain|Zootopia 2"
CATS["Best Animated Short Film"]="Butterfly|Forevergreen|The Girl Who Cried Pearls|Retirement Plan|The Three Sisters"
CATS["Best Documentary Feature Film"]="The Alabama Solution|Come See Me in the Good Light|Cutting Through Rocks|Mr. Nobody Against Putin|The Perfect Neighbor"
CATS["Best Documentary Short Film"]="All the Empty Rooms|Armed Only with a Camera: The Life and Death of Brent Renaud|Children No More: \"Were and Are Gone\"|The Devil Is Busy|Perfectly a Strangeness"
CATS["Best Live Action Short Film"]="Butcher's Stain|A Friend of Dorothy|Jane Austen's Period Drama|The Singers|Two People Exchanging Saliva"
CATS["Best Casting"]="Hamnet – Nina Gold|Marty Supreme – Jennifer Venditti|One Battle After Another – Cassandra Kulukundis|The Secret Agent – Gabriel Domingues|Sinners – Francine Maisler"
CATS["Best Cinematography"]="Frankenstein – Dan Laustsen|Marty Supreme – Darius Khondji|One Battle After Another – Michael Bauman|Sinners – Autumn Durald Arkapaw|Train Dreams – Adolpho Veloso"
CATS["Best Costume Design"]="Avatar: Fire and Ash – Deborah L. Scott|Frankenstein – Kate Hawley|Hamnet – Malgosia Turzanska|Marty Supreme – Miyako Bellizzi|Sinners – Ruth E. Carter"
CATS["Best Film Editing"]="F1 – Stephen Mirrione|Marty Supreme – Ronald Bronstein & Josh Safdie|One Battle After Another – Andy Jurgensen|Sentimental Value – Olivier Bugge Coutté|Sinners – Michael P. Shawver"
CATS["Best International Feature Film"]="The Secret Agent (Brazil)|It Was Just an Accident (France)|Sentimental Value (Norway)|Sirāt (Spain)|The Voice of Hind Rajab (Tunisia)"
CATS["Best Makeup and Hairstyling"]="Frankenstein – Mike Hill, Jordan Samuel & Cliona Furey|Kokuho – Kyoko Toyokawa, Naomi Hibino & Tadashi Nishimatsu|Sinners – Ken Diaz, Mike Fontaine & Shunika Terry|The Smashing Machine – Kazu Hiro, Glen Griffin & Bjoern Rehbein|The Ugly Stepsister – Thomas Foldberg & Anne Cathrine Sauerberg"

# Iterate and post each category
for category in "${(k)CATS}"; do
  IFS='|' read -r -A names <<< "${CATS[$category]}"
  post_names "$category" "${names[@]}"
done

echo "Done."