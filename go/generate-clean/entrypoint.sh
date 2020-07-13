#!/bin/bash
set -e

git config --global url."https://${ORG_GITHUB_TOKEN}@github.com/gametimesf".insteadOf "https://github.com/gametimesf"
export PATH="$PATH:/"

echo "Downloading go-swagger..."

download_url=$(curl -s https://api.github.com/repos/go-swagger/go-swagger/releases/latest | \
  jq -r '.assets[] | select(.name | contains("'"$(uname | tr '[:upper:]' '[:lower:]')"'_amd64")) | .browser_download_url')
curl -o /swagger -L'#' "$download_url"
chmod +x /swagger

echo "Downloading ffjson..."
go get -u github.com/pquerna/ffjson

cd "${GO_WORKING_DIR:-.}"

set +e

# run go generate
go generate ./...
SUCCESS=$?

# Exit if `go generate` fails.
if [ $SUCCESS -ne 0 ]; then
  echo "go generate failed to run"
  exit $SUCCESS
fi

# check if any files changed
# Y U NO WORK?!?!
# git diff-index --quiet HEAD
git status | grep --quiet "nothing to commit, working tree clean"
SUCCESS=$?
if [ $SUCCESS -eq 0 ]; then
  echo "no files changed"
  exit 0
fi

echo "files changed"
git status

# Post results back as comment.
COMMENT="#### \`go generate\`
Please run \`go generate ./...\` and commit any changes.

$(git status)
"
PAYLOAD=$(echo '{}' | jq --arg body "$COMMENT" '.body = $body')
COMMENTS_URL=$(cat /github/workflow/event.json | jq -r .pull_request.comments_url)
curl -s -S -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$PAYLOAD" "$COMMENTS_URL" > /dev/null

exit $SUCCESS
