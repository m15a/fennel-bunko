(local t (require :faith))
(local {: map-values} (require :bunko.values))

(fn test-map-values []
  (let [(x y z) (map-values #(+ 1 $) 1 2 3)]
    (t.is (and (= x 2) (= y 3) (= z 4))))
  (let [x (map-values #(+ 1 $))]
    (t.= x nil)))

{: test-map-values}
