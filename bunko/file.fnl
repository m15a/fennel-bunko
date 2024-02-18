;;;; =========================================================================
;;;; File and file path utilities.
;;;; =========================================================================
;;;; 
;;;; URL: https://github.com/m15a/fennel-bunko
;;;; License: Unlicense
;;;; 
;;;; This is free and unencumbered software released into the public domain.
;;;; 
;;;; Anyone is free to copy, modify, publish, use, compile, sell, or
;;;; distribute this software, either in source code form or as a compiled
;;;; binary, for any purpose, commercial or non-commercial, and by any
;;;; means.
;;;; 
;;;; In jurisdictions that recognize copyright laws, the author or authors
;;;; of this software dedicate any and all copyright interest in the
;;;; software to the public domain. We make this dedication for the benefit
;;;; of the public at large and to the detriment of our heirs and
;;;; successors. We intend this dedication to be an overt act of
;;;; relinquishment in perpetuity of all present and future rights to this
;;;; software under copyright law.
;;;; 
;;;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;;;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;;;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
;;;; IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
;;;; OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
;;;; ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
;;;; OTHER DEALINGS IN THE SOFTWARE.
;;;; 
;;;; For more information, please refer to <https://unlicense.org>

(local unpack (or table.unpack _G.unpack))
(import-macros {: assert-type : map-values} :bunko.macros)
(local {: escape} (require :bunko.string))

(fn exists? [file]
  "Return `true` if the `file` exists."
  (case (io.open file)
    any (do (any:close) true)
    _ false))

(fn %normalize [path]
  (pick-values 1 (path:gsub "/+" "/")))

(fn normalize [...]
  "Remove duplicated `/`'s in the `paths`.

Trailing `/`'s will remain.

# Examples

```fennel :skip-test
(normalize \"//a/b\" \"a//b/\") ;=> \"/a/b\"\t\"a/b/\"
```"
  {:fnl/arglist [& paths]}
  (assert-type :string ...)
  (map-values %normalize ...))

(fn %remove-suffix [path suffix]
  (let [stripped (path:match (.. "^(.*)" (escape suffix) "$"))]
    (if (or (= "" stripped) (stripped:match "/$"))
        path
        stripped)))

(fn remove-suffix [path suffix]
  "Remove `suffix` from the `path`.

If the basename of `path` and `suffix` is identical,
it does not remove suffix.
This is for convenience on manipulating hidden files.

# Examples

```fennel :skip-test
(remove-suffix \"/a/b.ext\" \".ext\") ;=> \"/a/b\"
(remove-suffix \"/a/b/.ext\" \".ext\") ;=> \"/a/b/.ext\"
```"
  (assert-type :string path suffix)
  (%remove-suffix path suffix))

(fn basename [path ?suffix]
  "Remove leading directory components from the `path`.

Compatible with GNU coreutils' `basename`.

Trailing `/`'s are also removed unless the `path` is just `/`.

Optionally, a trailing `?suffix` will be removed if specified. 
However, if the basename of `path` and `?suffix` is identical,
it does not remove suffix.
This is for convenience on manipulating hidden files.

# Examples

```fennel :skip-test
(basename \"/\")    ;=> \"/\"
(basename \"/a/b\") ;=> \"b\"
(basename \"a/b/\") ;=> \"b\"
(basename \"\")     ;=> \"\"
(basename \".\")    ;=> \".\"
(basename \"..\")   ;=> \"..\"
(basename \"/a/b.ext\" \".ext\")  ;=> \"b\"
(basename \"/a/b.ext/\" \".ext\") ;=> \"b\"
(basename \"/a/b/.ext\" \".ext\") ;=> \".ext\"
```"
  (assert-type :string path)
  (when ?suffix
    (assert-type :string ?suffix))
  (let [path (%normalize path)]
    (if (= "/" path)
        path
        (case-try (path:match "([^/]*)/?$")
          path (if ?suffix
                   (%remove-suffix path ?suffix)
                   path)
          path path
          (catch _ (error "basename: unknown path matching error"))))))

(fn %dirname [path]
  (let [path (%normalize path)]
    (if (= "/" path)
        path
        (case-try (path:match "(.-)/?$")
          path (path:match "^(.*)/")
          path path
          (catch _ ".")))))

(fn dirname [...]
  "Remove the last non-slash component from each of the `paths`.

Compatible with GNU coreutils' `dirname`.

Trailing `/`'s are removed. If the path contains no `/`'s, it returns `.`.

# Examples

```fennel :skip-test
(dirname \"/\")            ;=> \"/\"
(dirname \"/a/b\" \"/a/b/\") ;=> \"/a\"\t\"/a\"
(dirname \"a/b\" \"a/b/\")   ;=> \"a\"\t\"a\"
(dirname \"a\" \"a/\")       ;=> \".\"\t\".\"
(dirname \"\" \".\" \"..\")    ;=> \".\"\t\".\"\t\".\"
```"
  {:fnl/arglist [& paths]}
  (assert-type :string ...)
  (map-values %dirname ...))

(fn %read-all-from-file [file]
  (let [contents (file:read :*a)]
    (file:close)
    contents))

(fn read-all [file/path]
  "Read all contents from a file handle or a file path, specified by `file/path`."
  (case (io.type file/path)
    "file" (%read-all-from-file file/path)
    "closed file" (values nil "read-lines: closed file")
    _ (case (io.open file/path)
        file (%read-all-from-file file)
        (_ msg code) (values nil msg code))))

(fn %read-lines-from-file [file]
  (let [lines []]
    (each [line (file:lines)]
      (table.insert lines line))
    (file:close)
    lines))

(fn read-lines [file/path]
  "Read all lines from a file handle or a file path, specified by `file/path`."
  (case (io.type file/path)
    "file" (%read-lines-from-file file/path)
    "closed file" (values nil "read-lines: closed file")
    _ (case (io.open file/path)
        file (%read-lines-from-file file)
        (_ msg code) (values nil msg code))))

{: exists?
 : normalize
 : remove-suffix
 : basename
 : dirname
 : read-all
 : read-lines}
