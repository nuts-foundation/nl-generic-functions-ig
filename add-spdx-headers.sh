#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Steven van der Vegt
#
# SPDX-License-Identifier: EUPL-1.2

# Script to add SPDX headers to all tracked files using the REUSE tool.
# It extracts per-file authors and year ranges from git history,
# then calls `reuse annotate` via Docker to add the correct headers.
#
# Compatible with bash 3.2+ (macOS default).

set -euo pipefail

DOCKER_IMAGE="fsfe/reuse"
LICENSE="EUPL-1.2"

# Files to skip (already contain license text or are the license themselves)
SKIP_FILES="
LICENSE
LICENSES/EUPL-1.2.txt
DCO.md
"

# Map git author identities to canonical "Name <email>" strings.
canonical_author() {
  local git_author="$1"
  case "$git_author" in
    "Bram Wesselo")
      echo "Bram Wesselo" ;;
    "Bram Wesselo")
      echo "Bram Wesselo" ;;
    "jorritspee")
      echo "Jorrit Spee" ;;
    "Rein Krul")
      echo "Rein Krul" ;;
    "Roland Groen")
      echo "Roland Groen" ;;
    "Steven van der Vegt" | \
    "Steven van der Vegt" | \
    "Steven van der Vegt" | \
    "Steven van der Vegt" | \
    "Steven van der Vegt" | \
    "Steven van der Vegt")
      echo "Steven van der Vegt" ;;
    *)
      echo "WARNING: Unknown author '${git_author}', using as-is" >&2
      echo "${git_author}" ;;
  esac
}

# Check if a file should be skipped
should_skip() {
  local file="$1"
  echo "$SKIP_FILES" | grep -qxF "$file"
}

# Get the year range for a file from git history
get_year_range() {
  local file="$1"
  local first_year last_year

  first_year=$(git log --follow --diff-filter=A --format='%ad' --date=format:'%Y' -- "$file" | tail -1)
  last_year=$(git log -1 --format='%ad' --date=format:'%Y' -- "$file")

  # Fallback if git log returns empty (e.g. newly added, uncommitted files)
  if [ -z "$first_year" ]; then
    first_year=$(date +%Y)
  fi
  if [ -z "$last_year" ]; then
    last_year=$(date +%Y)
  fi

  if [ "$first_year" = "$last_year" ]; then
    echo "$first_year"
  else
    echo "${first_year} - ${last_year}"
  fi
}

# Get unique canonical authors for a file from git history
get_authors() {
  local file="$1"
  git log --follow --format='%aN <%aE>' -- "$file" | while IFS= read -r git_author; do
    [ -z "$git_author" ] && continue
    canonical_author "$git_author"
  done | sort -u
}

echo "=== Adding SPDX headers using REUSE tool ==="
echo ""

# Process all git-tracked files
git ls-files | while IFS= read -r file; do
  if should_skip "$file"; then
    echo "SKIP: $file (in skip list)"
    continue
  fi

  echo "Processing: $file"

  # Collect authors into a temporary file (avoids subshell scoping issues)
  tmpfile=$(mktemp)
  get_authors "$file" > "$tmpfile"

  if [ ! -s "$tmpfile" ]; then
    echo "  WARNING: No authors found for $file, skipping"
    rm -f "$tmpfile"
    continue
  fi

  # Get year range
  year_range=$(get_year_range "$file")

  # Build reuse annotate command
  copyright_args=""
  while IFS= read -r author; do
    copyright_args="${copyright_args} --copyright \"${author}\""
    echo "  Author: $author"
  done < "$tmpfile"
  rm -f "$tmpfile"

  echo "  Year: $year_range"

  # Run reuse annotate via Docker using eval to handle quoted arguments
  cmd="docker run --rm --volume \"$(pwd):/data\" \"$DOCKER_IMAGE\" annotate"
  cmd="${cmd}${copyright_args}"
  cmd="${cmd} --license \"$LICENSE\""
  cmd="${cmd} --year \"$year_range\""
  cmd="${cmd} --merge-copyrights"
  cmd="${cmd} --fallback-dot-license"
  cmd="${cmd} --skip-existing"
  cmd="${cmd} \"$file\""

  echo "  Running: $cmd"
  eval "$cmd"

  echo ""
done

echo "=== Done! ==="
echo ""
echo "Run 'docker run --rm --volume \$(pwd):/data fsfe/reuse lint' to verify REUSE compliance."
