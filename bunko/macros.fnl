;;;; ==========================================================================
;;;; Miscellaneous macros.
;;;; ==========================================================================
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
(local fennel (require :fennel))

(fn assert-type [expected & items]
  "Check if each of `items` is of the `expected` type.

# Examples

```fennel :skip-test
(assert-type :table x y)
```

is expanded to

```fennel :skip-test
(do (let [actual (type x)]
      (assert (= actual \"table\")
              (string.format \"table expected, got %s\" actual)))
    (let [actual (type y)]
      (assert (= actual \"table\")
              (string.format \"table expected, got %s\" actual))))
```"
  (assert (= (type expected) :string)
          (string.format "expected type invalid or missing: %s"
                         (fennel.view expected)))
  (let [fmt (.. expected " expected, got %s")
        checks (accumulate [checks [] _ x (ipairs items)]
                 (do (table.insert checks
                                   `(let [actual# (type ,x)]
                                      (assert (= actual# ,expected)
                                              (string.format ,fmt actual#))))
                     checks))]
    (case (length checks)
      0 nil
      1 (. checks 1)
      _ `(do ,(unpack checks)))))

(fn map-values [function & varg]
  "Apply the `function` on each of `varg`, and return the results as multiple values.

This is similar to `map-values` in [SRFI-210](https://srfi.schemers.org/srfi-210/),
but consumes varg directly.

# Examples

```fennel :skip-test
(map-values #(+ 1 $) 1 2 3) ;=> 2\t3\t4
```"
  (let [%unpack (if table.unpack `table.unpack `unpack)]
    `(,%unpack (icollect [_# arg# (ipairs [,(unpack varg)])]
                 (,function arg#)))))

(fn tset+ [tbl & rest]
  {:fnl/docstring "Wrapper for `tset` that returns the updated `table`.

The rest args `...` are passed to `tset`.

# Examples

```fennel :skip-test
(accumulate [t {} _ w (ipairs [:a :b :c])]
  (tset+ t w true))
; => {:a true, :b true, :c true}
```"
   :fnl/arglist [table ...]}
  `(do (tset ,tbl ,(unpack rest))
       ,tbl))

(fn unless [condition & body]
  "If the `condition` is falsy, evaluate `body`."
  `(when (not ,condition) ,(unpack body)))

{: assert-type : map-values : tset+ : unless}
