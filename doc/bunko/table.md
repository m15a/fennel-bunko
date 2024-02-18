# Table.fnl

**Table of contents**

- [`append`](#append)
- [`copy`](#copy)
- [`insert`](#insert)
- [`items`](#items)
- [`keys`](#keys)
- [`merge`](#merge)
- [`sort`](#sort)
- [`tset`](#tset)

## `append`
Function signature:

```
(append & tables)
```

Concatenate all the given sequential `tables`.

Return `nil` and a warning message in case of no arguments.

## `copy`
Function signature:

```
(copy table ?metatable)
```

Return a shallow copy of the `table`.

Optionally, if `?metatable` is truthy, set the same metatable as the original's.

## `insert`
Function signature:

```
(insert table ...)
```

Wrapper for `table.insert` that returns the updated `table`.

The rest args `...` are passed to `table.insert`.

## `items`
Function signature:

```
(items table)
```

Return all values in the `table`.

## `keys`
Function signature:

```
(keys table)
```

Return all keys in the `table`.

## `merge`
Function signature:

```
(merge & tables)
```

Merge all the given non-sequential `tables`.

Return `nil` and a warning message in case of no arguments.

## `sort`
Function signature:

```
(sort table ...)
```

Wrapper for `table.sort` that returns the sorted `table`.

The rest args `...` are passed to `table.sort`.

## `tset`
Function signature:

```
(tset table key value)
```

Wrapper for `tset` that returns the updated `table`.

The content of `key` will be replaced with the `value`.


<!-- Generated with Fenneldoc 1.0.1-dev
     https://gitlab.com/andreyorst/fenneldoc -->
