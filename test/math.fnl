(local t (require :faith))
(local bm (require :bunko.math))

(fn test-mean []
  (let [m (bm.mean [1 2 3 4])]
    (t.almost= 2.5 m 1e-06))
  (let [m (bm.mean [])]
    (t.= nil m)))

(fn test-variance []
  (let [m (bm.variance [1 2 3 4])]
    (t.almost= 1.66666667 m 1e-06))
  (let [m (bm.variance [])]
    (t.= nil m))
  (let [m (bm.variance [1])]
    (t.= nil m)))

{: test-mean : test-variance}
