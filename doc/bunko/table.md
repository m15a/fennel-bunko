# Table.fnl

**Table of contents**

- [`append`](#append)
- [`copy`](#copy)
- [`insert`](#insert)
- [`items`](#items)
- [`keys`](#keys)
- [`merge`](#merge)
- [`sort`](#sort)
- [`update`](#update)

## `append`
Function signature:

```
(append & tables)
```

Concatenate all the given sequential `tables`.

Return `nil` and an error message for no arguments.

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
(insert table & rest-args)
```

Wrapper for `table.insert` that returns the updated `table`.

The `rest-args` are passed to `table.insert`.

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

Return `nil` and an error message for no arguments.

## `sort`
Function signature:

```
(sort table & rest-args)
```

Wrapper for `table.sort` that returns the sorted `table`.

The `rest-args` are passed to `table.sort`.

## `update`
Function signature:

```
(update table key value)
```

Wrapper for `tset` that returns the updated `table`.

As usual, the content of `key` will be replaced with the `value`.


<!-- Generated with Fenneldoc 1.0.1-dev
     https://gitlab.com/andreyorst/fenneldoc -->
