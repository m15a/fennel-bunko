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

(fn insert [seq ...]
  {:fnl/docstring "Wrapper for `table.insert` that returns the updated `table`.

The `rest-args` are passed to `table.insert`."
   :fnl/arglist [table & rest-args]}
  (table.insert seq ...)
  seq)

(fn sort [seq ...]
  {:fnl/docstring "Wrapper for `table.sort` that returns the sorted `table`.

The `rest-args` are passed to `table.sort`."
   :fnl/arglist [table & rest-args]}
  (table.sort seq ...)
  seq)

(fn update [tbl key value]
  {:fnl/docstring "Wrapper for `tset` that returns the updated `table`.

As usual, the content of `key` will be replaced with the `value`."
   :fnl/arglist [table key value]}
  (tset tbl key value)
  tbl)

(fn merge [...]
  "Merge all the given non-sequential `tables`.

Return `nil` and an error message for no arguments."
  {:fnl/arglist [& tables]}
  (case (select "#" ...)
    0 (values nil "merge: no tables found")
    _ (do (assert-type :table ...)
          (accumulate [result {} _ tbl (ipairs [...])]
            (accumulate [result result key value (pairs tbl)]
              (update result key value))))))

(fn append [...]
  "Concatenate all the given sequential `tables`.

Return `nil` and an error message for no arguments."
  {:fnl/arglist [& tables]}
  (case (select "#" ...)
    0 (values nil "append: no tables found")
    _ (do (assert-type :table ...)
          (accumulate [result [] _ seq (ipairs [...])]
            (accumulate [result result _ x (ipairs seq)]
              (insert result x))))))

{: copy : keys : items : insert : sort : update : merge : append}
