(load "../common/utils.scm")
(load "../common/test-utils.scm")

(load "./exercise_2_97_setup.scm")

(out "#1 reduction demo")
(let* ((t1 (make-tl-from-cseq-num
             'poly-termlist-sparse
             1 2 3))
       (t2 (make-tl-from-cseq-num
             'poly-termlist-sparse
             1 -1))
       (t3 (make-tl-from-cseq-num
             'poly-termlist-sparse
             2 -3 5 -7))
       (t4 (make-tl-from-cseq-num
             'poly-termlist-sparse
             8 -6 4 -2 0))
       (t5 (mul t1 (mul t2 t3)))
       (t6 (mul t1 (mul t2 t4))))
  (define to-poly ((curry2 make-poly) 'x))
  (define out-poly (compose out to-string))
  (let* ((p1 (to-poly t5))
         (p2 (to-poly t6))
         (reduce-result (reduce p1 p2))
         (pp1 (car reduce-result))
         (pp2 (cadr reduce-result)))
    (out "p1")
    (out-poly p1)
    (out "p2")
    (out-poly p2)
    (out "reduced p1")
    (out-poly pp1)
    (out "reduced p2")
    (out-poly pp2)))

(newline)
(out "#2 generic make-rational demo")
(let ((a (make-rational-g 10 20))
      (b (make-rational-g
           (make-poly
             'x
             (make-tl-from-cseq-num 
               'poly-termlist-sparse
               1 2 1))
           (make-poly
             'x
             (make-tl-from-cseq-num
               'poly-termlist-sparse
               1 1)))))
  ; generic make-rational works
  ;   for both integers and polynomials
  (out (to-string a))
  (out (to-string b)))

(newline)
(out "#3 final test")
(let ()
  (define  p1 (make-polynomial 'x '((1 1) (0  1))))
  (define  p2 (make-polynomial 'x '((3 1) (0 -1))))
  (define  p3 (make-polynomial 'x '((1 1))))
  (define  p4 (make-polynomial 'x '((2 1) (0 -1))))
  (define rf1 (make-rational-g p1 p2))
  (define rf2 (make-rational-g p3 p4))

  (define result (add rf1 rf2))
  (define wanted (make-rational-g
                   (make-poly
                     'x
                     (make-tl-from-cseq-num
                       'poly-termlist-sparse
                       1 2 3 1))
                   (make-poly
                     'x
                     (make-tl-from-cseq-num
                       'poly-termlist-sparse
                       1 1 0 -1 -1))))
  ; wanted:
  ;         1 x^3 + 2 x^2 + 3 x^1 + 1 x^0
  ; -------------------------------------
  ; 1 x^4 + 1 x^3 + 0 x^2 - 1 x^1 - 1 x^0
  (out "rf1" (to-string rf1))
  (out "rf2" (to-string rf2))
  (out "result" (to-string result))
  (out "wanted" (to-string wanted))
  (out "diff" (to-string (sub result wanted)))
  )

(end-script)
