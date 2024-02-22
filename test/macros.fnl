(local t (require :faith))
(import-macros {: assert-type : map-values : unless : immutably} :bunko.macros)

(fn test-assert-type []
  (let [x {:a 1}
        y {:b 2}
        (x_ y_) (assert-type :table x y)]
    (t.= x x_)
    (t.= y y_))
  (let [a 1
        b :bee
        c {:c true}]
    (t.error "number expected, got string" #(assert-type :number a b c))))

(fn test-map-values []
  (let [(x y z) (map-values #(+ 1 $) 1 2 3)]
    (t.is (and (= x 2) (= y 3) (= z 4)))))

(fn test-unless []
  (var x :a)
  (unless true (set x :b))
  (t.= x :a)
  (unless false (set x :b))
  (t.= x :b))

(fn test-immutably []
  (let [x {:a 1}]
    (t.= {:a 2} (immutably tset x :a 2))
    (t.= {:a 1} x))
  (let [x [1]]
    (t.= [1 2] (immutably table.insert x 2))
    (t.= [1] x)))

{: test-assert-type : test-map-values : test-unless : test-immutably}
