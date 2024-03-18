# Math.fnl (1.0.0)

Mathematical and statistical functions.

**Table of contents**

- Function: [`mean`](#function-mean)
- Function: [`variance`](#function-variance)
- Function: [`standard-deviation`](#function-standard-deviation)
- Function: [`standard-error`](#function-standard-error)
- Function: [`median`](#function-median)

## Function: `mean`

```
(mean sample)
```

Return the `sample` mean.

`sample` should be a sequential table of numbers, containing at least one.
Otherwise, it returns `nil`.

## Function: `variance`

```
(variance sample)
```

Return the unbiased `sample` variance.

`sample` should be a sequential table of numbers, containing at least two.
Otherwise, it returns `nil`.

## Function: `standard-deviation`

```
(standard-deviation sample)
```

Return the `sample` standard deviation.

This is just the square root of unbiased sample variance.
`sample` should be a sequential table of numbers, containing at least two.
Otherwise, it returns `nil`.

## Function: `standard-error`

```
(standard-error sample)
```

Return the `sample` standard error.

`sample` should be a sequential table of numbers, containing at least two.
Otherwise, it returns `nil`.

## Function: `median`

```
(median sample)
```

Return the `sample` median.

`sample` should be a sequential table of numbers, containing at least one.
Otherwise, it returns `nil`.

---

License: Unlicense

<!-- Generated with Fnldoc 1.1.0-dev-66c2ee5
     https://sr.ht/~m15a/fnldoc/ -->
