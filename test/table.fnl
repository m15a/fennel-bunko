(local t (require :faith))
(local bt (require :bunko.table))

(fn test-copy-non-table []
  (t.error "table expected" #(bt.copy nil)))

(fn test-copy-simple-table []
  (let [origin {:a :a}
        clone (bt.copy origin)]
    (tset origin :a :b)
    (t.is (and (= :b (. origin :a)) (= :a (. clone :a))))))

(fn test-copy-deep-table []
  (let [origin {:a {:b :c}}
        clone (bt.copy origin)]
    (tset clone :a :b :d)
    (t.= origin clone)))

(fn test-copy-table-with-metatable []
  (let [origin (setmetatable {} {:meta true})
        clone (bt.copy origin true)]
    (t.is (. (getmetatable clone) :meta))))

(fn test-keys []
  (let [tbl {:a 1 :b 2}]
    (t.= [:a :b] (doto (bt.keys tbl) (table.sort)))))

(fn test-items []
  (let [tbl {:a 1 :b 2}]
    (t.= [1 2] (doto (bt.items tbl) (table.sort)))))

(fn test-update! []
  (let [x {:a 1}]
    (bt.update! x :b #(+ 1 $) 0)
    (t.= x {:a 1 :b 1}))
  (t.= nil (bt.update! {} :a #$ :a)))

(fn test-merge! []
  (t.= {:a 2 :b 2} (doto {:a 1} (bt.merge! {:a 2} {:b 2})))
  (t.error "table expected" #(bt.merge!)))

(fn test-append! []
  (t.= [1 2 3 4] (doto [1] (bt.append! [2 3] [4])))
  (t.error "table expected" #(bt.append!)))

{: test-copy-non-table
 : test-copy-simple-table
 : test-copy-deep-table
 : test-copy-table-with-metatable
 : test-keys
 : test-items
 : test-update!
 : test-merge!
 : test-append!}
