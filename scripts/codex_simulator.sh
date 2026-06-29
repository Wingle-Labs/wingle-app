#!/usr/bin/env bash
set -euo pipefail

SERVE_SIM=0

usage() {
  cat <<'USAGE'
Usage:
  ./scripts/codex_simulator.sh [--serve]

Options:
  --serve   Launch serve-sim for the selected simulator (blocked until stopped).
  -h, --help

Behavior:
  - Lists available iOS simulators
  - Lets you select one by number
  - Boots and opens the selected simulator
  - Optionally starts serve-sim and prints the stream URL for Codex in-app browser
USAGE
}

parse_args() {
  for arg in "$@"; do
    case "$arg" in
      --serve)
        SERVE_SIM=1
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        echo "Unknown argument: $arg" >&2
        usage
        exit 1
        ;;
    esac
  done
}

parse_args "$@"

action_failed() {
  echo "$1" >&2
  exit 1
}

if ! command -v xcrun >/dev/null 2>&1; then
  action_failed "xcrun not found. Install Xcode Command Line Tools first."
fi

if ! xcrun --find simctl >/dev/null 2>&1; then
  xcode_path="$(xcode-select -p 2>/dev/null || true)"
  if [[ "$xcode_path" == "/Library/Developer/CommandLineTools" ]]; then
    cat <<'MSG' >&2
simctl is not available with the current developer tools path:
  xcode-select path: /Library/Developer/CommandLineTools

`simctl` is provided by full Xcode (iOS simulator tooling), so install Xcode and then run:

  sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
  xcrun simctl list devices

If sudo access is restricted, ask your IT/admin to switch developer path to full Xcode.
MSG
  else
    cat <<'MSG' >&2
simctl not found. Check:
  1) Xcode is installed
  2) Active developer directory points to Xcode:
     sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
  3) Xcode command line tools are set up:
     xcode-select --install (if needed)
MSG
  fi
  action_failed "Failed to locate simctl."
fi

SIMCTL_OUTPUT=$(mktemp)
SIMCTL_ERROR=$(mktemp)

if ! xcrun simctl list devices available >"$SIMCTL_OUTPUT" 2>"$SIMCTL_ERROR"; then
  cat "$SIMCTL_ERROR" >&2
  rm -f "$SIMCTL_OUTPUT" "$SIMCTL_ERROR"
  action_failed "Failed to list available simulators."
fi

if grep -q "Connection invalid\|Unable to initialize simulator device set\|Failed to initialize" "$SIMCTL_ERROR"; then
  cat "$SIMCTL_ERROR" >&2
  rm -f "$SIMCTL_OUTPUT" "$SIMCTL_ERROR"
  action_failed "CoreSimulatorService is not available. Open Xcode and retry."
fi

SIM_NAMES=()
SIM_UDIDS=()
SIM_STATES=()

while IFS= read -r line; do
  trimmed="${line#"${line%%[![:space:]]*}"}"
  trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"
  if printf '%s\n' "$trimmed" | grep -Eq '^.+ \([0-9A-Fa-f-]{36}\) \(([^)]+)\)[[:space:]]*$'; then
    parsed="$(printf '%s\n' "$trimmed" | \
      sed -E 's/^(.+) \(([0-9A-Fa-f-]{36})\) \(([^)]+)\)[[:space:]]*$/\1\t\2\t\3/')"
    parsed_name="${parsed%%$'\t'*}"
    parsed_wo_name="${parsed#*$'\t'}"
    parsed_udid="${parsed_wo_name%%$'\t'*}"
    parsed_state="${parsed_wo_name##*$'\t'}"
    if [[ -n "$parsed_name" && -n "$parsed_udid" && -n "$parsed_state" ]]; then
      SIM_NAMES+=("$parsed_name")
      SIM_UDIDS+=("$parsed_udid")
      SIM_STATES+=("$parsed_state")
    fi
  fi
done < "$SIMCTL_OUTPUT"

rm -f "$SIMCTL_OUTPUT" "$SIMCTL_ERROR"

if [[ ${#SIM_UDIDS[@]} -eq 0 ]]; then
  action_failed "No available simulators found."
fi

echo "Available simulators:"
for i in "${!SIM_UDIDS[@]}"; do
  printf "  %3d) %s [id: %s] (%s)\n" "$((i+1))" "${SIM_NAMES[$i]}" "${SIM_UDIDS[$i]}" "${SIM_STATES[$i]}"
done

echo
while true; do
  read -r -p "Select simulator number (1-${#SIM_UDIDS[@]}): " selection

  if [[ "$selection" =~ ^[0-9]+$ ]] && (( selection >= 1 && selection <= ${#SIM_UDIDS[@]} )); then
    break
  fi

  echo "Invalid selection. Try again."
done

selected_index=$((selection-1))
SIM_UDID="${SIM_UDIDS[$selected_index]}"
SIM_NAME="${SIM_NAMES[$selected_index]}"
SIM_STATE="${SIM_STATES[$selected_index]}"

if [[ "$SIM_STATE" != "Booted" ]]; then
  echo "Booting $SIM_NAME..."
  if ! xcrun simctl boot "$SIM_UDID"; then
    echo "Boot command returned an error. If already booting/running, this is usually safe."
  fi
fi

xcrun simctl bootstatus "$SIM_UDID" -b >/dev/null 2>&1 || true
open -a Simulator >/dev/null 2>&1
open -a Simulator --args -CurrentDeviceUDID "$SIM_UDID" >/dev/null 2>&1

echo "Simulator launched in Codex: $SIM_NAME ($SIM_UDID)"

if (( SERVE_SIM == 1 )); then
  run_serve_sim() {
    if command -v npx >/dev/null 2>&1; then
      npx --yes serve-sim@latest "$1"
    elif command -v npm >/dev/null 2>&1; then
      npm exec --yes --package serve-sim@latest -- serve-sim "$1"
    else
      action_failed "Neither npx nor npm is available. Install Node.js (or set PATH for Node) and retry."
    fi
  }

  kill_serve_sim() {
    if command -v npx >/dev/null 2>&1; then
      npx --yes serve-sim@latest --kill "$1" >/dev/null 2>&1 || true
    elif command -v npm >/dev/null 2>&1; then
      npm exec --yes --package serve-sim@latest -- serve-sim --kill "$1" >/dev/null 2>&1 || true
    fi
  }

  cleanup_serve_sim() {
    kill_serve_sim "$SIM_UDID"
  }

  trap cleanup_serve_sim EXIT INT TERM HUP
  kill_serve_sim "$SIM_UDID"
  echo "Starting serve-sim..."
  run_serve_sim "$SIM_UDID"
else
  echo
  echo "Tip: to open simulator stream in Codex in-app browser, run:" 
  if command -v npx >/dev/null 2>&1; then
    echo "  npx --yes serve-sim@latest \"$SIM_UDID\""
  elif command -v npm >/dev/null 2>&1; then
    echo "  npm exec --yes --package serve-sim@latest -- serve-sim \"$SIM_UDID\""
  else
    echo "  Node.js is not installed. Install with: brew install node (if available) or https://nodejs.org/"
  fi
fi
