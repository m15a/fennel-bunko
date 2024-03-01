# Init-macros.fnl (1.0.0)
Miscellaneous macros.

**Table of contents**

- [`unless`](#unless)
- [`assert-type`](#assert-type)
- [`map-values`](#map-values)
- [`immutably`](#immutably)
- [`find-some`](#find-some)
- [`for-some?`](#for-some)
- [`for-all?`](#for-all)

## `unless`
Function signature:

```
(unless condition & body)
```

If the `condition` is falsy, evaluate each of `body` sequentially.

## `assert-type`
Function signature:

```
(assert-type expected & expressions)
```

Check if each of `expressions` is of the `expected` type.

Return evaluated `expressions` as multiple values if all the checks are passed;
otherwise raise an error caused by the check which failed first.

Note that the `expected` type should be determined at compile time.
So, it cannot be done like:

```fennel
(assert-type (if condition :string :number) x)
```

### Examples

```fennel
(let [x {:a 1}
      y {:b 2}]
  (assert-type :table x y))
; => {:a 1}	{:b 2}
```

```fennel
(let [a 1 b :string c {:c :c}]
  (assert-type :number a b c))
; => runtime error: number expected, got string
```

## `map-values`
Function signature:

```
(map-values function & varg)
```

Apply the `function` on each of `varg` and return the results as multiple values.

This is similar to `map-values` in [SRFI-210][1], but consumes `varg` directly.

[1]: https://srfi.schemers.org/srfi-210/

### Examples

```fennel
(let [(a b c)
      (map-values #(+ 1 $) 1 2 3) ;=> 2	3	4
      ]
  (assert (and (= a 2) (= b 3) (= c 4))))
```

## `immutably`
Function signature:

```
(immutably mutator! table & args)
```

Turn a `mutator!`, which usually mutates a `table`, into non-destructive one.

The `mutator!` can be function or macro of signature `(mutator! table & args)`,
for example `tset` or `table.insert`.
It shallowly copies the `table`,
applies the `mutator!` with the `args` to the copy,
and returns the mutated copy.

```fennel
(immutably mutate! tbl ...)
```

is equivalent to

```fennel
(doto (copy tbl) (mutate! ...))
```

where `copy` is a function to make a shallow copy of the `tbl`.

### Examples

```fennel
(let [x {:a 1}
      y (immutably tset x :a 2) ;=> {:a 2}
      ]
  (assert (= y.a 2))
  (assert (= x.a 1)))
```

## `find-some`
Function signature:

```
(find-some bindings predicate-expression)
```

Find some values yielded by an iterator on which a predicate expression is truthy.

It runs through an iterator and in each step evaluates a `predicate-expression`.
If the evaluated result is truthy, it immediately returns the value(s) yielded
by the iterator.

Note that the `bindings` cannot have `&until` clause as the clause will be inserted
implicitly in this macro.

### Examples

```fennel
(let [(i v) (find-some [_ n (ipairs [:a 1 {} 2])]
              (= (type n) :number)) ;=> 2	1
      ]
  (assert (and (= i 2) (= v 1))))

(let [(k v) (find-some [k v (pairs {:a :A :b {} :c :cc})]
              (and (= (type v) :string)
                   (: v :match (.. "^" k)))) ;=> :c	:cc
      ]
  (assert (and (= k :c) (= v :cc))))
```

## `for-some?`
Function signature:

```
(for-some? bindings predicate-expression)
```

Test if a predicate expression is truthy for some example yielded by an iterator.

Similar to `find-some`, it runs through an iterator and in each step evaluates a
`predicate-expression`. If the evaluated result is truthy, it immediately returns
`true`; otherwise returns `false`.

Note that the `bindings` cannot have `&until` clause as the clause will be inserted
implicitly in this macro.

### Examples

```fennel
(let [q (for-some? [_ n (ipairs [:a 1 {} 2])]
          (= (type n) :number)) ;=> true
      ]
  (assert (= true q)))
```

## `for-all?`
Function signature:

```
(for-all? bindings predicate-expression)
```

Test if a predicate expression is truthy for all yielded by an iterator.

Similar to `for-some?`, but it checks whether a `predicate-expression` is truthy
for all yielded by the iterator. If so, it returns `true`, otherwise returns `false`.

Note that the `bindings` cannot have `&until` clause as the clause will be inserted
implicitly in this macro.

### Examples

```fennel
(let [q (for-all? [_ n (ipairs [:a 1 {} 2])]
          (= (type n) :number)) ;=> false
      ]
  (assert (= false q)))
```


---

License: Unlicense


<!-- Generated with Fenneldoc 1.0.1-dev-7960056
     https://gitlab.com/andreyorst/fenneldoc -->
