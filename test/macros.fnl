(local t (require :faith))
(import-macros {: map-values : tset+} :bunko.macros)

(fn test-map-values []
  (let [(x y z) (map-values #(+ 1 $) 1 2 3)]
    (t.is (and (= x 2) (= y 3) (= z 4)))))

(fn test-tset+ []
  (t.= {:a {:b :no}} (let [tbl {:a {:b :yes}}]
                       (tset+ tbl :a :b :no))))

{: test-map-values : test-tset+}
