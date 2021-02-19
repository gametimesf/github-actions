FROM golang:1.16

RUN apt-get update
RUN apt-get install -y jq

LABEL "com.github.actions.name"="gomodcheck"
LABEL "com.github.actions.description"="Run gomodcheck to see if any GT dependencies are not pointing to master"
LABEL "com.github.actions.icon"="terminal"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/gametimesf/github-actions"
LABEL "homepage"="https://github.com/gametimesf/github-actions"
LABEL "maintainer"="Andy Janata <andy.janata@gametime.co>"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
