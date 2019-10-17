# go fmt

Runs `gofmt`. To learn more about `gofmt`, see the [official docs](https://golang.org/cmd/gofmt/).

```hcl
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
      uses: gametimesf/github-actions/go/fmt@v0.4.0
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
