# Table.fnl (1.0.0)
Table extras.

**Table of contents**

- [`copy`](#copy)
- [`keys`](#keys)
- [`items`](#items)
- [`update!`](#update)
- [`merge!`](#merge)
- [`append!`](#append)
- [`unpack-then`](#unpack-then)

## `copy`
Function signature:

```
(copy table ?metatable)
```

Return a shallow copy of the `table`.

Optionally, if `?metatable` is truthy, set the same metatable as the original's.

## `keys`
Function signature:

```
(keys table)
```

Return all keys in the `table`.

## `items`
Function signature:

```
(items table)
```

Return all values in the `table`.

## `update!`
Function signature:

```
(update! table key function default)
```

Modify the `table` with the value of the `key` updated by the `function`.

The `function` takes the value of the `key` as an argument and its
returned value will replace the old value.
If the value of the `key` is missing, the `default` value will be
consumed by the `function`.
It finally returns `nil`.

### Examples

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
```

## `merge!`
Function signature:

```
(merge! table & tables)
```

Merge all the non-sequential `tables` into the first `table`.

The operations will be executed from left to right.
It returns `nil`.

### Examples

```fennel
(let [x (doto {:a 1} (merge! {:a nil :b 1} {:b 2})) ;=> {:a 1 :b 2}
      ]
  (assert (and (= x.a 1)
               (= x.b 2))))
```

## `append!`
Function signature:

```
(append! table & tables)
```

Concatenate all the sequential `tables` into the first `table`.

The operations will be executed from left to right.
It returns `nil`.

### Examples

```fennel
(let [x (doto [1] (append! [2 3] [4])) ;=> [1 2 3 4]
      ]
  (assert (and (= (. x 1) 1)
               (= (. x 2) 2)
               (= (. x 3) 3)
               (= (. x 4) 4))))
```

## `unpack-then`
Function signature:

```
(unpack-then table ...)
```

Append the rest arguments to the `table` and then unpack it.

Fennel does not have `unquote-splicing`, which most Lisp family languages use to
manipulate forms in macros. Instead, Fennel employs `unpack`, or `table.unpack`, to
achieve this. However, `unpack` splices all table contents only if that occurs at the
tail position in a form. Otherwise, merely the first content will be spliced.
For example,

```fennel
(local unpack (or table.unpack _G.unpack))

(fn every? [iter-tbl pred-expr]
  `(accumulate [ok?### true ,(unpack iter-tbl) &until (not ok?#)]
     (if ,pred-expr ok?### false)))
```

In the above macro, the tail forms `&until (not ok?#)` will be lost. This behavior
might be counter-intuitive for Lispers. To be correct, we may want to write a kind of

```fennel
(fn every? [iter-tbl pred-expr]
  (let [ok? `ok?#
        iter-tbl* (doto (copy iter-tbl)
                    (table.insert `&until)
                    (table.insert `(not ,ok?)))]
    `(accumulate [,ok? true ,(unpack iter-tbl*)]
       (if ,pred-expr ,ok? false))))
```

which is a bit tedious. `unpack-then` is a helper to slightly improve this situation.
Using `unpack-then`, we can write

```fennel
(fn every? [iter-tbl pred-expr]
  (let [ok? `ok?#]
    `(accumulate [,ok? true ,(unpack-then iter-tbl `&until `(not ,ok?))]
       (if ,pred-expr ,ok? false))))
```

Even though, `unquote-splicing`, i.e. `,@`, should be far better:

```fennel
(macro every? [iter-tbl pred-expr]
  `(accumulate [ok?### true ,@iter-tbl &until (not ok?#)]
     (if ,pred-expr ok?### false)
```


---

License: Unlicense


<!-- Generated with Fenneldoc 1.0.1-dev-7960056
     https://gitlab.com/andreyorst/fenneldoc -->
