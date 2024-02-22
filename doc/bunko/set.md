# Set.fnl

**Table of contents**

- [`difference!`](#difference)
- [`intersection!`](#intersection)
- [`powerset`](#powerset)
- [`subset?`](#subset)
- [`union!`](#union)

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
(doto {:a :a :b :b} (difference! {:a 1} {:c :c})) ;=> {:b :b}
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
(doto {:a :a :b :b} (intersection! {:a 1})) ;=> {:a :a}
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
(powerset {:a 1 :b :b})
;=> [{} {:a 1} {:b :b} {:a 1 :b :b}]
; CAVEAT: The order could be different from the above example.
```

## `subset?`
Function signature:

```
(subset? left right)
```

Check if the `left` table, regarded as a set, is subset of the `right` table.

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
(doto {:a :a} (union! {:a 1} {:b :b})) ;=> {:a 1 :b :b}
```


<!-- Generated with Fenneldoc 1.0.1-dev-7960056
     https://gitlab.com/andreyorst/fenneldoc -->
