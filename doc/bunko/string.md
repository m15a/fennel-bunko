# String.fnl

**Table of contents**

- [`escape-regex`](#escape-regex)

## `escape-regex`
Function signature:

```
(escape-regex string)
```

Escape magic characters of [patterns][1] in the `string`.

Namely, `^$()%.[]*+-?`.

[1]: https://www.lua.org/manual/5.4/manual.html#6.4.1

### Examples

```fennel
(escape-regex "%") ;=> "%%"
```


<!-- Generated with Fenneldoc 1.0.1-dev-7960056
     https://gitlab.com/andreyorst/fenneldoc -->
