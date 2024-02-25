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
(local %unpack (if table.unpack `table.unpack `unpack))

(fn copy [tbl]
  (let [clone (collect [k v (pairs tbl)] k v)]
    (setmetatable clone (getmetatable tbl))))

(fn assert-type [expected & exprs]
  "Check if each of `expressions` is of the `expected` type.

Return evaluated `expressions` as multiple values if all the checks are passed;
otherwise raise an error caused by the check which failed first.

Note that the `expected` type should be determined at compile time.
So, it cannot be done like:

```fennel :skip-test
(assert-type (if condition :string :number) x)
```

# Examples

```fennel
(let [x {:a 1}
      y {:b 2}]
  (assert-type :table x y))
; => {:a 1}\t{:b 2}
```

```fennel :skip-test
(let [a 1 b :string c {:c :c}]
  (assert-type :number a b c))
; => runtime error: number expected, got string
```"
  {:fnl/arglist [expected & expressions]}
  (assert-compile (= :string (type expected))
                  "expected type invalid or missing" expected)
  (let [fmt (.. expected " expected, got %s")
        checks (accumulate [checks [] _ expr (ipairs exprs)]
                 (doto checks
                   (table.insert `(let [actual# (type ,expr)]
                                    (assert (= actual# ,expected)
                                            (string.format ,fmt actual#))
                                    ,expr))))]
    (case (length checks)
      0 nil
      1 (. checks 1)
      _ `(values ,(unpack checks)))))

(fn map-values [function & varg]
  "Apply the `function` on each of `varg` and return the results as multiple values.

This is similar to `map-values` in [SRFI-210][1], but consumes `varg` directly.

[1]: https://srfi.schemers.org/srfi-210/

# Examples

```fennel
(let [(a b c)
      (map-values #(+ 1 $) 1 2 3) ;=> 2\t3\t4
      ]
  (assert (and (= a 2) (= b 3) (= c 4))))
```"
  `(,%unpack (icollect [_# arg# (ipairs [,(unpack varg)])]
               (,function arg#))))

(fn unless [condition & body]
  "If the `condition` is falsy, evaluate each of `body` sequentially."
  `(when (not ,condition) ,(unpack body)))

(fn immutably [mutate! tbl & args]
  "Turn a `mutator!`, which usually mutates a `table`, into non-destructive one.

The `mutator!` can be function or macro of signature `(mutator! table & args)`,
for example `tset` or `table.insert`.
It shallowly copies the `table`,
applies the `mutator!` with the `args` to the copy,
and returns the mutated copy.

```fennel :skip-test
(immutably mutate! tbl ...)
```

is equivalent to

```fennel :skip-test
(doto (copy tbl) (mutate! ...))
```

where `copy` is a function to make a shallow copy of the `tbl`.

Note that it does not set the metatable of the copy to the original.

# Examples

```fennel
(let [x {:a 1}
      y (immutably tset x :a 2) ;=> {:a 2}
      ]
  (assert (= y.a 2))
  (assert (= x.a 1)))
```"
  {:fnl/arglist [mutator! table & args]}
  (let [%pairs `(fn [t#] (values next t# nil)) ; ignore __pairs metamethod
        %copy `(fn [tbl#]
                 (let [clone# (collect [k# v# (,%pairs tbl#)]
                                k#
                                v#)]
                   (setmetatable clone# (getmetatable tbl#))))]
    `(let [clone# (,%copy ,tbl)]
       (doto clone#
         (,mutate! ,(unpack args))))))

(fn find-any [iter-tbl pred-expr ...]
  "Find any values yielded by an iterator on which a predicate expression returns true.

It runs through an iterator and in each step evaluates a `predicate-expression`.
If the evaluated result is truthy, it immediately returns the (multiple) values
yielded by the iterator.

Note that the `bindings` cannot have `&until` clause as the clause will be inserted
implicitly in this macro.

# Examples

```fennel
(let [(i v) (find-any [_ n (ipairs [:a 1 {} 2])]
              (= (type n) :number)) ;=> 2\t1
      ]
  (assert (and (= i 2) (= v 1))))

(let [(k v) (find-any [k v (pairs {:a :A :b {} :c :cc})]
              (and (= (type v) :string)
                   (: v :match (.. \"^\" k)))) ;=> :c\t:cc
      ]
  (assert (and (= k :c) (= v :cc))))
```"
  {:fnl/arglist [bindings predicate-expression]}
  (assert (and (sequence? iter-tbl) (<= 2 (length iter-tbl)))
          "expected iterator binding table")
  (assert (not= nil pred-expr) "expected predicate expression")
  (assert (= nil ...)
          "expected only one expression; wrap multiple expressions with do")
  (let [kv-tbl (fcollect [i 1 (- (length iter-tbl) 1)]
                 (. iter-tbl i))
        iter-tbl (doto (copy iter-tbl)
                   (table.insert 1 `found#)
                   (table.insert 2 `nil)
                   (table.insert `&until)
                   (table.insert `found#))]
    `(let [found# (accumulate ,iter-tbl (when ,pred-expr ,kv-tbl))]
       (when found# (,%unpack found#)))))

{: assert-type : map-values : unless : immutably : find-any}
