(define (install-eval-letrec)
  (define (letrec->let exp)
    (define binding-pairs
      (cadr exp))
    (define vars (map car  binding-pairs))
    (define exps (map cadr binding-pairs))
    (define body
      (cddr exp))
    `(let ,(map (lambda (var)
                  `(,var '*unassigned*))
                vars)
       ,@(map (lambda (var exp) `(set! ,var ,exp))
              vars exps)
       ,@body))

  (define (eval-letrec exp env)
    (my-eval (letrec->let exp) env))

  (define (analyze-letrec exp)
    (my-analyze (letrec->let exp)))

  (define (test-eval eval-letrec)
    (let ((env (init-env)))
      (do-test
        eval-letrec
        (list
          (mat `(letrec ((fact (lambda (n)
                                 (if (= n 0)
                                   1
                                   (* n (fact (- n 1)))))))
                  (fact 4)) env
               24)
          (mat `(letrec ((f1 (lambda (n)
                               (if (= n 0)
                                 1
                                 (* n (f2 (- n 1))))))
                         (f2 (lambda (n)
                               (if (= n 0)
                                 1
                                 (* n (f3 (- n 1))))))
                         (f3 (lambda (n)
                               (if (= n 0)
                                 1
                                 (* n (f1 (- n 1)))))))
                  (f3 10)) env
               3628800)
          ))
      'ok))

  (define handler
    (make-handler
      'letrec
      eval-letrec
      analyze-letrec
      (test-both
       test-eval
       eval-letrec
       analyze-letrec)))

  (handler-register! handler)
  'ok)
;; Local variables:
;; proc-entry: "./my-eval.scm"
;; End:

