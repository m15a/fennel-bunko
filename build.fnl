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

(macro shell-task [command help shell]
  "Define simple shell task to run."
  `(task ,command []
     ,help
     (io.stderr:write (.. "Run " ,shell "\n"))
     (let [(_# _# signal#) (os.execute ,shell)]
       (os.exit signal#))))

(fn find-test-modules []
  (with-open [in (io.popen "ls test/*.fnl")]
    (let [modules []]
      (each [line (in:lines)]
        (let [module (-> line
                         (: :gsub "/" ".")
                         (: :gsub "%.fnl$" ""))]
          (table.insert modules module)))
      modules)))

(shell-task :test
  "Run tests."
  (let [test-modules (find-test-modules)]
    (.. "faith --fennel-version && faith --tests " (table.concat test-modules " "))))

(shell-task :fmt
  "Format sources."
  "fnlfmt --indent-do-as-if --fix bunko/*.fnl test/*.fnl")

(shell-task :fmt-check
  "Check if all sources are formatted."
  "fnlfmt --indent-do-as-if --check bunko/*.fnl test/*.fnl")

(shell-task :docs
  "Build API documents from sources."
  "rm -rf doc/ && fenneldoc bunko/*.fnl")

(fn main []
  (let [command (. arg 1)
        rest (do (table.remove arg 1) arg)]
    (match command
      :test (commands.test)
      :fmt (commands.fmt)
      :fmt-check (commands.fmt-check)
      :docs (commands.docs)
      _ (usage "<command> [<arg> ...]" "Commands:"
               (unpack (icollect [command _ (pairs commands)]
                         (.. "\t" command "\t" (. helps command))))))))

(main)
