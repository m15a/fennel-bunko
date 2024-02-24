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

- **Utilities, not extensions**: Bunko sticks with the basic language
  conception of Fennel or Lua, and limits itself to tools and utilities
  that fit well within the framework of Fennel. Bunko will not contain
  any extra features such as extended module systems, lazy sequence
  libraries, test frameworks ,etc.
- **Non-opinionated**: Bunko respects Fennel's or Lua's programming
  conventions. Bunko does not include any opinionated/specialized
  *languages*, e.g., anaphoric macros, and will try to be obvious and
  clear in the eyes of Fennel programmers.
- **Portable**: Bunko works with any Lua version/implementation which
  Fennel supports.

## Requirements

- Fennel: 1.4.1+
- Lua: PUC Lua 5.1–5.4, or LuaJIT

## API documentation

Read the Markdown files in the [`doc`](./doc) directory.

## License

[The Unlicense](LICENSE)

[1]: https://alexandria.common-lisp.dev/
[2]: https://en.wiktionary.org/wiki/%E6%96%87%E5%BA%AB
