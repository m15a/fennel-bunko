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

(import-macros {: assert-type} :bunko)

(macro %copy [tbl]
  ;; Lua >=5.2: `__pairs` may be changed from its default,
  ;; so we need to use `next`.
  (let [%pairs `(fn [t#] (values next t# nil))]
    `(collect [k# v# (,%pairs ,tbl)]
       (values k# v#))))

(fn copy [tbl ?metatable]
  "Return a shallow copy of the `table`.

Optionally, if `?metatable` is truthy, set the same metatable as the original's."
  {:fnl/arglist [table ?metatable]}
  (let [tbl (assert-type :table tbl)
        clone (%copy tbl)]
    (if ?metatable
        (setmetatable clone (getmetatable tbl))
        clone)))

(fn keys [tbl]
  "Return all keys in the `table`."
  {:fnl/arglist [table]}
  (icollect [key _ (pairs tbl)] key))

(fn items [tbl]
  "Return all values in the `table`."
  {:fnl/arglist [table]}
  (icollect [_ value (pairs tbl)] value))

(fn update! [tbl key function default]
  "Modify the `table` with the value of the `key` updated by the `function`.

The `function` takes the value of the `key` as an argument and its
returned value will replace the old value.
If the value of the `key` is missing, the `default` value will be
consumed by the `function`.
It finally returns `nil`.

# Examples

```fennel
(let [t {:a 1}
      returned (update! t :a #(+ $ 1)) ;=> nil
      ]
  (assert (and (= t.a 2)
               (= returned nil))))

(let [x (doto {} (update! :a #(+ $ 1) 0)) ;=> {:a 1}
      ]
  (assert (= x.a 1)))

(let [xs [:a :b :c :b :c :c]
      counts (accumulate [c {} _ x (ipairs xs)]
               (doto c (update! x #(+ 1 $) 0))) ;=> {:a 1 :b 2 :c 3}
      ]
  (assert (and (= counts.a 1)
               (= counts.b 2)
               (= counts.c 3))))
```"
  {:fnl/arglist [table key function default]}
  (tset tbl key (function (let [found (. tbl key)]
                            (if (not= nil found)
                                found
                                default)))))

(fn merge! [tbl ...]
  "Merge all the non-sequential `tables` into the first `table`.

The operations will be executed from left to right.
It returns `nil`.

# Examples

```fennel
(let [x (doto {:a 1} (merge! {:a nil :b 1} {:b 2})) ;=> {:a 1 :b 2}
      ]
  (assert (and (= x.a 1)
               (= x.b 2))))
```"
  {:fnl/arglist [table & tables]}
  (let [to (assert-type :table tbl)]
    (each [_ from (ipairs [(assert-type :table ...)])]
      (each [key value (pairs from)]
        (tset to key value)))))

(fn append! [tbl ...]
  "Concatenate all the sequential `tables` into the first `table`.

The operations will be executed from left to right.
It returns `nil`.

# Examples

```fennel
(let [x (doto [1] (append! [2 3] [4])) ;=> [1 2 3 4]
      ]
  (assert (and (= (. x 1) 1)
               (= (. x 2) 2)
               (= (. x 3) 3)
               (= (. x 4) 4))))
```"
  {:fnl/arglist [table & tables]}
  (let [to (assert-type :table tbl)]
    (each [_ from (ipairs [(assert-type :table ...)])]
      (each [_ x (ipairs from)]
        (table.insert to x)))))

{: copy : keys : items : update! : merge! : append!}
