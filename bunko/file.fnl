;;;; File and file path utilities.
 
;;; URL: https://github.com/m15a/fennel-bunko
;;; License: Unlicense
;;; 
;;; This is free and unencumbered software released into the public domain.
;;; 
;;; Anyone is free to copy, modify, publish, use, compile, sell, or
;;; distribute this software, either in source code form or as a compiled
;;; binary, for any purpose, commercial or non-commercial, and by any
;;; means.
;;; 
;;; In jurisdictions that recognize copyright laws, the author or authors
;;; of this software dedicate any and all copyright interest in the
;;; software to the public domain. We make this dedication for the benefit
;;; of the public at large and to the detriment of our heirs and
;;; successors. We intend this dedication to be an overt act of
;;; relinquishment in perpetuity of all present and future rights to this
;;; software under copyright law.
;;; 
;;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
;;; IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
;;; OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
;;; ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
;;; OTHER DEALINGS IN THE SOFTWARE.
;;; 
;;; For more information, please refer to <https://unlicense.org>

(import-macros {: map-values} :bunko)
(local {: assert-type} (require :bunko))
(local {: escape-regex} (require :bunko.string))

(local path-separator (package.config:sub 1 1))

(fn exists? [path]
  "Return `true` if a file at the `path` exists."
  (case (io.open path)
    any (do
          (any:close) true)
    _ false))

(fn trailing-sep? [path]
  (if (path:match (.. path-separator "$")) true false))

(fn %normalize [path]
  (case (assert-type :string path)
    "" ""
    path (let [s path-separator
               had-trailing-sep? (trailing-sep? path)
               sds (.. s "%." s) ; /./
               ss->s #($:gsub (.. s "+") s)
               sds->s! #(do
                          (while ($:match sds) (set $ ($:gsub sds s)))
                          $)
               asdd->d #($:gsub (.. "[^" s "]+" s "%.%.") ".")
               ^ds-> #($:gsub (.. "^%." s) "")
               sd$-> #($:gsub (.. s "%.$") "")
               ->d #(if (= "" $) "." $)
               path (-> path
                        (ss->s)   ; //  -> /
                        (sds->s!) ; /./ -> /
                        (asdd->d) ; any-dir/.. -> .
                        (sds->s!) ; again!
                        (^ds->)   ; ^./ -> ''
                        (sd$->)   ; /.$ -> ''
                        (->d))]   ; '' -> .
           (if (trailing-sep? path)
               path
               (if had-trailing-sep?
                   (.. path s)
                   path)))))

(fn normalize [...]
  "Return normalized `paths`.

The following things will be done.

1. remove duplicated separators such like `a//b///c`;
3. resolve parent directory path element (i.e., `a/b/../d` => `a/d`);
2. remove current directory path element (i.e., `a/./b` => `a/b`); and
4. finally, if `path` gets empty string, replace it with `.`. However,
   if `path` is empty string at the beginning, it returns as is.

Trailing slash will be left as is.

# Examples

```fennel
(let [(x y) (normalize \"//a/b\" \"a/./../b/\") ;=> \"/a/b\"\t\"b/\"
      ]
  (assert (and (= x \"/a/b\")
               (= y \"b/\"))))
```"
  {:fnl/arglist [& paths]}
  (map-values %normalize ...))

(fn %remove-suffix [path suffix]
  (case (path:match (.. "^(.*)" (escape-regex suffix) "$"))
    stripped (if (or (= "" stripped) (trailing-sep? stripped))
                 path
                 stripped)
    _ path))

(fn remove-suffix [path suffix]
  "Remove `suffix` from the `path`.

If the basename of `path` and `suffix` is identical,
it does not remove suffix.
This is for convenience on manipulating hidden files.

# Examples

```fennel
(let [removed (remove-suffix \"/a/b.ext\" \".ext\") ;=> \"/a/b\"
      ]
  (assert (= removed \"/a/b\")))

(let [removed (remove-suffix \"/a/b/.ext\" \".ext\") ;=> \"/a/b/.ext\"
      ]
  (assert (= removed \"/a/b/.ext\")))
```"
  (assert-type :string path)
  (assert-type :string suffix)
  (%remove-suffix path suffix))

