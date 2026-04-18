#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SKILLS_SRC_DIR="${REPO_ROOT}/skills"
DEFAULT_DEST="${CODEX_HOME:-$HOME/.codex}/skills"
DEST_DIR="${DEFAULT_DEST}"
SELECTED_SKILL=""
FORCE=0

usage() {
  cat <<'USAGE'
Install skills from this repository into Codex skills directory.

Usage:
  scripts/install.sh [--skill <name>] [--dest <dir>] [--force]

Options:
  --skill <name>   Install only one skill (directory name under skills/)
  --dest <dir>     Target directory (default: $CODEX_HOME/skills or ~/.codex/skills)
  --force          Overwrite existing destination skill directory
  -h, --help       Show this help
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skill)
      SELECTED_SKILL="${2:-}"
      if [[ -z "${SELECTED_SKILL}" ]]; then
        echo "Error: --skill requires a value." >&2
        exit 1
      fi
      shift 2
      ;;
    --dest)
      DEST_DIR="${2:-}"
      if [[ -z "${DEST_DIR}" ]]; then
        echo "Error: --dest requires a value." >&2
        exit 1
      fi
      shift 2
      ;;
    --force)
      FORCE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ ! -d "${SKILLS_SRC_DIR}" ]]; then
  echo "Error: skills source directory not found: ${SKILLS_SRC_DIR}" >&2
  exit 1
fi

mkdir -p "${DEST_DIR}"

install_one() {
  local name="$1"
  local src="${SKILLS_SRC_DIR}/${name}"
  local dst="${DEST_DIR}/${name}"

  if [[ ! -d "${src}" ]]; then
    echo "Skip: skill not found: ${name}" >&2
    return 1
  fi

  if [[ ! -f "${src}/SKILL.md" ]]; then
    echo "Skip: missing SKILL.md in ${src}" >&2
    return 1
  fi

  if [[ -e "${dst}" ]]; then
    if [[ "${FORCE}" -eq 1 ]]; then
      rm -rf "${dst}"
    else
      echo "Skip: already exists: ${dst}"
      return 0
    fi
  fi

  cp -R "${src}" "${dst}"
  echo "Installed: ${name} -> ${dst}"
}

if [[ -n "${SELECTED_SKILL}" ]]; then
  install_one "${SELECTED_SKILL}"
else
  shopt -s nullglob
  installed=0
  for dir in "${SKILLS_SRC_DIR}"/*; do
    if [[ -d "${dir}" && -f "${dir}/SKILL.md" ]]; then
      name="$(basename "${dir}")"
      install_one "${name}" || true
      installed=$((installed + 1))
    fi
  done
  shopt -u nullglob

  if [[ "${installed}" -eq 0 ]]; then
    echo "No installable skills found in ${SKILLS_SRC_DIR}." >&2
    exit 1
  fi
fi

echo "Done. Restart Codex to pick up new skills."
