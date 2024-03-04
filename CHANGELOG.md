# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][1],
and this project adheres to [Semantic Versioning][2].

[1]: https://keepachangelog.com/en/1.0.0/
[2]: https://semver.org/spec/v2.0.0.html

## Unreleased

### Added

- `bunko.table.unpack-then`: a helper to fill `unquote-splicing`'s nich.

## [1.0.0][v1.0.0] (2024-03-01)

### Changed

- To import macros, do `(import-macros {: macro-name} :bunko)` now.

### Added

- `find-some`, `for-some?`, and `for-all?` macros
  - For a given iterator,
    - `find-some` finds one example that satisfies a given predicate expression,
    - `for-some?` tests the above and returns boolean instead, and
    - `for-all?` tests a predicate expression is satisfied for all examples.
- Basic statistical functions in `bunko.math` module: `mean`, `variance`,
  `standard-deviation`, `standard-error`, and `median`.
- `bunko.set.set=` for equality check between tables as sets.
- `bunko.equal?` for recursive table comparison.

### Fixed

- `bunko.table.update!`: fix a bug that `false` value was replaced with the default.
- `bunko.set.{subset?,intersection!}`: fix a bug that `false` value indicates no
  element in a set.

## [0.1.0][v0.1.0] (2024-02-24)

- Initial release of development version.

[v1.0.0]: https://github.com/m15a/fennel-bunko/tree/v1.0.0
[v0.1.0]: https://github.com/m15a/fennel-bunko/tree/v0.1.0
