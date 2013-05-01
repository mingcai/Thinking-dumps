; just follow the suggestion here:
; http://stackoverflow.com/questions/15552057/is-it-possible-to-implement-define-macro-in-mit-scheme/
; we should prefer syntax-rules over define-macro
;     so that we'll get clearer codes.
(define-syntax define-syntax-rule
  (syntax-rules ()
    ((define-syntax-rule (name . pattern) template)
     (define-syntax name
       (syntax-rules ()
         ((name . pattern) template))))))

; see:
; http://www.ps.uni-saarland.de/courses/info-i/scheme/doc/refman/refman_11.html#IDX1288
; in mit-scheme, `gensym` is called `generate-uninterned-symbol`
(define gensym generate-uninterned-symbol)

(define call/cc call-with-current-continuation)

(define out
  (lambda items
    (map (lambda (x)
           (display x)
           (newline)) items)))

; calculate time difference
; returns a pair (return value . time elapsed)
(define time-test
  (lambda (f . args)
    (let ((start-time (real-time-clock)))
      ; require the value immediately to force it
      start-time
      (let ((f-result (apply f args)))
        (let* ((end-time (real-time-clock))
               (diff-time (- end-time start-time)))
          ; force it
          diff-time
          (display "Time elapsed: ")
          (display diff-time)
          (newline)
        (cons f-result diff-time))))))

(define (square x) (* x x))
(define (random-range-in a b)
  (+ a (random (+ (- b a) 1))))
  ; random (b-a)+1 -> [0, (b-a)] + a -> [a, b] 

; take-iterate: make a finite list with 'len' elements
; the first one is 'seed', and others are generated by applying prev element to 'next'
(define (take-iterate next seed len)
  (if (= 0 len)
    '()
    (cons seed 
          (take-iterate next (next seed) (- len 1)))))

; construct a list [a..b]
(define (list-in-range a b)
  (if (<= a b)
    (cons a (list-in-range (+ a 1) b))
    '()))
