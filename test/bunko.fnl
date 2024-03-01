(local t (require :faith))
(local b (require :bunko))

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

{: test-equal?}
