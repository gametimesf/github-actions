# gomodcheck

Runs `gomodcheck`. To learn more about `gomodcheck`, see https://github.com/gametimesf/ops/tree/master/gomodcheck.

```hcl
action "gomodcheck" {
  uses    = "gametimesf/github-actions/go/gomodcheck@v0.4.0"
  needs   = "previous-action"
  secrets = ["GITHUB_TOKEN"]

  env {
    GO_WORKING_DIR = "./path/to/go/files"
  }
}
```
