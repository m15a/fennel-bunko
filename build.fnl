#!/usr/bin/env fennel

(local unpack (or table.unpack _G.pack))

(fn usage [synopsis description ...]
  "Print usage information."
  (let [script-name (. arg 0)
        out io.stderr]
    (-> [(string.format "Usage: %s %s" script-name synopsis) description ...]
        (#(table.concat $ "\n"))
        (out:write))
    (out:write "\n"))
  (os.exit 1))

(local commands {})
(local helps {})

(set helps.fmt "Format sources.")
(fn commands.fmt []
  (let [out io.stderr
        cmd "fnlfmt --indent-do-as-if --fix bunko/*.fnl"]
    (out:write (.. "Run " cmd "\n"))
    (os.execute cmd)))

(set helps.docs "Build API documents from sources.")
(fn commands.docs []
  (let [out io.stderr
        cmd "fenneldoc bunko/*.fnl"]
    (out:write (.. "Run " cmd "\n"))
    (os.execute cmd)))

(fn main []
  (let [command (. arg 1)
        rest (do (table.remove arg 1) arg)]
    (match command
      :fmt (commands.fmt)
      :docs (commands.docs)
      _ (usage "<command> [<arg> ...]" "Commands:"
               (unpack (icollect [command _ (pairs commands)]
                         (.. "\t" command "\t" (. helps command))))))))

(main)
