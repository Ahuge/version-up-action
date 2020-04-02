#!/bin/bash
set -e

# For some reason, $GITHUB_REF wasn't working before. This is a good alternative.
# REF=$(jq -r ".ref" "$GITHUB_EVENT_PATH")
# echo "Ref from JSON: $REF"

if ! git status > /dev/null 2>&1
then
  echo "## Initializing git repo..."
  git init
fi

REMOTE_TOKEN_URL="https://x-access-token:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git"
if ! git remote | grep "origin" > /dev/null 2>&1
then 
  echo "### Adding git remote..."
  git remote add origin $REMOTE_TOKEN_URL
  echo "### git fetch..."
  git fetch
fi

git remote set-url --push origin $REMOTE_TOKEN_URL

BRANCH="$GITHUB_BASE_REF"
BRANCH="$GITHUB_REF"
echo "### Branch: $BRANCH"
git checkout $BRANCH

echo "## Login into git..."
git config --global user.email "version_up_action@github.com"
git config --global user.name "Version Up Action"

echo "## Running Version Up Action"
TITLE=$(jq --raw-output '.pull_request.title' $GITHUB_EVENT_PATH);
echo "Release title: ${TITLE}"
PATTERN='[vV]([0-9]+\.[0-9]+\.[0-9]+)'
[[ "${TITLE}" =~ ${PATTERN} ]]
NEW_VERSION="${BASH_REMATCH[1]}"
echo "New version number detected: ${NEW_VERSION}"
PREVIOUS_VERSION=$(grep -Po '\d+\.\d+\.\d+' ${PREVIOUS_VERSION_FILE})
echo "Previous version detected: ${PREVIOUS_VERSION} from ${PREVIOUS_VERSION_FILE}"
echo "Searching for ${PREVIOUS_VERSION} in ${FILES_TO_UPDATE_VERSION_FOR}"
for filepath in "${FILES_TO_UPDATE_VERSION_FOR[@]}"
do
    echo "Replacing ${PREVIOUS_VERSION} with ${NEW_VERSION} in ${filepath}"
    sed -i "s|${PREVIOUS_VERSION}|${NEW_VERSION}|g" ${filepath}
done

echo "## Staging changes..."
git add ${FILES_TO_UPDATE_VERSION_FOR}
echo "## Commiting files..."
git commit -m "Automatically versioned up files" || true
echo "## Pushing to $BRANCH"
git push -u origin $BRANCH

