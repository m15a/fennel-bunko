# Table.fnl

**Table of contents**

- [`append`](#append)
- [`copy`](#copy)
- [`insert+`](#insert)
- [`items`](#items)
- [`keys`](#keys)
- [`merge`](#merge)
- [`sort+`](#sort)
- [`update`](#update)

## `append`
Function signature:

```
(append & tables)
```

Concatenate all the given sequential `tables`.

Return `nil` and a warning message in case of no arguments.

### Examples

```fennel
(append [1] [2 3] [4]) ;=> [1 2 3 4]
```

## `copy`
Function signature:

```
(copy table ?metatable)
```

Return a shallow copy of the `table`.

Optionally, if `?metatable` is truthy, set the same metatable as the original's.

## `insert+`
Function signature:

```
(insert+ table ...)
```

Wrapper for `table.insert` that returns the updated `table`.

The rest args `...` are passed to `table.insert`.

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

## `merge`
Function signature:

```
(merge & tables)
```

Merge all the given non-sequential `tables`.

Return `nil` and a warning message in case of no arguments.

### Examples

```fennel
(merge {:a 1 :b 2} {:a 2 :c 3}) ;=> {:a 2 :b 2 :c 3}
```

## `sort+`
Function signature:

```
(sort+ table ...)
```

Wrapper for `table.sort` that returns the sorted `table`.

The rest args `...` are passed to `table.sort`.

## `update`
Function signature:

```
(update table key function default)
```

Update the value of the `key` using the `function`.

The `function` takes the value of the `key` as an argument and its returned value
will replace the old value. If the value of the `key` is missing, the `default`
value will be consumed by the `function`.
Finally return the updated `table`.

### Examples

```fennel
(update {:a 1} :a #(+ $ 1)) ;=> {:a 2}
(update {} :a #(+ $ 1) 0)   ;=> {:a 1}

(accumulate [counts {}
             _ w (ipairs [:a :b :c :b :c :c])]
  (update counts w #(+ 1 $) 0))
;=> {:a 1 :b 2 :c 3}
```


<!-- Generated with Fenneldoc 1.0.1-dev
     https://gitlab.com/andreyorst/fenneldoc -->
