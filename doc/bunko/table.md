# Table.fnl (0.1.0)
Table extras.

**Table of contents**

- [`copy`](#copy)
- [`keys`](#keys)
- [`items`](#items)
- [`update!`](#update)
- [`merge!`](#merge)
- [`append!`](#append)

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


---

License: Unlicense


<!-- Generated with Fenneldoc 1.0.1-dev-7960056
     https://gitlab.com/andreyorst/fenneldoc -->
