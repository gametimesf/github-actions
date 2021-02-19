#!/bin/bash
set -e

echo "Downloading gomodcheck..."
export GOPRIVATE=github.com/gametimes

pushd /
git config --global url."https://${ORG_GITHUB_TOKEN}@github.com/gametimesf".insteadOf "https://github.com/gametimesf"
go install github.com/gametimesf/ops/gomodcheck@latest
popd

export GITHUB_ACCESS_TOKEN="$ORG_GITHUB_TOKEN"

set +e
PROBLEMS=$(LOG_LEVEL=info gomodcheck 2>&1)
SUCCESS=$?
set -e

# strip ANSI colors from the output
PROBLEMS="$(echo "$PROBLEMS" | perl -pe 's/\e\[?.*?[\@-~]//g')"
echo "$PROBLEMS"

# Exit if `gomodcheck` passes.
if [ $SUCCESS -eq 0 ]; then
  exit 0
fi

OUTPUT="Update the following dependencies:
$PROBLEMS"

# Post results back as comment.
COMMENT="#### \`gomodcheck\`
$OUTPUT
"
PAYLOAD=$(echo '{}' | jq --arg body "$COMMENT" '.body = $body')
COMMENTS_URL=$(cat /github/workflow/event.json | jq -r .pull_request.comments_url)
curl -s -S -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$PAYLOAD" "$COMMENTS_URL" > /dev/null

exit $SUCCESS
