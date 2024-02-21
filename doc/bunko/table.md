# Table.fnl

**Table of contents**

- [`append!`](#append)
- [`copy`](#copy)
- [`items`](#items)
- [`keys`](#keys)
- [`merge!`](#merge)
- [`update!`](#update)

## `append!`
Function signature:

```
(append! table & tables)
```

Concatenate all the sequential `tables` into the first `table`.

The operations will be executed from left to right. Returns `nil`.

### Examples

```fennel
(doto [1] (append! [2 3] [4]) ;=> [1 2 3 4]
```

## `copy`
Function signature:

```
(copy table ?metatable)
```

Return a shallow copy of the `table`.

Optionally, if `?metatable` is truthy, set the same metatable as the original's.

## `items`
Function signature:

```
(items table)
```

Return all values in the `table`.

## `keys`
Function signature:

```
(keys table)
```

Return all keys in the `table`.

## `merge!`
Function signature:

```
(merge! table & tables)
```

Merge all the non-sequential `tables` into the first `table`.

The operations will be executed from left to right. Returns `nil`.

### Examples

```fennel
(doto {:a 1} (merge! {:a 0 :b 1} {:b 2})) ;=> {:a 0 :b 2}
```

## `update!`
Function signature:

```
(update! table key function default)
```

Update the value of the `key` in the `table` using the `function`.

The `function` takes the value of the `key` as an argument and its returned value
will replace the old value. If the value of the `key` is missing, the `default`
value will be consumed by the `function`. Returns `nil`.

Note that the target `table` will be mutated.

### Examples

```fennel
(local t {:a 1})
(update! t :a #(+ $ 1)) ;=> nil
t ;=> {:a 2}

(doto {} (update! :a #(+ $ 1) 0)) ;=> {:a 1}

(accumulate [counts {}
             _ w (ipairs [:a :b :c :b :c :c])]
  (doto counts (update! w #(+ 1 $) 0)))
;=> {:a 1 :b 2 :c 3}
```


<!-- Generated with Fenneldoc 1.0.1-dev-7960056
     https://gitlab.com/andreyorst/fenneldoc -->
