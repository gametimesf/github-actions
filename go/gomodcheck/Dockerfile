FROM golang:1.13

LABEL "com.github.actions.name"="gomodcheck"
LABEL "com.github.actions.description"="Run gomodcheck to see if any GT dependencies are not pointing to master"
LABEL "com.github.actions.icon"="terminal"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/gametimesf/github-actions"
LABEL "homepage"="https://github.com/gametimesf/github-actions"
LABEL "maintainer"="Andy Janata <andy.janata@gametime.co>"

RUN apt-get update
RUN apt-get install -y jq

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
