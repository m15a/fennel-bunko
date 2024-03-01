# Math.fnl (1.0.0)
Mathematical and statistical functions.

**Table of contents**

- [`mean`](#mean)
- [`variance`](#variance)
- [`standard-deviation`](#standard-deviation)
- [`standard-error`](#standard-error)
- [`median`](#median)

## `mean`
Function signature:

```
(mean sample)
```

Return the `sample` mean.

`sample` should be a sequential table of numbers, containing at least one.
Otherwise, it returns `nil`.

## `variance`
Function signature:

```
(variance sample)
```

Return the unbiased `sample` variance.

`sample` should be a sequential table of numbers, containing at least two.
Otherwise, it returns `nil`.

## `standard-deviation`
Function signature:

```
(standard-deviation sample)
```

Return the `sample` standard deviation.

This is just the square root of unbiased sample variance.
`sample` should be a sequential table of numbers, containing at least two.
Otherwise, it returns `nil`.

## `standard-error`
Function signature:

```
(standard-error sample)
```

Return the `sample` standard error.

`sample` should be a sequential table of numbers, containing at least two.
Otherwise, it returns `nil`.

## `median`
Function signature:

```
(median sample)
```

Return the `sample` median.

`sample` should be a sequential table of numbers, containing at least one.
Otherwise, it returns `nil`.


---

License: Unlicense


<!-- Generated with Fenneldoc 1.0.1-dev-7960056
     https://gitlab.com/andreyorst/fenneldoc -->
