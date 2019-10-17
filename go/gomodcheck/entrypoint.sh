#!/bin/sh
set -e

# See what kind of action this is
ACTION=$(cat /github/workflow/event.json | jq -r .action)
case $ACTION in
	opened)
		;;
	synchronize)
		;;
	*)
		echo "Not a PR open or push, exiting"
		exit 0
		;;
esac

cd /
go get github.com/gametimesf/ops/gomodcheck

cd "${GO_WORKING_DIR:-.}"

set +e
PROBLEMS=$(gomodcheck)
SUCCESS=$?

# Exit if `gomodcheck` passes.
if [ $SUCCESS -eq 0 ]; then
  exit 0
fi

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
