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
(import-macros {: immutably} :bunko)

(macro sample-has? [n sample]
  "Check if the `sample` has at least `n` examples."
  (let [checks (fcollect [i 1 n]
                 `(next ,sample ,(when (< 1 i) (- i 1))))]
    `(and ,(unpack checks))))

(fn mean [sample]
  "Return the `sample` mean.

`sample` should be a sequential table of numbers, containing at least one.
Otherwise, it returns `nil`."
  (when (sample-has? 1 sample)
    (accumulate [mu 0 i x (ipairs sample)]
      (let [alpha (/ 1 i)]
        (+ (* (- 1 alpha) mu) (* alpha x))))))

(fn variance [sample]
  "Return the unbiased `sample` variance.

`sample` should be a sequential table of numbers, containing at least two.
Otherwise, it returns `nil`."
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
  "Return the `sample` standard deviation.

This is just the square root of unbiased sample variance.
`sample` should be a sequential table of numbers, containing at least two.
Otherwise, it returns `nil`."
  (case (variance sample)
    v (math.sqrt v)))

(fn standard-error [sample]
  "Return the `sample` standard error.

`sample` should be a sequential table of numbers, containing at least two.
Otherwise, it returns `nil`."
  (case (variance sample)
    v (let [n (length sample)]
        (math.sqrt (/ v n)))))

(fn median [sample]
  "Return the `sample` median.

`sample` should be a sequential table of numbers, containing at least one.
Otherwise, it returns `nil`."
  (when (sample-has? 1 sample)
    (let [sorted (immutably table.sort sample)
          n (length sample)]
      (if (= 1 (% n 2))
          (. sorted (/ (+ n 1) 2))
          (/ (+ (. sorted (/ n 2)) (. sorted (+ 1 (/ n 2)))) 2)))))

{: mean : variance : standard-deviation : standard-error : median}
