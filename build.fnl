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
  (os.exit false))

(local commands {})
(local helps {})

(macro task [command args help & body]
  "Define task to run."
  `(do (tset helps ,command ,help)
       (tset commands ,command (fn ,args ,(unpack body)))))

(task :fmt []
  "Format sources."
  (let [out io.stderr
        cmd "fnlfmt --indent-do-as-if --fix bunko/*.fnl"]
    (out:write (.. "Run " cmd "\n"))
    (os.execute cmd)))

(task :fmt-check []
  "Check if all sources are formatted."
  (let [out io.stderr
        cmd "fnlfmt --indent-do-as-if --check bunko/*.fnl"]
    (out:write (.. "Run " cmd "\n"))
    (let [(_ _ signal) (os.execute cmd)]
      (os.exit signal))))

(task :docs []
  "Build API documents from sources."
  (let [out io.stderr
        cmd "fenneldoc bunko/*.fnl"]
    (out:write (.. "Run " cmd "\n"))
    (os.execute cmd)))

(fn main []
  (let [command (. arg 1)
        rest (do (table.remove arg 1) arg)]
    (match command
      :fmt (commands.fmt)
      :fmt-check (commands.fmt-check)
      :docs (commands.docs)
      _ (usage "<command> [<arg> ...]" "Commands:"
               (unpack (icollect [command _ (pairs commands)]
                         (.. "\t" command "\t" (. helps command))))))))

(main)
