# fennel-bunko

[![ci][b1]][b2]
[![fennel][b3]][b4]

[b1]: https://github.com/m15a/fennel-bunko/actions/workflows/ci.yml/badge.svg
[b2]: https://github.com/m15a/fennel-bunko/actions/workflows/ci.yml
[b3]: https://img.shields.io/badge/Fennel-v1.4.1+-fff3d7.svg?style=flat-square
[b4]: https://fennel-lang.org/

![hondana](_assets/tosyokan_book_tana.png)

Fennel library of miscellaneous utilities, far from [Alexandria][1].

([Bunko][2] means a collection of books in Japanese.)

## Philosophy

Mostly following Alexandria's philosophy, this library aims to be:

- **Utilities, not extensions**: Bunko sticks with Fennel's or Lua's basic language
  conception. Bunko does not provide any extension such as macros for module system.
- **Non-opinionated**: Bunko follows Fennel's or Lua's conventional way. Bunko does
  not include any opinionated/specialized *languages* such as anaphoric macros.
- **Portable**: Bunko works with any Lua version/implementation which Fennel supports.

## Requirements

- Fennel: 1.4.1+
- Lua: PUC Lua 5.1–5.4, or LuaJIT

## License

[The Unlicense](LICENSE)

[1]: https://alexandria.common-lisp.dev/
[2]: https://en.wiktionary.org/wiki/%E6%96%87%E5%BA%AB
