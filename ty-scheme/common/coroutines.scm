(define-syntax coroutine
  (rsc-macro-transformer
    (let ((xfmr 
            (lambda (x . body)
              `(letrec ((+local-control-state
                          (lambda (,x) ,@body))
                        (resume
                          (lambda (c v)
                            (call/cc 
                              (lambda (k)
                                (set! +local-control-state k)
                                (c v))))))
                 (lambda (v)
                   (+local-control-state v))))))

      (lambda (e r)
        (apply xfmr (cdr e))))))
