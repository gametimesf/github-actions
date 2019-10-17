# gomodcheck

Runs `gomodcheck`. To learn more about `gomodcheck`, see https://github.com/gametimesf/ops/tree/master/gomodcheck.

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
    - name: gomodcheck
      uses: gametimesf/github-actions/go/gomodcheck@v0.4.0
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        # this token must have access to the entire organization
        ORG_GITHUB_TOKEN: ${{ secrets.ORG_GITHUB_TOKEN }}
```
