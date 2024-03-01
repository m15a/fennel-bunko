;;;; ==========================================================================
;;;; Set algebra on Lua table.
;;;;
;;;; Here, each table is regarded as a set of keys. A non-nil value, including
;;;; `false`, indicates that the corresponding key exists in the set.
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

(import-macros {: assert-type : unless : for-all?} :bunko)
(local {: copy : merge! : append!} (require :bunko.table))

(fn subset? [left right]
  "Return `true` if the `left` table as a set is subset of the `right` table as a set.

Return `false` otherwise.

# Examples

```fennel
(let [x {:a true}
      y {:a false :b :b}
      q1 (subset? x y) ;=> true
      q2 (subset? y x) ;=> false
      ]
  (assert (and q1 (not q2))))
```"
  (assert-type :table left right)
  (accumulate [yes true key _ (pairs left) &until (not yes)]
    (if (not= nil (. right key)) yes false)))

(fn set= [...]
  "Return `true` if all the `tables` are of the same set.

# Examples

```fennel
(let [x {:a false}
      y {:a true}
      z {:a 1}
      q (set= x y z) ;=> true
      ]
  (assert (= q true)))
```"
  {:fnl/arglist [& tables]}
  (for-all? [_ x (ipairs [...])]
            (for-all? [_ y (ipairs [...])] (or (= x y) (subset? x y)))))

(fn union! [...]
  "Modify the `table` to be the union of all the `table` and `tables`.

It is actually equivalent to `bunko.table.merge!`.

# Examples 

```fennel
(let [x (doto {:a :a} (union! {:a 1} {:b :b})) ;=> {:a 1 :b :b}
      ]
  (assert (and (= x.a 1)
               (= x.b :b))))
```"
  {:fnl/arglist [table & tables]}
  (merge! ...))

(fn intersection! [tbl ...]
  "Modify the `table` to be the intersection of all the `table` and `tables`.

Note that even a `false` value indicates the corresponding key exists in the set.

# Examples 

```fennel
(let [x (doto {:a :a :b :b} (intersection! {:a false})) ;=> {:a :a}
      ]
  (assert (and (= x.a :a)
               (= (. x :b) nil))))
```"
  {:fnl/arglist [table & tables]}
  (let [to (assert-type :table tbl)]
    (each [_ from (ipairs [(assert-type :table ...)])]
      (each [key _ (pairs to)]
        (unless (not= nil (. from key)) (tset to key nil))))))

(fn difference! [tbl ...]
  "Modify the `table` to be the difference between the `table` and the `tables`.

Note that even a `false` value indicates the corresponding key exists in the set.

# Examples 

```fennel
(let [x (doto {:a :a :b :b} (difference! {:a false} {:c :c})) ;=> {:b :b}
      ]
  (assert (and (= x.b :b)
               (= (. x :a) nil))))
```"
  {:fnl/arglist [table & tables]}
  (let [to (assert-type :table tbl)]
    (each [_ from (ipairs [(assert-type :table ...)])]
      (each [key _ (pairs from)]
        (tset to key nil)))))

(fn powerset [tbl]
  "Return, as a sequential table, the power set of the `table`.

# Examples

```fennel
(let [origin {:a 1 :b :b}
      pow (powerset origin)
        ;=> [{} {:a 1} {:b :b} {:a 1 :b :b}]
        ; CAVEAT: The order could be different from this!
      ]
  (each [_ x (ipairs pow)]
    (assert (subset? x origin))))
```"
  {:fnl/arglist [table]}
  (accumulate [sets [{}] key value (pairs (assert-type :table tbl))]
    (doto sets
      (append! (icollect [_ s (ipairs sets)]
                 (doto (copy s) (tset key value)))))))

{: subset? : set= : union! : intersection! : difference! : powerset}
