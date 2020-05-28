# go generate

Runs `go generate` and verifies that no files changed as a result.

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
```
