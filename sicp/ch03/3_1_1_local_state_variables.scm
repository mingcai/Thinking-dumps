(load "../common/utils.scm")
(load "../common/test-utils.scm")

(define balance)

(set! balance 100)

(define (withdraw amount)
  (if (< balance amount)
    (out "Insufficient funds")
    (begin
      (set! balance (- balance amount))
      (out balance))))

(for-each withdraw '(25 25 60 15))

(newline)
(define new-withdraw
  (let ((balance 100))
    (lambda (amount)
      (if (>= balance amount)
        (begin (set! balance (- balance amount))
               (out balance))
        (out "Insufficient funds")))))
(for-each new-withdraw '(25 25 60 15))

(define (make-withdraw balance)
  (lambda (amount)
    (if (>= balance amount)
      (begin (set! balance (- balance amount))
             (out balance))
      (out "Insufficient funds"))))

(define W1 (make-withdraw 100))
(define W2 (make-withdraw 100))

(newline)
(W1 50)
; 50
(W2 70)
; 30
(W2 40)
; Insufficient funds
(W1 40)
; 10

(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
      (begin (set! balance (- balance amount))
             (out balance))
      (out "Insufficient funds")))
  (define (deposit amount)
    (set! balance (+ balance amount))
    (out balance))
  (define (dispatch m)
    (cond ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else (error "Unknown request: MAKE-ACCOUNT"
                       m))))
  dispatch)

(newline)
(define acc (make-account 100))

((acc 'withdraw) 50)
; 50
((acc 'withdraw) 60)
; Insufficient funds
((acc 'deposit) 40)
; 90
((acc 'withdraw) 60)
; 30

(newline)
(define acc2 (make-account 100))
((acc2 'withdraw) 40)
; 60
((acc 'withdraw) 40)
; Insufficient funds

(end-script)
