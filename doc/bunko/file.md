# File.fnl

**Table of contents**

- [`basename`](#basename)
- [`dirname`](#dirname)
- [`exists?`](#exists)
- [`normalize`](#normalize)
- [`read-file`](#read-file)
- [`read-lines`](#read-lines)
- [`remove-suffix`](#remove-suffix)

## `basename`
Function signature:

```
(basename path ?suffix)
```

Remove leading directory components from the `path`.

Compatible with GNU coreutils' `basename`.

Trailing `/`'s are also removed unless the `path` is just `/`.

Optionally, a trailing `?suffix` will be removed if specified. 
However, if the basename of `path` and `?suffix` is identical,
it does not remove suffix.
This is for convenience on manipulating hidden files.

### Examples

```fennel
(basename "/")    ;=> "/"
(basename "/a/b") ;=> "b"
(basename "a/b/") ;=> "b"
(basename "")     ;=> ""
(basename ".")    ;=> "."
(basename "..")   ;=> ".."
(basename "/a/b.ext" ".ext")  ;=> "b"
(basename "/a/b.ext/" ".ext") ;=> "b"
(basename "/a/b/.ext" ".ext") ;=> ".ext"
```

## `dirname`
Function signature:

```
(dirname & paths)
```

Remove the last non-slash component from each of the `paths`.

Compatible with GNU coreutils' `dirname`.

Trailing `/`'s are removed. If the path contains no `/`'s, it returns `.`.

### Examples

```fennel
(dirname "/")            ;=> "/"
(dirname "/a/b" "/a/b/") ;=> "/a"	"/a"
(dirname "a/b" "a/b/")   ;=> "a"	"a"
(dirname "a" "a/")       ;=> "."	"."
(dirname "" "." "..")    ;=> "."	"."	"."
```

## `exists?`
Function signature:

```
(exists? file)
```

Return `true` if the `file` exists.

## `normalize`
Function signature:

```
(normalize & paths)
```

Remove duplicated `/`'s in the `paths`.

Trailing `/`'s will remain.

### Examples

```fennel
(normalize "//a/b" "a//b/") ;=> "/a/b"	"a/b/"
```

## `read-file`
Function signature:

```
(read-file file)
```

Read all contents of the `file` as a string.

## `read-lines`
Function signature:

```
(read-lines file)
```

Read all lines of the `file` as a sequential table of strings.

## `remove-suffix`
Function signature:

```
(remove-suffix path suffix)
```

Remove `suffix` from the `path`.

If the basename of `path` and `suffix` is identical,
it does not remove suffix.
This is for convenience on manipulating hidden files.

### Examples

```fennel
(remove-suffix "/a/b.ext" ".ext") ;=> "/a/b"
(remove-suffix "/a/b/.ext" ".ext") ;=> "/a/b/.ext"
```


<!-- Generated with Fenneldoc 1.0.1-dev
     https://gitlab.com/andreyorst/fenneldoc -->
