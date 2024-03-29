# Set.fnl (1.0.0)

Set algebra on Lua table.

Here, each table is regarded as a set of keys. A non-nil value, including
`false`, indicates that the corresponding key exists in the set.

**Table of contents**

- Function: [`subset?`](#function-subset)
- Function: [`set=`](#function-set)
- Function: [`union!`](#function-union)
- Function: [`intersection!`](#function-intersection)
- Function: [`difference!`](#function-difference)
- Function: [`powerset`](#function-powerset)

## Function: `subset?`

```
(subset? left right)
```

Return `true` if the `left` table as a set is subset of the `right` table as a set.

Return `false` otherwise.

### Examples

```fennel
(let [x {:a true}
      y {:a false :b :b}
      q1 (subset? x y) ;=> true
      q2 (subset? y x) ;=> false
      ]
  (assert (and q1 (not q2))))
```

## Function: `set=`

```
(set= & tables)
```

Return `true` if all the `tables` are of the same set.

### Examples

```fennel
(let [x {:a false}
      y {:a true}
      z {:a 1}
      q (set= x y z) ;=> true
      ]
  (assert (= q true)))
```

## Function: `union!`

```
(union! table & tables)
```

Modify the `table` to be the union of all the `table` and `tables`.

It is actually equivalent to `bunko.table.merge!`.

### Examples 

```fennel
(let [x (doto {:a :a} (union! {:a 1} {:b :b})) ;=> {:a 1 :b :b}
      ]
  (assert (and (= x.a 1)
               (= x.b :b))))
```

## Function: `intersection!`

```
(intersection! table & tables)
```

Modify the `table` to be the intersection of all the `table` and `tables`.

Note that even a `false` value indicates the corresponding key exists in the set.

### Examples 

```fennel
(let [x (doto {:a :a :b :b} (intersection! {:a false})) ;=> {:a :a}
      ]
  (assert (and (= x.a :a)
               (= (. x :b) nil))))
```

## Function: `difference!`

```
(difference! table & tables)
```

Modify the `table` to be the difference between the `table` and the `tables`.

Note that even a `false` value indicates the corresponding key exists in the set.

### Examples 

```fennel
(let [x (doto {:a :a :b :b} (difference! {:a false} {:c :c})) ;=> {:b :b}
      ]
  (assert (and (= x.b :b)
               (= (. x :a) nil))))
```

## Function: `powerset`

```
(powerset table)
```

Return, as a sequential table, the power set of the `table`.

### Examples

```fennel
(let [origin {:a 1 :b :b}
      pow (powerset origin)
        ;=> [{} {:a 1} {:b :b} {:a 1 :b :b}]
        ; CAVEAT: The order could be different from this!
      ]
  (each [_ x (ipairs pow)]
    (assert (subset? x origin))))
```

---

License: Unlicense

<!-- Generated with Fnldoc 1.1.0-dev-66c2ee5
     https://sr.ht/~m15a/fnldoc/ -->
