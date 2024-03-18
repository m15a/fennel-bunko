# String.fnl (1.0.0)

Utilities for string manipulation.

**Table of contents**

- Function: [`escape-regex`](#function-escape-regex)

## Function: `escape-regex`

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

<!-- Generated with Fnldoc 1.1.0-dev-66c2ee5
     https://sr.ht/~m15a/fnldoc/ -->
