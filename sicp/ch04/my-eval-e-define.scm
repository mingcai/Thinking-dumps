; require: quote
(define (install-eval-define)

  ; form #1: (define <var> <val>)
  ; form #2: (define (proc-name . args) <body>)
  (define (definition-variable exp)
    (if (symbol? (cadr exp))
      (cadr exp)
      (caddr exp)))

  (define (definition-value exp)
    (if (symbol? (cadr exp))
      (caddr exp)
      (make-lambda (cdadr exp)
                   (cddr exp))))

  (define (eval-define exp env)
    (define-variable!
      (definition-variable exp)
      (my-eval (definition-value exp) env)
      env)
    'ok)

  (define (test)
    ; 2-layer
    (define env
      (extend-environment
        '(a) '(10) the-empty-environment))

    (define env1
      (extend-environment
        '() '() env))

    ; define + redefine on `env`
    (eval-define '(define a 1) env)
    (eval-define '(define b 2) env)

    (do-test
      lookup-variable-value
      (list
        (mat 'a env 1)
        (mat 'b env 2)
        (mat 'a env1 1)
        (mat 'b env1 2)))

    ; define / shadowing on `env1`
    (eval-define '(define a "aaa") env1)
    (eval-define '(define b "bbb") env1)
    (eval-define '(define c "ccc") env1)

    ; changes on `env1` won't effect
    ;   anything on `env`
    (do-test
      lookup-variable-value
      (list
        (mat 'a env 1)
        (mat 'b env 2)
        (mat 'a env1 "aaa")
        (mat 'b env1 "bbb")
        (mat 'c env1 "ccc")))

    'done)

  (define handler
    (make-handler
      'define
      eval-define
      test))

  (handler-register! handler)
  'done)