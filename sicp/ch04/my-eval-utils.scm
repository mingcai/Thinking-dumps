; list-tagged-with: Tag -> List -> Bool
(define (list-tagged-with tag)
  (lambda (l)
    (and
      (list? l)
      (non-empty? l)
      (eq? (car l) tag))))

; same as `list-tagged-with` expect the argument
;   arrangement, to keep compatibility
; tagged-list?: List x Tag -> Bool
(define (tagged-list? exp tag)
  ((list-tagged-with tag) exp))

; test the truth value in the implemented language
(define (true? x)
  (not (eq? x #f)))
(define (false? x)
  (eq? x #f))

; evaluate a list of values
(define (list-of-values exps env)
  (if (no-operands? exps)
    '()
    (cons (my-eval (first-operand exps) env)
          (list-of-values (rest-operands exps) env))))

(define (test-utils)
  ; test list-tagged-with and tagged-list?
  (let ((testcases
          (list
            (mat 'a #f)
            (mat '(t1 a b) #t)
            (mat '(t2 b) #f)
            (mat '(t1 a b c) #t)
            (mat '() #f)))
        (proc (lambda (exp)
                (tagged-list? exp 't1))))
    (do-test (list-tagged-with 't1) testcases)
    (do-test proc testcases)))

(if *my-eval-do-test*
  (test-utils))
