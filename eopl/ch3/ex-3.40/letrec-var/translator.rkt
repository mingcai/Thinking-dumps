(module translator (lib "eopl.ss" "eopl")
  
  (require "lang.rkt")

  (provide translation-of-program)
  ;;;;;;;;;;;;;;;; lexical address calculator ;;;;;;;;;;;;;;;;

  ;; translation-of-program : Program -> Nameless-program
  ;; Page: 96
  (define translation-of-program
    (lambda (pgm)
      (cases program pgm
        (a-program (exp1)
          (a-program                    
            (translation-of exp1 (init-senv)))))))

  ;; translation-of : Exp * Senv -> Nameless-exp
  ;; Page 97
  (define translation-of
    (lambda (exp senv)
      (cases expression exp
        (const-exp (num) (const-exp num))
        (diff-exp (exp1 exp2)
          (diff-exp
            (translation-of exp1 senv)
            (translation-of exp2 senv)))
        (zero?-exp (exp1)
          (zero?-exp
            (translation-of exp1 senv)))
        (if-exp (exp1 exp2 exp3)
          (if-exp
            (translation-of exp1 senv)
            (translation-of exp2 senv)
            (translation-of exp3 senv)))
        (var-exp (var)
          (let ((result (apply-senv senv var)))
            (if (cdr result)
              ; letrec var
              (nameless-letrec-var-exp
                (car result))
              ; normal var
              (nameless-var-exp
                (car result)))))
        (let-exp (var exp1 body)
          (nameless-let-exp
            (translation-of exp1 senv)            
            (translation-of body
              (extend-senv var senv))))
        (letrec-exp (p-name p-var p-body body)
          (nameless-let-exp
            (translation-of
              (proc-exp p-var p-body)
              (extend-letrec-senv p-name senv))
            (translation-of body
              (extend-senv p-name senv))))
        (proc-exp (var body)
          (nameless-proc-exp
            (translation-of body
              (extend-senv var senv))))
        (call-exp (rator rand)
          (call-exp
            (translation-of rator senv)
            (translation-of rand senv)))
        (else (report-invalid-source-expression exp))
        )))

  (define report-invalid-source-expression
    (lambda (exp)
      (eopl:error 'value-of 
        "Illegal expression in source code: ~s" exp)))
  
   ;;;;;;;;;;;;;;;; static environments ;;;;;;;;;;;;;;;;
  
  ;;; Senv = Listof(Sym)
  ;;; Lexaddr = N

  ;; empty-senv : () -> Senv
  ;; Page: 95
  (define empty-senv
    (lambda ()
      '()))

  ;; extend-senv : (Var * Bool) * Senv -> Senv
  ;; Page: 95
  ;; (cons <the-var> <letrec-var?>)
  (define extend-senv
    (lambda (var senv)
      (cons (cons var #f) senv)))
  
  (define extend-letrec-senv
    (lambda (var senv)
      (cons (cons var #t) senv)))

  ;; apply-senv : Senv * Var -> Lexaddr
  ;; Page: 95
  (define apply-senv
    (lambda (senv var)
      (cond
        ((null? senv) (report-unbound-var var))
        ((eqv? var (caar senv))
          (cons 0 (cdar senv)))
        (else
          (let ((result (apply-senv (cdr senv) var)))
            (cons (+ 1 (car result))
                  (cdr result)))))))

  (define report-unbound-var
    (lambda (var)
      (eopl:error 'translation-of "unbound variable in code: ~s" var)))

  ;; init-senv : () -> Senv
  ;; Page: 96
  (define init-senv
    (lambda ()
      (extend-senv 'i
        (extend-senv 'v
          (extend-senv 'x
            (empty-senv))))))
  
  )