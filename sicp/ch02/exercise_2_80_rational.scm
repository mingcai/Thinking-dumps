(define (install-rational-package)
  ;; internal procedures
  (define numer car)
  (define denom cdr)
  (define (make-rat n d)
    (let ((g (gcd n d)))
      (cons (/ n g)
            (/ d g))))
  (define (add-rat x y)
    (make-rat (+ (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (neg-rat x)
    (make-rat (- (numer x))
              (denom x)))
  (define (sub-rat x y)
    (add-rat x (neg-rat y)))

  (define (=zero? x)
    (< (abs (/ (numer x) (denom x))) eps))

  ;; interface to rest of the system
  (define (tag x) (attach-tag 'rational x))
  (define (tagged f)
    (lambda args (tag (apply f args))))

  (put 'add '(rational rational) (tagged add-rat))
  (put 'sub '(rational rational) (tagged sub-rat))
  (put '=zero? '(rational) =zero?)

  (put 'make 'rational (tagged make-rat))
  'done)
