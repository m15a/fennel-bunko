(local t (require :faith))
(local bs (require :bunko.set))

(fn test-subset? []
  (let [a {}
        b {:a true}
        c {:a b :b a}]
    (t.= true (bs.subset? a a))
    (t.= true (bs.subset? a b))
    (t.= true (bs.subset? b c))
    (t.= false (bs.subset? c b))))

(fn test-union! []
  (let [a {:a 1}
        b {:b :b}
        c {:a :c :c {}}]
    (t.= nil (bs.union! a b c))
    (t.= a {:a :c :b :b :c {}})
    (t.= b {:b :b})
    (t.= c {:a :c :c {}})))

(fn test-intersection! []
  (let [a {:a 1}
        b {:a true :b false}
        c {:a :c :c {}}]
    (t.= nil (bs.intersection! c b a))
    (t.= a {:a 1})
    (t.= b {:a true :b false})
    (t.= c {:a :c})
    (t.= (doto {:a :a :b :b}
           (bs.intersection! {:a 1} {:a true :c {}}))
         (doto {:a :a :b :b}
           (bs.intersection! (doto {:a 1}
                               (bs.union! {:a true :c {}})))))))

(fn test-difference! []
  (let [a {:a 1}
        b {:a true :b false}
        c {:a :c :c {}}]
    (t.= nil (bs.difference! b a c))
    (t.= a {:a 1})
    (t.= b {:b false})
    (t.= c {:a :c :c {}})
    (t.= (doto {:a :a :b :b}
           (bs.difference! {:a 1} {:a true :c {}}))
         (doto {:a :a :b :b}
           (bs.difference! (doto {:a 1}
                             (bs.union! {:a true :c {}})))))))

(fn every? [pred? xs]
  (accumulate [yes true _ x (ipairs xs) &until (not yes)]
    (if (pred? x) yes false)))

(fn some? [pred? xs]
  (accumulate [yes false _ x (ipairs xs) &until yes]
    (if (pred? x) true yes)))

(fn set= [x y]
  (and (accumulate [yes true k _ (pairs x) &until (not yes)] (. y k))
       (accumulate [yes true k _ (pairs y) &until (not yes)] (. x k))))

(fn member? [e xs]
  (some? (partial set= e) xs))

(fn test-powerset []
  (let [x {:a :yes :b :no :c 1}
        actual (bs.powerset x)
        expected [{}
                  {:a :yes}
                  {:b :no}
                  {:c 1}
                  {:a :yes :b :no}
                  {:b :no :c 1}
                  {:c 1 :a :yes}
                  {:a :yes :b :no :c 1}]]
    (t.is (and (every? #(member? $ actual) expected)
               (every? #(member? $ expected) actual)))))

{: test-subset?
 : test-union!
 : test-intersection!
 : test-difference!
 : test-powerset}
