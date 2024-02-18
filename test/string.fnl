(local t (require :faith))
(local bs (require :bunko.string))

(fn test-escape []
  (t.= "%^%$%(%)%%%.%[%]%*%+%-%?" (bs.escape "^$()%.[]*+-?")))

{: test-escape}
