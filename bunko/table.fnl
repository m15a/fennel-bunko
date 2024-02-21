;;;; ==========================================================================
;;;; Table extras.
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
(import-macros {: assert-type} :bunko.macros)

;; Lua >=5.2: `__pairs` may be changed from its default, so we need to use `next`.
(macro %copy [tbl]
  (if _G.next
      `(do (var index# nil)
           (var done?# false)
           (local result# {})
           (while (not done?#)
             (let [(k# v#) (next ,tbl index#)]
               (if k#
                   (do (set index# k#)
                       (tset result# k# v#))
                   (set done?# true))))
           result#)
      `(collect [k# v# (pairs ,tbl)]
         (values k# v#))))

(fn copy [tbl ?metatable]
  {:fnl/docstring "Return a shallow copy of the `table`.

Optionally, if `?metatable` is truthy, set the same metatable as the original's."
   :fnl/arglist [table ?metatable]}
  (assert-type :table tbl)
  (let [clone (%copy tbl)]
    (if ?metatable
        (setmetatable clone (getmetatable tbl))
        clone)))

(fn keys [tbl]
  {:fnl/docstring "Return all keys in the `table`." :fnl/arglist [table]}
  (icollect [key _ (pairs tbl)]
    key))

(fn items [tbl]
  {:fnl/docstring "Return all values in the `table`." :fnl/arglist [table]}
  (icollect [_ value (pairs tbl)]
    value))

(fn update [tbl key function default]
  {:fnl/docstring "Update the value of the `key` using the `function`.

The `function` takes the value of the `key` as an argument and its returned value
will replace the old value. If the value of the `key` is missing, the `default`
value will be consumed by the `function`.
Finally return the updated `table`.

# Examples

```fennel :skip-test
(update {:a 1} :a #(+ $ 1)) ;=> {:a 2}
(update {} :a #(+ $ 1) 0)   ;=> {:a 1}

(accumulate [counts {}
             _ w (ipairs [:a :b :c :b :c :c])]
  (update counts w #(+ 1 $) 0))
;=> {:a 1 :b 2 :c 3}
```"
   :fnl/arglist [table key function default]}
  (tset tbl key (function (or (. tbl key) default)))
  tbl)

(fn merge [...]
  "Merge all the given non-sequential `tables`.

Return `nil` and a warning message in case of no arguments.

# Examples

```fennel :skip-test
(merge {:a 1 :b 2} {:a 2 :c 3}) ;=> {:a 2 :b 2 :c 3}
```"
  {:fnl/arglist [& tables]}
  (case (select "#" ...)
    0 (values nil "merge: no tables found in the arguments")
    _ (do (assert-type :table ...)
          (accumulate [result {} _ tbl (ipairs [...])]
            (accumulate [result result key value (pairs tbl)]
              (doto result (tset key value)))))))

(fn append [...]
  "Concatenate all the given sequential `tables`.

Return `nil` and a warning message in case of no arguments.

# Examples

```fennel :skip-test
(append [1] [2 3] [4]) ;=> [1 2 3 4]
```"
  {:fnl/arglist [& tables]}
  (case (select "#" ...)
    0 (values nil "append: no tables found in the arguments")
    _ (do (assert-type :table ...)
          (accumulate [result [] _ seq (ipairs [...])]
            (accumulate [result result _ x (ipairs seq)]
              (doto result (table.insert x)))))))

{: copy : keys : items : update : merge : append}
