# Macros.fnl

**Table of contents**

- [`assert-type`](#assert-type)
- [`map-values`](#map-values)
- [`unless`](#unless)

## `assert-type`
Function signature:

```
(assert-type expected & items)
```

Check if each of `items` is of the `expected` type.

Return `items` as multiple values if all the checks are passed;
otherwise raise an error caused by the check failed first.

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

(let [a 1 b :string c {:c :c}]
  (assert-type :number a b c))
; => runtime error: number expected, got string
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

## `unless`
Function signature:

```
(unless condition & body)
```

If the `condition` is falsy, evaluate `body`.


<!-- Generated with Fenneldoc 1.0.1-dev-7960056
     https://gitlab.com/andreyorst/fenneldoc -->
