(load "../common/utils.scm")

(out
  486
  (+ 123 456)
  ; 579
  (- 1000 334)
  ; 666
  (+ (* 3 5) (- 10 6)) ; 3*5 + (10-6)
  ; 19
  )

(out ; B + C = 57 
  (+ (* 3 ; 3*A = C = 48
        (+ (* 2 4) ; (2*4) + (3+5) = A = 16
           (+ 3 5)))
     (+ (- 10 7) ; (10-7) + 6 = B = 9
        6)))
