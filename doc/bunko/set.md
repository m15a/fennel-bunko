# Set.fnl (0.1.0)
Set algebra on Lua table, where each table is regarded as a set of keys.

**Table of contents**

- [`subset?`](#subset)
- [`union!`](#union)
- [`intersection!`](#intersection)
- [`difference!`](#difference)
- [`powerset`](#powerset)

## `subset?`
Function signature:

```
(subset? left right)
```

Return `true` if the `left` table, regarded as a set, is subset of the `right`.

Return `false` otherwise.

### Examples

```fennel
(let [x {:a 1}
      y {:a true :b :b}
      q1 (subset? x y) ;=> true
      q2 (subset? y x) ;=> false
      ]
  (assert (and q1 (not q2))))
```

## `union!`
Function signature:

```
(union! table & tables)
```

Modify the `table` to be the union of all the `table` and `tables`.

Each table is regarded as a set of keys, and its values just indicate that
the elements (i.e., keys) exist in the set.
`union!` is actually equivalent to `bunko.table.merge!`.

### Examples 

```fennel
(let [x (doto {:a :a} (union! {:a 1} {:b :b})) ;=> {:a 1 :b :b}
      ]
  (assert (and (= x.a 1)
               (= x.b :b))))
```

## `intersection!`
Function signature:

```
(intersection! table & tables)
```

Modify the `table` to be the intersection of all the `table` and `tables`.

Each table is regarded as a set of keys, and its values just indicate that
the elements (i.e., keys) exist in the set.

### Examples 

```fennel
(let [x (doto {:a :a :b :b} (intersection! {:a 1})) ;=> {:a :a}
      ]
  (assert (and (= x.a :a)
               (= (. x :b) nil))))
```

## `difference!`
Function signature:

```
(difference! table & tables)
```

Modify the `table` to be the difference between the `table` and the `tables`.

Each table is regarded as a set of keys, and its values just indicate that
the elements (i.e., keys) exist in the set.

### Examples 

```fennel
(let [x (doto {:a :a :b :b} (difference! {:a 1} {:c :c})) ;=> {:b :b}
      ]
  (assert (and (= x.b :b)
               (= (. x :a) nil))))
```

## `powerset`
Function signature:

```
(powerset table)
```

Return, as a sequential table, the power set of the `table`.

Each table is regarded as a set of keys, and its values just indicate that
the elements (i.e., keys) exist in the set.

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


<!-- Generated with Fenneldoc 1.0.1-dev-7960056
     https://gitlab.com/andreyorst/fenneldoc -->
