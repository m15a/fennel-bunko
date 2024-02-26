;;;; =========================================================================
;;;; Mathematical and statistical functions.
;;;; =========================================================================
;;;; 
;;;; URL: https://github.com/m15a/fennel-bunko
;;;; License: Unlicense
;;;; 
;;;; This is free and unencumbered software released into the public domain.
;;;; 
;;;; Anyone is free to copy, modify, publish, use, compile, sell, or
;;;; distribute this software, either in source code form or as a compiled
;;;; binary, for any purpose, commercial or non-commercial, and by any
;;;; means.
;;;; 
;;;; In jurisdictions that recognize copyright laws, the author or authors
;;;; of this software dedicate any and all copyright interest in the
;;;; software to the public domain. We make this dedication for the benefit
;;;; of the public at large and to the detriment of our heirs and
;;;; successors. We intend this dedication to be an overt act of
;;;; relinquishment in perpetuity of all present and future rights to this
;;;; software under copyright law.
;;;; 
;;;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;;;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;;;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
;;;; IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
;;;; OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
;;;; ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
;;;; OTHER DEALINGS IN THE SOFTWARE.
;;;; 
;;;; For more information, please refer to <https://unlicense.org>

(local unpack (or table.unpack _G.unpack))

(macro sample-has? [n sample]
  "Check if the `sample` has at least `n` examples."
  (let [checks (fcollect [i 1 n]
                 `(next ,sample ,(when (< 1 i) (- i 1))))]
    `(and ,(unpack checks))))

(fn mean [sample]
  "Return the mean of numbers in a sequential `table`."
  {:fnl/arglist [table]}
  (when (sample-has? 1 sample)
    (accumulate [mu 0 i x (ipairs sample)]
      (let [alpha (/ 1 i)]
        (+ (* (- 1 alpha) mu) (* alpha x))))))

(fn variance [sample]
  "Return the unbiased variance of numbers in a sequential `table`."
  {:fnl/arglist [table]}
  (when (sample-has? 2 sample)
    (let [mu (accumulate [mu (doto [0 0] (tset 0 0)) i x (ipairs sample)]
               (let [alpha (/ 1 i)
                     mu0 (+ 1 (. mu 0))
                     mu1 (+ (* (- 1 alpha) (. mu 1)) (* alpha x))
                     mu2 (+ (* (- 1 alpha) (. mu 2)) (* alpha (^ x 2)))]
                 (doto [mu1 mu2] (tset 0 mu0))))
          n (. mu 0)
          sigma2 (- (. mu 2) (^ (. mu 1) 2))]
      (* (/ n (- n 1)) sigma2))))

(fn standard-deviation [sample]
  "Return the standard deviation of numbers in a sequential `table`."
  {:fnl/arglist [table]}
  (case (variance sample)
    v (math.sqrt v)))

{: mean : variance : standard-deviation}
