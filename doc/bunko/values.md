# Values.fnl

**Table of contents**

- [`map-values`](#map-values)

## `map-values`
Function signature:

```
(map-values & vargs)
```

Apply the function on each of `vargs`, and return the results as multiple values.

This is similar to `map-values` in [SRFI-210](https://srfi.schemers.org/srfi-210/),
but consumes vargs directly.

### Example

```fennel
(assert (let [(x y z) (map-values #(+ 1 $) 1 2 3)]
          (and (= x 2)
               (= y 3)
               (= z 4))))
```


<!-- Generated with Fenneldoc 1.0.1-dev
     https://gitlab.com/andreyorst/fenneldoc -->
