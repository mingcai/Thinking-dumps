; excerpted from ex 2.85

; raise to a higher type for data (curried)
(define (raise-to type)
  (lambda (data)
    (let ((data-type (type-tag data)))
      (cond ((equal? type data-type) data)
            ((higher-type? type data-type)
             ((raise-to type) (raise data)))
            (else (error "no way to raise downwards: RAISE-TO"))))))

; pick up the highest type in the list
(define (highest-type ls)
  (fold-left
    (lambda (cur-highest cur-type)
      (if (higher-type? cur-type cur-highest)
        cur-type
        cur-highest))
    (car ls)
    (cdr ls)))

(define (apply-generic op . args)
  (define (raise-and-apply op args)
    (let* ((type-list (map type-tag args))
           (data-list (map contents args))

           (type-target (highest-type type-list))
           (new-type-list (map (const type-target) type-list))
           (raised-data (map (raise-to type-target) args))
           (proc (get op new-type-list)))
      (if proc
        (apply proc (map contents raised-data))
        (error "No method for thest types: APPLY-GENERIC"
               (list op args)))))

  (let ((type-list (map type-tag args))
        (data-list (map contents args)))
    (let ((proc (get op type-list)))
      (if proc
        (apply proc data-list)
        ; else try to raise all types and look for a procedure again
        (raise-and-apply op args)))))