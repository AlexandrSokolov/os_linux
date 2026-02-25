#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# bundle_project.sh
# -----------------------------------------------------------------------------
# PURPOSE
#   Create ONE monolithic text file (jms-custom-invoice_bundle.txt) that packs
#   your entire Java project so you can upload a single file to Adrian later.
#
# WHY THIS IS USEFUL
#   • Faster future sessions: upload one file instead of dozens/hundreds.
#   • Reliable reconstruction: each original file is wrapped with BEGIN/END
#     markers containing its relative path, so Adrian can restore the full
#     source tree (folders + filenames) exactly.
#   • Source-control friendly: the bundle is plain text and can be archived or
#     versioned alongside your project if needed.
#
# WHAT IT INCLUDES
#   • All *.java files under ./src
#   • Project root files: pom.xml, README.md (if present)
#   • Any WEB-INF/*.xml files (if present) often required for Java web apps
#
# HOW IT WORKS (overview)
#   1) We define an append() helper that writes a BEGIN marker, the file content,
#      and an END marker, using the file's repo-relative path.
#   2) We enumerate files in a deterministic order (sorted) to keep bundles
#      stable across runs.
#   3) We stream-append each discovered file into the output bundle.
#
# USAGE
#   Save this script in your project root and run:
#       chmod +x bundle_project.sh
#       ./bundle_project.sh
#   The result will be: jms-custom-invoice_bundle.txt in the project root.
#
# RESTORATION (what Adrian will do next time)
#   Adrian will parse the BEGIN/END markers, recreate each file with its
#   original relative path, and restore your project structure immediately.
# -----------------------------------------------------------------------------
set -euo pipefail


# Detect the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Extract the actual project directory name
PROJECT_NAME="$(basename "$SCRIPT_DIR")"

# Generate dynamic output name
OUTPUT="${PROJECT_NAME}_bundle.txt"

# Optional sanity check: warn if not at repo root (heuristic only)
if [ ! -d "src" ] && [ ! -f "pom.xml" ]; then
  echo "⚠️  This doesn't look like the project root (missing src/ and pom.xml)."
  echo "   You can continue, but verify paths inside the bundle afterwards."
fi

# Create/empty the bundle file
rm -f "$OUTPUT"
: > "$OUTPUT"

# append <filePath>
# Writes a BEGIN marker with repo-relative path, the file content, then an END marker.
append() {
  local src="$1"
  # Normalize relative path to avoid './' prefixes
  local rel="${src#./}"
  {
    echo "===== BEGIN FILE : ${rel} ====="
    cat "$src"
    echo ""
    echo "===== END FILE : ${rel} ====="
    echo ""
  } >> "$OUTPUT"
}

echo "📁 Packing Java source files..."
# Collect all Java files deterministically
while IFS= read -r -d '' f; do
  append "$f"
done < <(find ./src -type f -name "*.java" -print0 | sort -z)

# Add common project root files if present
for f in pom.xml README.md; do
  if [ -f "$f" ]; then
    echo "📄 Adding $f"
    append "$f"
  fi
done

# Add web deployment descriptors if present (common in Java EE/Servlet apps)
if [ -d ./src/main/webapp/WEB-INF ]; then
  echo "📁 Adding WEB-INF XML files..."
  while IFS= read -r -d '' f; do
    append "$f"
  done < <(find ./src/main/webapp/WEB-INF -type f -name "*.xml" -print0 | sort -z)
fi

echo "✅ Done. Created: $OUTPUT"
echo "Upload this single file in future sessions; I will reconstruct the project from it."
