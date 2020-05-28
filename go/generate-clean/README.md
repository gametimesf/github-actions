# go generate

Runs `go generate` and verifies that no files changed as a result.

It supports go-swagger and godoc2md as valid targets of `go generate`. Feel free to add support for more as needed.

```yml
on:
  pull_request:
    types: [opened, synchronize, reopened, ready_for_review]

name: Go-Checks
jobs:
  check-go:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - name: gofmt
      uses: gametimesf/github-actions/go/generate-clean@v0.5.0
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        # this token must have access to the entire organization
        ORG_GITHUB_TOKEN: ${{ secrets.ORG_GITHUB_TOKEN }}
```
