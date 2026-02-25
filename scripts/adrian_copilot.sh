#!/bin/bash

# ============================================================================
# adrian_copilot.sh
# ----------------------------------------------------------------------------
# - Packs project files for upload with minimal number of folders (3 files per
#   numbered folder) while keeping categories separated.
# - Categories under copilot_sources/:
#       root                (ONLY files physically in project root)
#       other               (any non-src/* files inside subdirectories)
#       src_main_java
#       src_main_resources
#       src_main_webapp
#       src_test_java
#       src_test_resources
#       src_test_webapp
# - Exclusions: .git/, .idea/, target/, ANY directory named 'copilot_sources*',
#               .gitignore, split_files*.sh
# - File naming inside numbered folders:
#       For root: keep original filename (e.g., pom.xml, README.md)
#       For all others: <relative path to category root> with '/' → '.' prefix
#       Examples:
#          src/main/java/com/x/A.java -> com.x.A.java
#          src/main/resources/config/app.yml -> config.app.yml
#          docs/guide.md (other) -> docs.guide.md
# ============================================================================

set -euo pipefail

# Maximum files per numbered folder (chat upload limit)
MAX_FILES=${MAX_FILES:-3}

OUTPUT_DIR="copilot_sources"

say() { printf '%s
' "$*"; }

CATEGORIES=(   "root"   "other"   "src_main_java"   "src_main_resources"   "src_main_webapp"   "src_test_java"   "src_test_resources"   "src_test_webapp" )

clean_output() {
  if [ -d "$OUTPUT_DIR" ]; then
    say "Cleaning old '$OUTPUT_DIR'..."
    rm -rf "$OUTPUT_DIR"
  fi
  mkdir -p "$OUTPUT_DIR"
  for c in "${CATEGORIES[@]}"; do
    mkdir -p "$OUTPUT_DIR/$c"
  done
}

# Classify a project-relative path into a category.
# Sets globals: CAT, BASE_PREFIX
classify_file() {
  local rel="$1"
  local dir
  dir=$(dirname -- "$rel")

  case "$rel" in
    src/main/java/*)
      CAT="src_main_java"; BASE_PREFIX="src/main/java/" ;;
    src/main/resources/*)
      CAT="src_main_resources"; BASE_PREFIX="src/main/resources/" ;;
    src/main/webapp/*)
      CAT="src_main_webapp"; BASE_PREFIX="src/main/webapp/" ;;
    src/test/java/*)
      CAT="src_test_java"; BASE_PREFIX="src/test/java/" ;;
    src/test/resources/*)
      CAT="src_test_resources"; BASE_PREFIX="src/test/resources/" ;;
    src/test/webapp/*)
      CAT="src_test_webapp"; BASE_PREFIX="src/test/webapp/" ;;
    *)
      if [ "$dir" = "." ]; then
        CAT="root"; BASE_PREFIX=""     # only true project-root files
      else
        CAT="other"; BASE_PREFIX=""     # any subdir not under src/*
      fi
      ;;
  esac
}

# Compute display filename stored inside the numbered folder
compute_display_name() {
  local rel="$1"
  local sub="$rel"
  local d b prefix

  if [ -n "$BASE_PREFIX" ]; then
    sub="${rel#${BASE_PREFIX}}"
  fi

  d="$(dirname -- "$sub")"
  b="$(basename -- "$sub")"

  case "$CAT" in
    root)
      printf '%s' "$b" ;;
    *)
      if [ "$d" = "." ]; then
        printf '%s' "$b"
      else
        prefix="${d//\//.}"
        printf '%s.%s' "$prefix" "$b"
      fi
      ;;
  esac
}

# Returns a writable target directory path for category $1, creating next NN
# folder only when the current one already has MAX_FILES files.
next_target_dir() {
  local cat="$1"
  local cat_dir="$OUTPUT_DIR/$cat"
  local last

  last=""
  if cd "$cat_dir" 2>/dev/null; then
    last=$(ls -1d [0-9][0-9] 2>/dev/null | LC_ALL=C sort | tail -n 1 || true)
    cd - >/dev/null 2>&1 || true
  fi

  if [ -z "$last" ]; then
    local folder
    folder=$(printf '%02d' 1)
    mkdir -p "$cat_dir/$folder"
    printf '%s' "$cat_dir/$folder"
    return 0
  fi

  local count
  count=$(find "$cat_dir/$last" -maxdepth 1 -type f | wc -l | tr -d ' ')
  if [ "$count" -ge "$MAX_FILES" ]; then
    local num folder
    num=$((10#$last + 1))
    folder=$(printf '%02d' "$num")
    mkdir -p "$cat_dir/$folder"
    printf '%s' "$cat_dir/$folder"
  else
    printf '%s' "$cat_dir/$last"
  fi
}

place_file() {
  local file="$1"
  local rel="${file#./}"

  classify_file "$rel"

  local display dest_dir dest base ext n cand
  display="$(compute_display_name "$rel")"
  dest_dir="$(next_target_dir "$CAT")"

  dest="$dest_dir/$display"
  if [ -e "$dest" ]; then
    base="${display%.*}"
    ext="${display##*.}"
    if [ "$base" = "$display" ]; then ext=""; fi
    n=2
    while :; do
      cand="${base}__${n}"
      if [ -n "$ext" ]; then cand="${cand}.${ext}"; fi
      if [ ! -e "$dest_dir/$cand" ]; then
        dest="$dest_dir/$cand"; break
      fi
      n=$((n+1))
    done
  fi

  cp "$file" "$dest"
}

main() {
  clean_output
  say "Scanning files..."

  # Build file list using pruning to skip unwanted directories anywhere.
  # Use -print0 to safely handle spaces and newlines.
  find .     -type d \( -name .git -o -name .idea -o -name target -o -name 'copilot_sources*' \) -prune -o     -type f     ! -name '.gitignore'     ! -name 'split_files*.sh'     -print0   | while IFS= read -r -d '' FILE; do
      place_file "$FILE"
    done

  say "Done. Check '$OUTPUT_DIR'."
}

main "$@"
