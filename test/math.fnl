(local t (require :faith))
(local bm (require :bunko.math))

(fn test-mean []
  (let [m (bm.mean [1 2 3 4])]
    (t.almost= 2.5 m 1e-06))
  (let [m (bm.mean [])]
    (t.= nil m)))

{: test-mean}
