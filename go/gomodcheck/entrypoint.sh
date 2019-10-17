#!/bin/bash
set -e

echo "Downloading gomodcheck..."

pushd /
git config --global url."https://${ORG_GITHUB_TOKEN}@github.com/gametimesf".insteadOf "https://github.com/gametimesf"
go get github.com/gametimesf/ops/gomodcheck
popd

export GITHUB_ACCESS_TOKEN="$ORG_GITHUB_TOKEN"

set +e
PROBLEMS=$(gomodcheck 2>&1)
SUCCESS=$?
set -e

# Exit if `gomodcheck` passes.
if [ $SUCCESS -eq 0 ]; then
  exit 0
fi

PROBLEMS="$(echo "$PROBLEMS" | perl -pe 's/\e\[?.*?[\@-~]//g')"

echo "$PROBLEMS"

# Iterate through each unformatted file.
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
