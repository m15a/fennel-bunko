#!/usr/bin/env fennel

(local unpack (or table.unpack _G.unpack))
(import-macros {: map-values} :bunko)
(local {: keys} (require :bunko.table))
(local {: read-lines} (require :bunko.file))

(fn usage [script-name synopsis ...]
  "Print usage information."
  (let [out io.stderr]
    (-> [(string.format "Usage: %s %s" script-name synopsis) ...]
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
  `(task ,command [] ,help (io.stderr:write (.. "Run " ,shell "\n"))
         (let [(_# _# signal#) (os.execute ,shell)]
           (os.exit signal#))))

(fn find-test-modules []
  (with-open [in (assert (io.popen "ls test/*.fnl"))]
    (icollect [_ line (ipairs (read-lines in))]
      (-> line
          (: :gsub "/" ".")
          (: :gsub "%.fnl$" "")))))

(shell-task :test
  "Run tests."
  (let [test-modules (find-test-modules)]
    (.. "faith --fennel-version && faith --tests "
        (table.concat test-modules " "))))

(shell-task :format
  "Format sources."
  "fnlfmt --fix bunko/*.fnl test/*.fnl")

(shell-task :check-format
  "Check if all sources are formatted."
  "fnlfmt --check bunko/*.fnl test/*.fnl")

(shell-task :docs
  "Build API documents from sources."
  "rm -rf doc/ && fenneldoc bunko/*.fnl")

(let [script-name (. arg 0)
      [command & rest] arg]
  (match command
    :test (commands.test)
    :format (commands.format)
    :check-format (commands.check-format)
    :docs (commands.docs)
    _ (usage script-name "COMMAND ARG...\n" "Commands:"
             (map-values #(.. "  " $ "\t" (. helps $))
                         (unpack (doto (keys commands)
                                       (table.sort)))))))
