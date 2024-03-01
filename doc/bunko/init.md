# Init.fnl (1.0.0)
General utilities.

**Table of contents**

- [`equal?`](#equal)

## `equal?`
Function signature:

```
(equal? x y ...)
```

Check if `x`, `y`, and `...` are equal with comparing tables recursively.

Numbers, strings, userdata, and threads are compared just like compared by `=`.
Tables are compared not by their references but by their metatables, keys, and values.
Table values will be compared recursively by `equal?`.

If all the arguments are equal in the above sense, it returns `true`;
otherwise returns `false`.

### Examples

```fennel
(assert (= true (equal? 1 1.0)))
(assert (= true (equal? :a :a)))
(assert (= true (equal? {:a {:a :a}} {:a {:a :a}})))
(assert (= false (equal? {:a {:a :a}} {:a {:a :a}} {:a {:a 1}})))
```


---

License: Unlicense


<!-- Generated with Fenneldoc 1.0.1-dev-7960056
     https://gitlab.com/andreyorst/fenneldoc -->
