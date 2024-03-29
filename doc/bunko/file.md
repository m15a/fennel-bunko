# File.fnl (1.0.0)

File and file path utilities.

**Table of contents**

- Function: [`exists?`](#function-exists)
- Function: [`normalize`](#function-normalize)
- Function: [`remove-suffix`](#function-remove-suffix)
- Function: [`basename`](#function-basename)
- Function: [`dirname`](#function-dirname)
- Function: [`read-all`](#function-read-all)
- Function: [`read-lines`](#function-read-lines)
- Function: [`make-directory`](#function-make-directory)

## Function: `exists?`

```
(exists? path)
```

Return `true` if a file at the `path` exists.

## Function: `normalize`

```
(normalize & paths)
```

Return normalized `paths`.

The following things will be done.

1. remove duplicated separators such like `a//b///c`;
3. resolve parent directory path element (i.e., `a/b/../d` => `a/d`);
2. remove current directory path element (i.e., `a/./b` => `a/b`); and
4. finally, if `path` gets empty string, replace it with `.`. However,
   if `path` is empty string at the beginning, it returns as is.

Trailing slash will be left as is.

### Examples

```fennel
(let [(x y) (normalize "//a/b" "a/./../b/") ;=> "/a/b"	"b/"
      ]
  (assert (and (= x "/a/b")
               (= y "b/"))))
```

## Function: `remove-suffix`

```
(remove-suffix path suffix)
```

Remove `suffix` from the `path`.

If the basename of `path` and `suffix` is identical,
it does not remove suffix.
This is for convenience on manipulating hidden files.

### Examples

```fennel
(let [removed (remove-suffix "/a/b.ext" ".ext") ;=> "/a/b"
      ]
  (assert (= removed "/a/b")))

(let [removed (remove-suffix "/a/b/.ext" ".ext") ;=> "/a/b/.ext"
      ]
  (assert (= removed "/a/b/.ext")))
```

## Function: `basename`

```
(basename path ?suffix)
```

Remove leading directory components from the `path`.

Trailing `/`'s are also removed unless the `path` is just `/`.
Optionally, a trailing `?suffix` will be removed if specified. 
However, if the basename of `path` and `?suffix` is identical,
it does not remove suffix.
This is for convenience on manipulating hidden files.

Compatible with GNU coreutils' `basename`.

### Examples

```fennel
(let [a (basename "/")    ;=> "/"
      b (basename "/a/b") ;=> "b"
      c (basename "a/b/") ;=> "b"
      d (basename "")     ;=> ""
      e (basename ".")    ;=> "."
      f (basename "..")   ;=> ".."
      g (basename "/a/b.ext" ".ext")  ;=> "b"
      h (basename "/a/b.ext/" ".ext") ;=> "b"
      i (basename "/a/b/.ext" ".ext") ;=> ".ext"
      ]
    (assert (and (= a "/")
                 (= b "b")
                 (= c "b")
                 (= d "")
                 (= e ".")
                 (= f "..")
                 (= g "b")
                 (= h "b")
                 (= i ".ext"))))
```

## Function: `dirname`

```
(dirname & paths)
```

Remove the last non-slash component from each of the `paths`.

Trailing `/`'s are removed. If the path contains no `/`'s, it returns `.`.

Compatible with GNU coreutils' `dirname`.

### Examples

```fennel
(let [a (dirname "/")                ;=> "/"
      (b c) (dirname "/a/b" "/a/b/") ;=> "/a"	"/a"
      (d e) (dirname "a/b" "a/b/")   ;=> "a"	"a"
      (f g) (dirname "a" "a/")       ;=> "."	"."
      (h i j) (dirname "" "." "..")  ;=> "."	"."	"."
      ]
  (assert (and (= a "/")
               (= b "/a") (= c "/a")
               (= d "a") (= e "a")
               (= f ".") (= g ".")
               (= h ".") (= i ".") (= j "."))))
```

## Function: `read-all`

```
(read-all file/path)
```

Read all contents from a file handle or a file path, specified by `file/path`.

Raises an error if the file handle is closed or the file cannot be opened.
If `file/path` is a file handle, it will not be closed, so make sure to use it
in `with-open` macro or to close it manually.

## Function: `read-lines`

```
(read-lines file/path)
```

Read all lines from a file handle or a file path, specified by `file/path`.

Raises an error if the file handle is closed or the file cannot be opened.
If `file/path` is a file handle, it will not be closed, so make sure to use it
in `with-open` macro or to close it manually.

## Function: `make-directory`

```
(make-directory path parents? mode)
```

Make a directory of the `path`. Just a thin wrapper for `mkdir` command.

If `parents?` is truthy, add `--parents` option. If `mode` is string or
number, add `--mode` option with the `mode`.

It returns multiple values. The first value is `true` or `nil`, indicating
whether succeeded or failed to make the directory; the second string teaches
you the type of the third value, which is exit status or terminated signal.

---

License: Unlicense

<!-- Generated with Fnldoc 1.1.0-dev-66c2ee5
     https://sr.ht/~m15a/fnldoc/ -->
