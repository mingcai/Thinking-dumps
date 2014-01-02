(define (stream-enumerate-interval low high)
  (if (> low high)
    nil
    (cons-stream low (stream-enumerate-interval
                       (+ low 1)
                       high))))

(define list-in-range-stream
  stream-enumerate-interval)

(define (display-stream s)
  (stream-for-each display-line s))

(define display-line
  ; I personally do not like
  ;   to have newline outputed
  ;   before any meaningful info outputed
  out)

(define (integers-starting-from n)
  (cons-stream
    n
    (integers-starting-from (+ n 1))))

(define (take n stream)
  (if (or (= n 0) (stream-null? stream))
    the-empty-stream
    (cons-stream
      (stream-car stream)
      (take (- n 1) (stream-cdr stream)))))

(define (drop n stream)
  (if (or (= n 0) (stream-null? stream))
    stream
    (drop (- n 1) (stream-cdr stream))))

; print few elements from the stream, as a test
(define (print-few n stream)
  (out (stream->list (take n stream))))

(define (zip-streams-with proc)
  (lambda args
    (apply stream-map (cons proc args))))

(define add-streams (zip-streams-with +))

(define ones (cons-stream 1 ones))
(define integers
  (cons-stream 1 (add-streams ones integers)))

(define (scale-stream stream factor)
  (stream-map
    ((curry2 *) factor)
    stream))

(define (stream-sum s)
  ; (stream-sum s) = s0, s0+s1, s0+s1+s2, ...
  ;   where s = s0, s1, s2, ...
  (define stream-sum-aux
    (cons-stream
      0
      (add-streams s stream-sum-aux)))
  (drop 1 stream-sum-aux))
(define parital-sums stream-sum)