(fn basename [path ?suffix]
  "Remove leading directory components from the `path`.

Trailing `/`'s are also removed unless the `path` is just `/`.
Optionally, a trailing `?suffix` will be removed if specified. 
However, if the basename of `path` and `?suffix` is identical,
it does not remove suffix.
This is for convenience on manipulating hidden files.

Compatible with GNU coreutils' `basename`.

# Examples

```fennel
(let [a (basename \"/\")    ;=> \"/\"
      b (basename \"/a/b\") ;=> \"b\"
      c (basename \"a/b/\") ;=> \"b\"
      d (basename \"\")     ;=> \"\"
      e (basename \".\")    ;=> \".\"
      f (basename \"..\")   ;=> \"..\"
      g (basename \"/a/b.ext\" \".ext\")  ;=> \"b\"
      h (basename \"/a/b.ext/\" \".ext\") ;=> \"b\"
      i (basename \"/a/b/.ext\" \".ext\") ;=> \".ext\"
      ]
    (assert (and (= a \"/\")
                 (= b \"b\")
                 (= c \"b\")
                 (= d \"\")
                 (= e \".\")
                 (= f \"..\")
                 (= g \"b\")
                 (= h \"b\")
                 (= i \".ext\"))))
```"
  (let [sep path-separator
        path (%normalize path)]
    (if (= sep path)
        path
        (case-try (path:match (.. "([^" sep "]*)" sep "?$"))
          path (if ?suffix
                   (%remove-suffix path (assert-type :string ?suffix))
                   path)
          path path
          (catch _ (error "unknown path matching error"))))))

(fn %dirname [path]
  (let [sep path-separator
        path (%normalize path)]
    (if (= sep path)
        path
        (case-try (path:match (.. "(.-)" sep "?$"))
          path (path:match (.. "^(.*)" sep))
          path path
          (catch _ ".")))))

(fn dirname [...]
  "Remove the last non-slash component from each of the `paths`.

Trailing `/`'s are removed. If the path contains no `/`'s, it returns `.`.

Compatible with GNU coreutils' `dirname`.

# Examples

```fennel
(let [a (dirname \"/\")                ;=> \"/\"
      (b c) (dirname \"/a/b\" \"/a/b/\") ;=> \"/a\"\t\"/a\"
      (d e) (dirname \"a/b\" \"a/b/\")   ;=> \"a\"\t\"a\"
      (f g) (dirname \"a\" \"a/\")       ;=> \".\"\t\".\"
      (h i j) (dirname \"\" \".\" \"..\")  ;=> \".\"\t\".\"\t\".\"
      ]
  (assert (and (= a \"/\")
               (= b \"/a\") (= c \"/a\")
               (= d \"a\") (= e \"a\")
               (= f \".\") (= g \".\")
               (= h \".\") (= i \".\") (= j \".\"))))
```"
  {:fnl/arglist [& paths]}
  (map-values %dirname ...))

(fn make-directory [path parents? mode]
  "Make a directory of the `path`. Just a thin wrapper for `mkdir` command.

If `parents?` is truthy, add `--parents` option. If `mode` is string or
number, add `--mode` option with the `mode`.

It returns multiple values. The first value is `true` or `nil`, indicating
whether succeeded or failed to make the directory; the second string teaches
you the type of the third value, which is exit status or terminated signal."
  (let [path (%normalize path)
        cmd (.. "mkdir " (if parents? "--parents " "")
                (if mode
                    (.. :--mode= (assert-type :string (tostring mode)) " ")
                    "")
                path)]
    (case (os.execute cmd)
      ;; Lua >= 5.2
      (?ok :exit status)
      (values ?ok :exit status)
      (?ok :signal signal)
      (values ?ok :signal signal)
      ;; Lua 5.1 / LuaJIT
      (where status (= 0 status))
      (values true :exit 0)
      (status)
      (values nil :exit status)
      _
      (error "unknown os.exit returns"))))

(fn read-all [file/path]
  "Read all contents from a file handle or a file path, specified by `file/path`.

Raises an error if the file handle is closed or the file cannot be opened.
If `file/path` is a file handle, it will not be closed, so make sure to use it
in `with-open` macro or to close it manually."
  (if (io.type file/path)
      (file/path:read :*a)
      (case (io.open file/path)
        file (file:read :*a)
        (_ msg) (error msg))))

(fn %read-lines-from-file [file]
  (let [lines []]
    (each [line (file:lines)]
      (table.insert lines line))
    lines))

(fn read-lines [file/path]
  "Read all lines from a file handle or a file path, specified by `file/path`.

Raises an error if the file handle is closed or the file cannot be opened.
If `file/path` is a file handle, it will not be closed, so make sure to use it
in `with-open` macro or to close it manually."
  (if (io.type file/path)
      (%read-lines-from-file file/path)
      (case (io.open file/path)
        file (%read-lines-from-file file)
        (_ msg) (error msg))))

{: exists?
 : normalize
 : remove-suffix
 : basename
 : dirname
 : make-directory
 : read-all
 : read-lines}
