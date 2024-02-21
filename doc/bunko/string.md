# String.fnl

**Table of contents**

- [`escape`](#escape)

## `escape`
Function signature:

```
(escape string)
```

Escape magic characters of [patterns][1] in the `string`.

Namely, `^$()%.[]*+-?`.

[1]: https://www.lua.org/manual/5.4/manual.html#6.4.1

### Examples

```fennel
(escape "%") ;=> "%%"
```


<!-- Generated with Fenneldoc 1.0.1-dev-7960056
     https://gitlab.com/andreyorst/fenneldoc -->
