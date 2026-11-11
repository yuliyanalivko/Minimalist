#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

PROJECT="Minimalist.xcodeproj"
SCHEME="Minimalist"
TEST_TARGET="MinimalistTests"
RESULT_BUNDLE="${ROOT_DIR}/build/TestResults.xcresult"
FAILED_TESTS_FILE="${ROOT_DIR}/failed-tests.txt"

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

mkdir -p "${ROOT_DIR}/build"
rm -rf "$RESULT_BUNDLE" "$FAILED_TESTS_FILE"
touch "$FAILED_TESTS_FILE"

COMMAND=(
  xcodebuild test
  -project "$PROJECT"
  -scheme "$SCHEME"
  -destination "$DESTINATION"
  -only-testing:"$TEST_TARGET"
  -resultBundlePath "$RESULT_BUNDLE"
  CODE_SIGNING_ALLOWED=NO
)

set +e
if command -v xcbeautify >/dev/null 2>&1; then
  "${COMMAND[@]}" | xcbeautify --renderer github-actions
else
  "${COMMAND[@]}"
fi
STATUS=$?
set -e

if [[ -d "$RESULT_BUNDLE" ]]; then
  xcrun xcresulttool get test-results tests --path "$RESULT_BUNDLE" \
    | python3 "${ROOT_DIR}/scripts/list-failed-tests.py" \
    > "$FAILED_TESTS_FILE" || true
fi

if [[ "$STATUS" -ne 0 && ! -s "$FAILED_TESTS_FILE" ]]; then
  echo "The test run failed before individual test results were produced." > "$FAILED_TESTS_FILE"
fi

if [[ -s "$FAILED_TESTS_FILE" ]]; then
  echo "Failed tests:"
  cat "$FAILED_TESTS_FILE"
fi

exit "$STATUS"
