(local t (require :faith))
(local bs (require :bunko.string))

(fn test-escape-regex []
  (t.= "%^%$%(%)%%%.%[%]%*%+%-%?" (bs.escape-regex "^$()%.[]*+-?")))

{: test-escape-regex}
