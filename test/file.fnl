(local t (require :faith))
(local bf (require :bunko.file))

(fn test-exists? []
  (t.= true (bf.exists? :./README.md))
  (t.= false (bf.exists? :./OBAKE.md)))

(fn test-normalize []
  (let [(x y) (bf.normalize ://a/b :a//b/)]
    (t.= :/a/b x)
    (t.= :a/b/ y)))

(fn test-remove-suffix []
  (t.= :/a/b (bf.remove-suffix :/a/b.ext :.ext))
  (t.= :/a/b/.ext (bf.remove-suffix :/a/b/.ext :.ext)))

(fn test-basename []
  (t.= "/" (bf.basename "/"))
  (t.= :b (bf.basename :/a/b))
  (t.= :b (bf.basename :a/b/))
  (t.= "" (bf.basename ""))
  (t.= "." (bf.basename "."))
  (t.= ".." (bf.basename ".."))
  (t.= :b (bf.basename :/a/b.ext :.ext))
  (t.= :b (bf.basename :/a/b.ext/ :.ext))
  (t.= :.ext (bf.basename :/a/b/.ext :.ext)))

(fn test-dirname []
  (t.= "/" (bf.dirname "/"))
  (let [(x y) (bf.dirname :/a/b :/a/b/)]
    (t.= :/a x)
    (t.= :/a y))
  (let [(x y) (bf.dirname :a/b :a/b/)]
    (t.= :a x)
    (t.= :a y))
  (let [(x y) (bf.dirname :a :a/)]
    (t.= "." x)
    (t.= "." y))
  (let [(x y z) (bf.dirname "" "." "..")]
    (t.= "." x)
    (t.= "." y)
    (t.= "." z)))

(fn test-read-file []
  (t.= "he\nllo\n" (bf.read-file :./_assets/hello.txt))
  (t.= nil (bf.read-file :./_assets/none.txt)))

(fn test-read-lines []
  (t.= [:he :llo] (bf.read-lines :./_assets/hello.txt))
  (t.= nil (bf.read-file :./_assets/none.txt)))

{: test-exists?
 : test-normalize
 : test-remove-suffix
 : test-basename
 : test-dirname
 : test-read-file
 : test-read-lines}
