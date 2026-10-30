#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

PROJECT="Minimalist.xcodeproj"
SCHEME="Minimalist"
TEST_TARGET="MinimalistTests"

pick_destination() {
  xcrun simctl list devices available \
    | awk -F '[()]' '/iPhone/ && /Booted/ { print $2; exit }'
}

if [[ -z "$(pick_destination)" ]]; then
  DESTINATION_ID="$(
    xcrun simctl list devices available \
      | awk -F '[()]' '/iPhone/ { print $2; exit }'
  )"
else
  DESTINATION_ID="$(pick_destination)"
fi

if [[ -z "${DESTINATION_ID:-}" ]]; then
  echo "No available iPhone simulator was found."
  xcrun simctl list devices available
  exit 1
fi

DESTINATION="platform=iOS Simulator,id=${DESTINATION_ID}"
echo "Running ${TEST_TARGET} on ${DESTINATION}"

COMMAND=(
  xcodebuild test
  -project "$PROJECT"
  -scheme "$SCHEME"
  -destination "$DESTINATION"
  -only-testing:"$TEST_TARGET"
  CODE_SIGNING_ALLOWED=NO
)

if command -v xcbeautify >/dev/null 2>&1; then
  "${COMMAND[@]}" | xcbeautify --renderer github-actions
else
  "${COMMAND[@]}"
fi
