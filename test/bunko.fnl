(local t (require :faith))
(local b (require :bunko))

(fn test-assert-type []
  (let [x {:a 1}
        x_ (b.assert-type :table x)]
    (t.= x x_))
  (let [y :bee]
    (t.error "number expected, got \"bee\""
             #(b.assert-type :number y))))

(fn test-assert-type-checks-nil []
  (t.error "number expected, got nil"
           #(b.assert-type :number nil)))

(fn test-assert-type-evaluates-target-only-once []
  (let [x []
        y []
        x_1 (b.assert-type :table
                            (do
                              (table.insert y 1)
                              x))]
    (t.= x x_1)
    (t.= [1] y)))

(fn test-equal? []
  (let [x 1
        y 1
        z 1]
    (t.= true (b.equal? x y z)))
  (let [x 1
        y 2
        z 1]
    (t.= false (b.equal? x y z)))
  (let [x :x
        y :x
        z :x]
    (t.= true (b.equal? x y z)))
  (let [x :x
        y :y
        z :z]
    (t.= false (b.equal? x y z)))
  (let [x {:x {:x :x}}
        y {:x {:x :x}}
        z {:x {:x :x}}]
    (t.= true (b.equal? x y z)))
  (let [x {:x {:x :x}}
        y {:x {:x :x}}
        z {:x {:x :x :y :y}}]
    (t.= false (b.equal? x y z))))

{: test-assert-type
 : test-assert-type-checks-nil
 : test-assert-type-evaluates-target-only-once
 : test-equal?}
