# String.fnl (0.1.0)
Utilities for string manipulation.

**Table of contents**

- [`escape-regex`](#escape-regex)

## `escape-regex`
Function signature:

```
(escape-regex string)
```

Escape magic characters of Lua regex pattern in the `string`.

Return the escaped string.
The magic characters are namely `^$()%.[]*+-?`.
See the [Lua manual][1] for more detail.

[1]: https://www.lua.org/manual/5.4/manual.html#6.4.1

### Examples

```fennel
(let [original ".fnl$"
      escaped (escape-regex original)]
  (assert (= escaped "%.fnl%$")))
```


---

License: Unlicense


<!-- Generated with Fenneldoc 1.0.1-dev-7960056
     https://gitlab.com/andreyorst/fenneldoc -->
