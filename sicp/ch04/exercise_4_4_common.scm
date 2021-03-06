(define def-env user-initial-environment)

(define true? identity)
(define true-value #t)
(define false-value #f)

(define (test-and-or eval-and eval-or)
  (let ((testcases
          (list
            (mat '(and) #t)
            (mat '(and (= 1 1) (= 2 2)) #t)
            (mat '(and (= 1 1) #f (error 'wont-reach)) #f)
            (mat '(and 1 2 3 4) 4)
            (mat '(and 1) 1)
          ))
        (proc
          (lambda (exp)
            (eval-and exp def-env))))
    (do-test proc testcases))
  (let ((testcases
          (list
            (mat '(or) #f)
            (mat '(or #t (error 'wont-reach)) #t)
            (mat '(or (< 1 1) (> 2 2)) #f)
            (mat '(or (quote symbol)) 'symbol)
            (mat '(or #f #f 1) 1)
          ))
        (proc
          (lambda (exp)
            (eval-or exp def-env))))
    (do-test proc testcases)))
