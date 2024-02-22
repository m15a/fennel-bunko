# File.fnl

**Table of contents**

- [`basename`](#basename)
- [`dirname`](#dirname)
- [`exists?`](#exists)
- [`normalize`](#normalize)
- [`read-all`](#read-all)
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
(exists? path)
```

Return `true` if a file at the `path` exists.

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

## `read-all`
Function signature:

```
(read-all file/path)
```

Read all contents from a file handle or a file path, specified by `file/path`.

Raises an error if the file handle is closed or the file cannot be opened.

If `file/path` is a file handle, it will not be closed, so make sure to use it
in `with-open` macro or to close it manually.

## `read-lines`
Function signature:

```
(read-lines file/path)
```

Read all lines from a file handle or a file path, specified by `file/path`.

Raises an error if the file handle is closed or the file cannot be opened.

If `file/path` is a file handle, it will not be closed, so make sure to use it
in `with-open` macro or to close it manually.

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


<!-- Generated with Fenneldoc 1.0.1-dev-7960056
     https://gitlab.com/andreyorst/fenneldoc -->
