# Init.fnl (1.0.0)

General utilities.

**Table of contents**

- Function: [`assert-type`](#function-assert-type)
- Function: [`equal?`](#function-equal)

## Function: `assert-type`

```
(assert-type expected x)
```

Check if `x` is of the `expected` type.

Return evaluated `x` if passed the check; otherwise raise an error.

### Examples

```fennel
(let [x {:a 1}] (assert-type :table x)) ; => {:a 1}
```

```fennel
(let [b :string] (assert-type :number b))
; => runtime error: number expected, got "string"
```

## Function: `equal?`

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

<!-- Generated with Fnldoc 1.1.0-dev-66c2ee5
     https://sr.ht/~m15a/fnldoc/ -->
