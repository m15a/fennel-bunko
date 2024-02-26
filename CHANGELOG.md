# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][1],
and this project adheres to [Semantic Versioning][2].

[1]: https://keepachangelog.com/en/1.0.0/
[2]: https://semver.org/spec/v2.0.0.html

## Unreleased

### Added

- `find-some`, `for-some?`, and `for-all?` macros
  - For a given iterator,
    - `find-some` finds one example that satisfies a given predicate expression,
    - `for-some?` tests the above and returns boolean instead, and
    - `for-all?` tests a predicate expression is satisfied for all examples.
- Basic statistical functions in `bunko.math` module: `mean`, `variance`,
  `standard-deviation`, `standard-error`, and `median`.

## [0.1.0][v0.1.0] (2024-02-24)

- Initial release of development version.

[v0.1.0]: https://github.com/m15a/fennel-bunko/tree/v0.1.0
