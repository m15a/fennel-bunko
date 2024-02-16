# Macros.fnl

**Table of contents**

- [`assert-type`](#assert-type)

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


<!-- Generated with Fenneldoc 1.0.1-dev
     https://gitlab.com/andreyorst/fenneldoc -->
