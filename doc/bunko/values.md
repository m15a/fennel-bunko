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

### Examples

```fennel
(map-values #(+ 1 $) 1 2 3) ;=> 2	3	4
```


<!-- Generated with Fenneldoc 1.0.1-dev
     https://gitlab.com/andreyorst/fenneldoc -->
