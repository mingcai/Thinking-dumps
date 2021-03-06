(load "./4_3_data_directed_aly_impl.scm")
(load "./4_3_data_directed_ben_impl.scm")

(install-rect-package)
(install-polar-package)

(define (install-complex-package)

  (define (real-part z)
    (apply-generic 'real-part z))
  (define (imag-part z)
    (apply-generic 'imag-part z))
  (define (magnitude z)
    (apply-generic 'magnitude z))
  (define (angle z)
    (apply-generic 'angle z))
  (define make-from-real-imag
    (get 'make-from-real-imag 'rect))
  (define make-from-mag-ang
    (get 'make-from-mag-ang 'polar))

  (define (add-complex z1 z2)
    (make-from-real-imag (+ (real-part z1) (real-part z2))
                         (+ (imag-part z1) (imag-part z2))))
  (define (neg-complex z)
    (make-from-real-imag (- (real-part z)) (- (imag-part z))))
  (define (sub-complex z1 z2)
    (add-complex z1 (neg-complex z2)))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (* (magnitude z1) (magnitude z2))
                       (+ (angle z1) (angle z2))))
  (define (inv-complex z)
    (let* ((a (real-part z))
           (b (imag-part z))
           (a^2+b^2 (+ (square a) (square b))))
      (make-from-real-imag (/ a a^2+b^2)
                           (/ (- b) a^2+b^2))))
  (define (div-complex z1 z2)
    (mul-complex z1 (inv-complex z2)))

  (define (tag z) (attach-tag 'complex z))
  (define (tagged f) (lambda args (tag (apply f args))))

  (put 'add '(complex complex) (tagged add-complex))
  (put 'sub '(complex complex) (tagged sub-complex))
  (put 'mul '(complex complex) (tagged mul-complex))
  (put 'div '(complex complex) (tagged div-complex))

  (put 'make-from-real-imag 'complex (tagged make-from-real-imag))
  (put 'make-from-mag-ang 'complex (tagged make-from-mag-ang))
  'done)
