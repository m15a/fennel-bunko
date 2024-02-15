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
(copy tbl ?metatable)
```

Return a shallow copy of the table.

Optionally set the same metatable as the original's.

## `flatten`
Function signature:

```
(flatten ...)
```

Concatenate all the given sequential tables.

## `insert`
Function signature:

```
(insert seq ...)
```

Do `table.insert` and return the updated table.

The rest args are passed to `table.insert`.

## `keys`
Function signature:

```
(keys tbl)
```

Return all keys in the table.

## `merge`
Function signature:

```
(merge ...)
```

Merge all the given non-sequential tables.

Return `nil` for no arguments.

## `sort`
Function signature:

```
(sort seq ...)
```

Do `table.sort` and return the sorted table.

The rest args are passed to `table.sort`.

## `update`
Function signature:

```
(update tbl key value)
```

Do `tset` and return the updated table.

## `values`
Function signature:

```
(values tbl)
```

Return all values in the table.


<!-- Generated with Fenneldoc 1.0.1
     https://gitlab.com/andreyorst/fenneldoc -->
