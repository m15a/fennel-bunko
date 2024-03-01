(local t (require :faith))
(local bs (require :bunko.set))

(fn test-subset? []
  (let [a {}
        b {:a true}
        c {:a false :b a}]
    (t.= true (bs.subset? a a))
    (t.= true (bs.subset? a b))
    (t.= true (bs.subset? a c))
    (t.= false (bs.subset? b a))
    (t.= true (bs.subset? b b))
    (t.= true (bs.subset? b c))
    (t.= false (bs.subset? c a))
    (t.= false (bs.subset? c b))
    (t.= true (bs.subset? c c))))

(fn test-set= []
  (let [a {}
        a* {}
        b {:a true}
        b* {:a false}
        c {:a b :b a}
        c* {:a b :b a*}
        c** {:a b :b a*}]
    (t.= true (bs.set= a a*))
    (t.= true (bs.set= b b*))
    (t.= true (bs.set= c c* c**))
    (t.= false (bs.set= a b c))))

(fn test-union! []
  (let [a {:a 1}
        b {:b :b}
        c {:a false :c {}}]
    (t.= nil (bs.union! a b c))
    (t.= {:a false :b :b :c {}} a)
    (t.= {:b :b} b)
    (t.= {:a false :c {}} c)))

(fn test-intersection! []
  (let [a {:a 1}
        b {:a true :c false}
        c {:a :c :b 1 :c {}}]
    (t.= nil (bs.intersection! c b a))
    (t.= {:a 1} a)
    (t.= {:a true :c false} b)
    (t.= {:a :c} c)
    (t.= (doto {:a :a :b :b}
           (bs.intersection! {:a 1} {:c {}}))
         (doto {:a :a :b :b}
           (bs.intersection! (doto {:a false}
                               (bs.intersection! {:c 1})))))))

(fn test-difference! []
  (let [a {:a 1}
        b {:a true :b false}
        c {:a :c :c {}}]
    (t.= nil (bs.difference! b a c))
    (t.= {:a 1} a)
    (t.= {:b false} b)
    (t.= {:a :c :c {}} c)
    (t.= (doto {:a :a :b :b}
           (bs.difference! {:a 1} {:c {}}))
         (doto {:a :a :b :b}
           (bs.difference! (doto {:a 1}
                             (bs.union! {:c {}})))))))

(fn every? [pred? xs]
  (accumulate [yes true _ x (ipairs xs) &until (not yes)]
    (if (pred? x) yes false)))

(fn some? [pred? xs]
  (accumulate [yes false _ x (ipairs xs) &until yes]
    (if (pred? x) true yes)))

(fn set= [x y]
  (and (accumulate [yes true k _ (pairs x) &until (not yes)] (not= nil (. y k)))
       (accumulate [yes true k _ (pairs y) &until (not yes)] (not= nil (. x k)))))

(fn member? [e xs]
  (some? (partial set= e) xs))

(fn test-powerset []
  (let [x {:a :yes :b false :c 1}
        actual (bs.powerset x)
        expected [{}
                  {:a :yes}
                  {:b false}
                  {:c 1}
                  {:a :yes :b false}
                  {:b false :c 1}
                  {:c 1 :a :yes}
                  {:a :yes :b false :c 1}]]
    (t.is (and (every? #(member? $ actual) expected)
               (every? #(member? $ expected) actual)))))

{: test-subset?
 : test-set=
 : test-union!
 : test-intersection!
 : test-difference!
 : test-powerset}
