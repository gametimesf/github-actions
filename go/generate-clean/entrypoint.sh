#!/bin/bash
set -e

git config --global url."https://${ORG_GITHUB_TOKEN}@github.com/gametimesf".insteadOf "https://github.com/gametimesf"

echo "Downloading go-swagger..."

pushd /
go get github.com/go-swagger/go-swagger
# for some reason this isn't compiling, use precompiled binary from Dockerfile
# go get github.com/davecheney/godoc2md
popd


git config --global url."https://${ORG_GITHUB_TOKEN}@github.com/gametimesf".insteadOf "https://github.com/gametimesf"

cd "${GO_WORKING_DIR:-.}"

# run go generate
set +e
go generate ./...
SUCCESS=$?
set -e

# Exit if `go generate` fails.
if [ $SUCCESS -ne 0 ]; then
  echo "go generate failed to run"
  exit $SUCCESS
fi

# check if any files changed
git diff-index --quiet HEAD
if [ $? -eq 0 ]; then
  exit 0
fi

# Post results back as comment.
COMMENT="#### \`go generate\`
Please run \`go generate ./...\` and commit any changes.

$(git status)
"
PAYLOAD=$(echo '{}' | jq --arg body "$COMMENT" '.body = $body')
COMMENTS_URL=$(cat /github/workflow/event.json | jq -r .pull_request.comments_url)
curl -s -S -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$PAYLOAD" "$COMMENTS_URL" > /dev/null

exit $SUCCESS
