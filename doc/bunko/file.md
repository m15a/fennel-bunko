# File.fnl

**Table of contents**

- [`basename`](#basename)
- [`dirname`](#dirname)
- [`exists?`](#exists)
- [`normalize`](#normalize)
- [`slurp`](#slurp)

## `basename`
Function signature:

```
(basename ...)
```

Remove leading directory components from each given path.

Trailing `/`'s are also removed unless the given path is just `/`.
Compatible to GNU coreutils' `basename --muptiple`.

Examples:

  (basename "/a/b")  ;=> "b"
  (basename "/a/b/") ;=> "b"
  (basename "a/b")   ;=> "b"
  (basename "a/b/")  ;=> "b"
  (basename "/")     ;=> "/"
  (basename "")      ;=> ""
  (basename ".")     ;=> "."
  (basename "..")    ;=> ".."

## `dirname`
Function signature:

```
(dirname ...)
```

Extract the last directory component from each given path.

Trailing `/`'s are removed. If the path contains no `/`'s, it returns `.`.
Compatible to GNU coreutils' `dirname`.

Examples:

  (%dirname "/a/b")  ;=> "/a"
  (%dirname "/a/b/") ;=> "/a"
  (%dirname "a/b")   ;=> "a"
  (%dirname "a/b/")  ;=> "a"
  (%dirname "/")     ;=> "/"
  (%dirname "a")     ;=> "."
  (%dirname "a/")    ;=> "."
  (%dirname "")      ;=> "."
  (%dirname ".")     ;=> "."
  (%dirname "..")    ;=> "."

## `exists?`
Function signature:

```
(exists? file)
```

Check if the file exists.

## `normalize`
Function signature:

```
(normalize ...)
```

Remove duplicated `/`'s in the path(s). The last `/` will remain.

## `slurp`
Function signature:

```
(slurp ...)
```

Read all contents of the given files. The results are concatenated.

Return `nil` if no files are specified.


<!-- Generated with Fenneldoc 1.0.1
     https://gitlab.com/andreyorst/fenneldoc -->
