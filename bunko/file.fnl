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
(import-macros {: assert-type : map-values}
               (.. (: ... :match "(.+)%.[^.]+") :.macros))

(lambda exists? [file]
  "Check if the file exists."
  (assert-type :string file)
  (match (io.open file)
    any (do (any:close) true)
    _ false))

(fn %normalize [path]
  (path:gsub "/+" "/"))

(fn normalize [...]
  "Remove duplicated /'s in the path(s). The last / will remain."
  (assert-type :string ...)
  (map-values %normalize ...))

(fn %basename [path]
  (case (%normalize path)
    "/" "/"
    path (path:match "([^/]*)/?$")))

(fn basename [...]
  "Remove leading directory components from each given path. Trailing /'s are also
removed unless the given path is /.

Examples:
  (basename \"/a/b\")  ;=> \"b\"
  (basename \"/a/b/\") ;=> \"b\"
  (basename \"a/b\")   ;=> \"b\"
  (basename \"a/b/\")  ;=> \"b\"
  (basename \"/\")     ;=> \"/\"
  (basename \"\")      ;=> \"\"
  (basename \".\")     ;=> \".\"
  (basename \"..\")    ;=> \"..\""
  (assert-type :string ...)
  (map-values %basename ...))

(fn %dirname [path]
  (case (%normalize path)
    "/" "/"
    path (let [path (path:match "(.-)(/?)$")]
           (case (path:match "^(.*)/")
             any any
             _ "."))))

(fn dirname [...]
  "Extract the last directory component from each given path. Trailing /'s are removed.
If the path contains no /'s, output '.', meaning the current directory.

Examples:
  (%dirname \"/a/b\")  ;=> \"/a\"
  (%dirname \"/a/b/\") ;=> \"/a\"
  (%dirname \"a/b\")   ;=> \"a\"
  (%dirname \"a/b/\")  ;=> \"a\"
  (%dirname \"/\")     ;=> \"/\"
  (%dirname \"a\")     ;=> \".\"
  (%dirname \"a/\")    ;=> \".\"
  (%dirname \"\")      ;=> \".\"
  (%dirname \".\")     ;=> \".\"
  (%dirname \"..\")    ;=> \".\""
  (assert-type :string ...)
  (map-values %dirname ...))

(fn %slurp [path]
  (with-open [in (io.open path)]
    (in:read :*all)))

(fn slurp [...]
  "Read all contents of the given files. The results are concatenated."
  (assert-type :string ...)
  (accumulate [out ""
               _ file (ipairs [...])]
    (.. out (%slurp file))))

{: exists?
 : normalize
 : basename
 : dirname
 : slurp}
