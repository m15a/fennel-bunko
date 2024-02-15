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
(import-macros {: assert-type}
               (.. (: ... :match "(.+)%.[^.]+") :.macros))

;; Lua >=5.2: `__pairs` may be changed from its default, so we need to use `next`.
(macro %copy [tbl]
  (if _G.next
      `(do (var index# nil)
           (var done?# false)
           (var result# {})
           (while (not done?#)
             (let [(k# v#) (next ,tbl index#)]
               (if k#
                   (do (set index# k#)
                       (tset result# k# v#))
                   (set done?# true))))
           result#)
      `(collect [k# v# (pairs ,tbl)]
         (values k# v#))))

(lambda copy [tbl ?metatable]
  "Return a shallow copy of the table.

Optionally set the same metatable as the original's."
  (let [clone (%copy tbl)]
    (if ?metatable
        (setmetatable clone (getmetatable tbl))
        clone)))

(lambda keys [tbl]
  "Return all keys in the table."
  (icollect [key _ (pairs tbl)]
    key))

(lambda %values [tbl]
  "Return all values in the table."
  (icollect [_ value (pairs tbl)]
    value))

(lambda insert [seq ...]
  "Do `table.insert` and return the updated table.

The rest args are passed to `table.insert`."
  (table.insert seq ...)
  seq)

(lambda sort [seq ...]
  "Do `table.sort` and return the sorted table.

The rest args are passed to `table.sort`."
  (table.sort seq ...)
  seq)

(lambda update [tbl key value]
  "Do `tset` and return the updated table."
  (tset tbl key value)
  tbl)

(fn merge [...]
  "Merge all the given non-sequential tables.

Return `nil` for no arguments."
  (case (select :# ...)
    0 nil
    _ (do (assert-type :table ...)
          (accumulate [result {} _ tbl (ipairs [...])]
            (accumulate [result result key value (pairs tbl)]
              (update result key value))))))

(fn flatten [...]
  "Concatenate all the given sequential tables."
  (assert-type :table ...)
  (accumulate [result [] _ seq (ipairs [...])]
    (accumulate [result result _ x (ipairs seq)]
      (insert result x))))

{: copy
 : keys
 :values %values
 : insert
 : sort
 : update
 : merge
 : flatten}
