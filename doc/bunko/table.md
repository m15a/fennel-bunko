# Table.fnl

**Table of contents**

- [`copy`](#copy)
- [`flatten`](#flatten)
- [`insert`](#insert)
- [`keys`](#keys)
- [`merge`](#merge)
- [`sort`](#sort)
- [`update`](#update)
- [`values`](#values)

## `copy`
Function signature:

```
(copy table ?metatable)
```

Return a shallow copy of the `table`.

Optionally, if `?metatable` is truthy, set the same metatable as the original's.

## `flatten`
Function signature:

```
(flatten & tables)
```

Concatenate all the given sequential `tables`.

## `insert`
Function signature:

```
(insert table & rest-args)
```

Do `table.insert` and return the updated `table`.

The `rest-args` are passed to `table.insert`.

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

Return `nil` for no arguments.

## `sort`
Function signature:

```
(sort table & rest-args)
```

Do `table.sort` and return the sorted `table`.

The `rest-args` are passed to `table.sort`.

## `update`
Function signature:

```
(update table key value)
```

Do `tset` using `key` and `value`, and return the updated `table`.

## `values`
Function signature:

```
(values table)
```

Return all values in the `table`.


<!-- Generated with Fenneldoc 1.0.1-dev
     https://gitlab.com/andreyorst/fenneldoc -->
