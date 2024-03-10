;;;; ==========================================================================
;;;; General utilities.
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

(local {: view} (require :fennel))
(import-macros {: for-all?} :bunko)

(fn assert-type [expected x]
  "Check if `x` is of the `expected` type.

Return evaluated `x` if passed the check; otherwise raise an error.

# Examples

```fennel
(let [x {:a 1}] (assert-type :table x)) ; => {:a 1}
```

```fennel :skip-test
(let [b :string] (assert-type :number b))
; => runtime error: number expected, got \"string\"
```"
  (assert (case expected
            :nil true
            :boolean true
            :number true
            :string true
            :function true
            :userdata true
            :thread true
            :table true)
          (string.format "expected type invalid: %s" (view expected)))
  (let [fmt (.. expected " expected, got %s")]
    (assert (= expected (type x)) (string.format fmt (view x)))
    x))

(local M {})

(fn M.table= [x y]
  (let [checked-x-keys {}]
    (and (for-all? [x-key x-value (pairs x)]
           (do
             (tset checked-x-keys x-key true)
             (M.rec= x-value (. y x-key))))
         (for-all? [y-key _ (pairs y)] (. checked-x-keys y-key)))))

(fn M.rec= [x y]
  (or (= x y)
      (and (= :table (type x) (type y)) (= (getmetatable x) (getmetatable y))
           (M.table= x y))))

(lambda equal? [x y ...]
  "Check if `x`, `y`, and `...` are equal with comparing tables recursively.

Numbers, strings, userdata, and threads are compared just like compared by `=`.
Tables are compared not by their references but by their metatables, keys, and values.
Table values will be compared recursively by `equal?`.

If all the arguments are equal in the above sense, it returns `true`;
otherwise returns `false`.

# Examples

```fennel
(assert (= true (equal? 1 1.0)))
(assert (= true (equal? :a :a)))
(assert (= true (equal? {:a {:a :a}} {:a {:a :a}})))
(assert (= false (equal? {:a {:a :a}} {:a {:a :a}} {:a {:a 1}})))
```"
  (for-all? [_ t (ipairs [y ...])]
    (M.rec= x t)))

{: assert-type : equal?}
