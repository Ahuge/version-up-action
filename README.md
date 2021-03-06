# Version Up Code GitHub Action

A GitHub action that will version up your code based on a successful pull_request merge.

## Example Workflow

```workflow
name: Version up Code on Release

on:
  pull_request:
    types: [closed]
    branches:
      - release

jobs:
  version_up_code:
    name: Version Up Code
    runs-on: ubuntu-latest
    steps:
    - name: Checkout Code
      uses: actions/checkout@v1
    - name: Version Up Code
      uses: Ahuge/version-up-action@v0.1.0
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        PREVIOUS_VERSION_FILE: "setup.py"
        FILES_TO_UPDATE_VERSION_FOR: "python/mymodule/__init__.py setup.py"
```
