(local t (require :faith))
(import-macros b :bunko.macros)

(fn test-tset []
  (t.= {:a {:b :no}} (let [tbl {:a {:b :yes}}]
                       (b.tset tbl :a :b :no))))

{: test-tset}
