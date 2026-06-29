#!/usr/bin/env bash
#
# Package the skill into a distributable `.skill` archive.
#
# A `.skill` file is a zip whose top-level entry is the skill directory
# (e.g. `feature-spec-builder/SKILL.md`). Output goes to dist/.
#
# Usage: ./scripts/build-skill.sh

set -euo pipefail

SKILL_NAME="feature-spec-builder"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="${REPO_ROOT}/skill/${SKILL_NAME}"
OUT_DIR="${REPO_ROOT}/dist"
OUT_FILE="${OUT_DIR}/${SKILL_NAME}.skill"

if [[ ! -f "${SRC_DIR}/SKILL.md" ]]; then
  echo "error: ${SRC_DIR}/SKILL.md not found" >&2
  exit 1
fi

mkdir -p "${OUT_DIR}"
rm -f "${OUT_FILE}"

# Zip from the skill/ parent so the archive contains `feature-spec-builder/...`
( cd "${REPO_ROOT}/skill" && zip -r -X -q "${OUT_FILE}" "${SKILL_NAME}" )

echo "built: ${OUT_FILE}"
unzip -l "${OUT_FILE}"
