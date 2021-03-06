(define sense-data
  (list->stream
    '(1 2 1.5 1 0.5 -0.1 -2 -3 -2 -0.5 0.2 3 4)))

(define (sign-change-detector
          new-val
          old-val)
  (define (sgn x)
    ; the sign of zero is positive
    (if (>= x 0) 1 -1))
  (let ((new-sgn (sgn new-val))
        (old-sgn (sgn old-val)))
    (if (= new-sgn old-sgn)
      0
      ; else there's a zero-crossing
      (if (= old-sgn 1)
        ; positive -> negative
        -1
        ; negative -> positive
        +1))))

(define (make-zero-crossings
          input-stream
          last-value)
  (cons-stream
    (sign-change-detector
      (stream-car input-stream)
      last-value)
    (make-zero-crossings
      (stream-cdr input-stream)
      (stream-car input-stream))))
