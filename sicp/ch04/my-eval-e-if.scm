; handle if-exp
(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))

;; (if <if-predicate>
;;   <if-consequent>
;;   [<if-alternative>])
(define if-predicate cadr)
(define if-consequent caddr)
(define (if-alternative exp)
  ;; allowing the else part not filled.
  (if (non-empty? (cdddr exp))
      (cadddr exp)
      '#f))

(define (install-eval-if)

  (define (eval-if exp env)
    ; use `true?` here allows the language to be implemented
    ;   having a different representaion of truth value
    (if (true? (my-eval (if-predicate exp) env))
      (my-eval (if-consequent exp) env)
      (my-eval (if-alternative exp) env)))

  (define (analyze-if exp)
    (let ((pproc (my-analyze (if-predicate exp)))
          (cproc (my-analyze (if-consequent exp)))
          (aproc (my-analyze (if-alternative exp))))
      (lambda (env)
        (if (true? (pproc env))
            (cproc env)
            (aproc env)))))

  (define (test-eval eval-if)
    (define env
      (init-env))

    (define testcases
      (list
        (mat '(if 1 10) env 10)
        (mat '(if 1 10 20) env 10)
        (mat '(if #t 10 20) env 10)
        (mat '(if 'a 10 20) env 10)
        (mat '(if '#f 10 20) env 20)
        (mat '(if #f 10 20) env 20)
        (mat '(if true 10 20) env 10)
        (mat '(if 'false 10 20) env 10)
        (mat '(if false 10 20) env 20)
        (mat '(if (= 1 1) (+ 10 20) (* 10 20)) env 30)
        (mat '(if (= 0 1) (+ 10 20) (* 10 20)) env 200)
        ))
    (do-test eval-if testcases)
    'ok)

  (define handler
    (make-handler
      'if
      eval-if
      analyze-if
      (test-both
       test-eval
       eval-if
       analyze-if)))

  (handler-register! handler)
  'ok)
;; Local variables:
;; proc-entry: "./my-eval.scm"
;; End:
