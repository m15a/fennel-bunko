# Macros.fnl

**Table of contents**

- [`assert-type`](#assert-type)
- [`map-values`](#map-values)
- [`tset+`](#tset)

## `assert-type`
Function signature:

```
(assert-type expected & items)
```

Check if each of `items` is of the `expected` type.

### Examples

```fennel
(assert-type :table x y)
```

is expanded to

```fennel
(do (let [actual (type x)]
      (assert (= actual "table")
              (string.format "table expected, got %s" actual)))
    (let [actual (type y)]
      (assert (= actual "table")
              (string.format "table expected, got %s" actual))))
```

## `map-values`
Function signature:

```
(map-values function & varg)
```

Apply the `function` on each of `varg`, and return the results as multiple values.

This is similar to `map-values` in [SRFI-210](https://srfi.schemers.org/srfi-210/),
but consumes varg directly.

### Examples

```fennel
(map-values #(+ 1 $) 1 2 3) ;=> 2	3	4
```

## `tset+`
Function signature:

```
(tset+ table ...)
```

Wrapper for `tset` that returns the updated `table`.

The rest args `...` are passed to `tset`.

### Examples

```fennel
(accumulate [t {} _ w (ipairs [:a :b :c])]
  (tset+ t w true))
; => {:a true, :b true, :c true}
```


<!-- Generated with Fenneldoc 1.0.1-dev
     https://gitlab.com/andreyorst/fenneldoc -->
