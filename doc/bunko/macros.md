# Macros.fnl

**Table of contents**

- [`assert-type`](#assert-type)
- [`immutably`](#immutably)
- [`map-values`](#map-values)
- [`unless`](#unless)

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

(let [a 1 b :string c {:c :c}]
  (assert-type :number a b c))
; => runtime error: number expected, got string
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
(immutably mutate! tbl ...))
```

is equivalent to

```fennel
(let [copy (fn [t] ...)] ; function to copy a table shallowly
  (doto (copy tbl) (mutate! ...))
```

Note that it does not set the metatable of the copy to the original.

### Examples

```fennel
(local x {:a 1})
(immutably tset x :a 2) ;=> {:a 2}
x ;=> {:a 1}
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
(map-values #(+ 1 $) 1 2 3) ;=> 2	3	4
```

## `unless`
Function signature:

```
(unless condition & body)
```

If the `condition` is falsy, evaluate each of `body` sequentially.


<!-- Generated with Fenneldoc 1.0.1-dev-7960056
     https://gitlab.com/andreyorst/fenneldoc -->
