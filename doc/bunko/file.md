# File.fnl

**Table of contents**

- [`basename`](#basename)
- [`dirname`](#dirname)
- [`exists?`](#exists)
- [`normalize`](#normalize)
- [`read-file`](#read-file)

## `basename`
Function signature:

```
(basename & paths)
```

Remove leading directory components from each of the `paths`.

Trailing `/`'s are also removed unless the given path is just `/`.
Compatible to GNU coreutils' `basename --muptiple`.

### Examples

```fennel
(basename "/a/b")  ;=> "b"
(basename "/a/b/") ;=> "b"
(basename "a/b")   ;=> "b"
(basename "a/b/")  ;=> "b"
(basename "/")     ;=> "/"
(basename "")      ;=> ""
(basename ".")     ;=> "."
(basename "..")    ;=> ".."
```

## `dirname`
Function signature:

```
(dirname & paths)
```

Extract the last directory component from each of the `paths`.

Trailing `/`'s are removed. If the path contains no `/`'s, it returns `.`.
Compatible to GNU coreutils' `dirname`.

### Examples

```fennel
(dirname "/a/b")  ;=> "/a"
(dirname "/a/b/") ;=> "/a"
(dirname "a/b")   ;=> "a"
(dirname "a/b/")  ;=> "a"
(dirname "/")     ;=> "/"
(dirname "a")     ;=> "."
(dirname "a/")    ;=> "."
(dirname "")      ;=> "."
(dirname ".")     ;=> "."
(dirname "..")    ;=> "."
```

## `exists?`
Function signature:

```
(exists? file)
```

Check if the `file` exists.

## `normalize`
Function signature:

```
(normalize & paths)
```

Remove duplicated `/`'s in the `paths`. The last `/` will remain.

### Example

```fennel
(normalize "//a/b" "a//b/") ;=> "/a/b"	"a/b/"
```

## `read-file`
Function signature:

```
(read-file file)
```

Read all contents of the `file`.


<!-- Generated with Fenneldoc 1.0.1-dev
     https://gitlab.com/andreyorst/fenneldoc -->
