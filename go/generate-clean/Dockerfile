FROM golang:1.14

RUN apt-get update
RUN apt-get install -y jq

LABEL "com.github.actions.name"="go generate"
LABEL "com.github.actions.description"="Run go generate and verify no files changed"
LABEL "com.github.actions.icon"="terminal"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/gametimesf/github-actions"
LABEL "homepage"="https://github.com/gametimesf/github-actions"
LABEL "maintainer"="Andy Janata <andy.janata@gametime.co>"

ADD entrypoint.sh /entrypoint.sh
ADD godoc2md /bin/godoc2md
ENTRYPOINT ["/entrypoint.sh"]
