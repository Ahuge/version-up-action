FROM python:3

LABEL "com.github.actions.name"="Version Up Action"
LABEL "com.github.actions.description"="Version up your code automatically!"
LABEL "com.github.actions.icon"="code"
LABEL "com.github.actions.color"="yellow"

LABEL "repository"="https://github.com/Ahuge/version-up-action"
LABEL "homepage"="https://github.com/Ahuge/version-up-action"
LABEL "maintainer"="Alex Hughes <ahughesalex@gmail.com>"

RUN apt-get update && apt-get install -y git jq

COPY entrypoint.sh /entrypoint.sh
RUN git config --system --add safe.directory /github/workspace
ENTRYPOINT ["/entrypoint.sh"]
