# Reduce Functions for roc-lang

[![Roc-Lang][roc_badge]][roc_link]
[![GitHub last commit][last_commit_badge]][last_commit_link]
[![CI status][ci_status_badge]][ci_status_link]

A small package containing a collection of reduce functions for roc data structures. Reduce behaves like `walk`, but doesn't require an accumulator argument, instead simply using the first element in the structure as the accumulator. 

Functions are available for: List, Dict, and Set, and include left and right variants for lists, and key, value, and (key, value) versions for Dict.

Two names are provided for each function. A function named for qualified use, and a function named for unqualified use. For example:

```roc
import red.Reduce exposing [reduceListLeft]

a = Reduce.listLeft [1, 2, 3] Num.add
b = reduceListLeft [1, 2, 3] Num.add
```

[roc_badge]: https://img.shields.io/endpoint?url=https%3A%2F%2Fpastebin.com%2Fraw%2FcFzuCCd7
[roc_link]: https://github.com/roc-lang/roc

[ci_status_badge]: https://img.shields.io/github/actions/workflow/status/imclerran/roc-reduce/ci.yaml?logo=github&logoColor=lightgrey
[ci_status_link]: https://github.com/imclerran/roc-reduce/actions/workflows/ci.yaml
[last_commit_badge]: https://img.shields.io/github/last-commit/imclerran/roc-reduce?logo=git&logoColor=lightgrey
[last_commit_link]: https://github.com/imclerran/roc-reduce/commits/main/
