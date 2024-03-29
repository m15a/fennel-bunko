(local t (require :faith))
(local bm (require :bunko.math))

(fn test-mean []
  (let [m (bm.mean [1 2 3 4])]
    (t.almost= 2.5 m 1e-06))
  (let [m (bm.mean [])]
    (t.= nil m)))

(fn test-variance []
  (let [v (bm.variance [1 2 3 4])]
    (t.almost= 1.66666667 v 1e-06))
  (let [v (bm.variance [])]
    (t.= nil v))
  (let [v (bm.variance [1])]
    (t.= nil v)))

(fn test-standard-deviation []
  (let [s (bm.standard-deviation [1 2 3 4])]
    (t.almost= 1.290994 s 1e-06))
  (let [s (bm.standard-deviation [])]
    (t.= nil s))
  (let [s (bm.standard-deviation [1])]
    (t.= nil s)))

(fn test-standard-error []
  (let [e (bm.standard-error [1 2 3 4 3 3 5 7])]
    (t.almost= 0.6546537 e 1e-06))
  (let [e (bm.standard-error [])]
    (t.= nil e))
  (let [e (bm.standard-error [1])]
    (t.= nil e)))

(fn test-median []
  (let [m (bm.median [1 2 3 4])]
    (t.almost= 2.5 m 1e-06))
  (let [m (bm.median [2 3 4])]
    (t.almost= 3 m 1e-06))
  (let [m (bm.median [10])]
    (t.= 10 m))
  (let [m (bm.median [])]
    (t.= nil m)))

{: test-mean
 : test-variance
 : test-standard-deviation
 : test-standard-error
 : test-median}
