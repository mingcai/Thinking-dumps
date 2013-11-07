(load "../common/utils.scm")
(load "../common/test-utils.scm")

(define (my-cons x y)
  (define (set-x! v) (set! x v))
  (define (set-y! v) (set! y v))

  (define (dispatch m)
    (cond ((eq? m 'car) x)
          ((eq? m 'cdr) y)
          ((eq? m 'set-car!) set-x!)
          ((eq? m 'set-cdr!) set-y!)))
    dispatch)

(define (my-car a) (a 'car))
(define (my-cdr a) (a 'cdr))

(define (my-set-car! a v)
  ((a 'set-car!) v) v)

(define (my-set-cdr! a v)
  ((a 'set-cdr!) v) v)

(define x (my-cons 1 2))
(define z (my-cons x x))
(my-set-car! (my-cdr z) 17)
(out (my-car x))

(end-script)
