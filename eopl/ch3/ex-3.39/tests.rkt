(module tests mzscheme
  
  (provide test-list)
  ;;;;;;;;;;;;;;;; tests ;;;;;;;;;;;;;;;;
  
  (define test-list
    '(
  
      ;; simple arithmetic
      (positive-const "11" 11)
      (negative-const "-33" -33)
      (simple-arith-1 "-(44,33)" 11)
  
      ;; nested arithmetic
      (nested-arith-left "-(-(44,33),22)" -11)
      (nested-arith-right "-(55, -(22,11))" 44)
  
      ;; simple variables
      (test-var-1 "x" 10)
      (test-var-2 "-(x,1)" 9)
      (test-var-3 "-(1,x)" -9)
      
      ;; simple unbound variables
      (test-unbound-var-1 "foo" error)
      (test-unbound-var-2 "-(x,foo)" error)
  
      ;; simple conditionals
      (if-true "if zero?(0) then 3 else 4" 3)
      (if-false "if zero?(1) then 3 else 4" 4)
      
      ;; test dynamic typechecking
      (no-bool-to-diff-1 "-(zero?(0),1)" error)
      (no-bool-to-diff-2 "-(1,zero?(0))" error)
      (no-int-to-if "if 1 then 2 else 3" error)

      ;; make sure that the test and both arms get evaluated
      ;; properly. 
      (if-eval-test-true "if zero?(-(11,11)) then 3 else 4" 3)
      (if-eval-test-false "if zero?(-(11, 12)) then 3 else 4" 4)
      
;      these aren't translatable. Exercise: make them translatable by
;      providing a binding for foo.
;       ;; and make sure the other arm doesn't get evaluated.
;       (if-eval-test-true-2 "if zero?(-(11, 11)) then 3 else foo" 3)
;       (if-eval-test-false-2 "if zero?(-(11,12)) then foo else 4" 4)

      ;; simple let
      (simple-let-1 "let x = 3 in x" 3)

      ;; make sure the body and rhs get evaluated
      (eval-let-body "let x = 3 in -(x,1)" 2)
      (eval-let-rhs "let x = -(4,1) in -(x,1)" 2)

      ;; check nested let and shadowing
      (simple-nested-let "let x = 3 in let y = 4 in -(x,y)" -1)
      (check-shadowing-in-body "let x = 3 in let x = 4 in x" 4)
      (check-shadowing-in-rhs "let x = 3 in let x = -(x,1) in x" 2)

      ;; simple applications
      (apply-proc-in-rator-pos "(proc(x) -(x,1)  30)" 29)
      (apply-simple-proc "let f = proc (x) -(x,1) in (f 30)" 29)
      (let-to-proc-1 "(proc(f)(f 30)  proc(x)-(x,1))" 29)


      (nested-procs "((proc (x) proc (y) -(x,y)  5) 6)" -1)
      (nested-procs2 "let f = proc(x) proc (y) -(x,y) in ((f -(10,5)) 6)"
        -1)
      
      (y-combinator-1 "
let fix =  proc (f)
            let d = proc (x) proc (z) ((f (x x)) z)
            in proc (n) ((f (d d)) n)
in let
    t4m = proc (f) proc(x) if zero?(x) then 0 else -((f -(x,1)),-4)
in let times4 = (fix t4m)
   in (times4 3)" 12)

      (test-emptylist "emptylist" ())

      (test-cons "cons(1,cons(2,emptylist))" (1 2))

      (test-car "car(cons(1,cons(2,emptylist)))" 1)

      (test-cdr "cdr(cons(1,cons(2,emptylist)))" (2))

      (test-null?-1 "null?(emptylist)" #t)
      (test-null?-2 "null?(cons(1,emptylist))" #f)

      (test-book-example
        "let x = 4 in cons(x,cons(cons(-(x,1),emptylist),emptylist))"
        (4 (3)))

      (test-unpack-1 "unpack x y z = cons(1,cons(2,cons(3,emptylist))) in -(-(x,-(0,y)),-(0,z))" 6)
      (test-unpack-2 "unpack = emptylist in 1" 1)

      (test-unpack-len-mismatch-1 "unpack x y = cons(1,emptylist) in 1" error)
      (test-unpack-len-mismatch-2 "unpack x y = cons(1,cons(2,cons(3,emptylist))) in 3" error)

      (test-unpack-book-example "let u = 7 in unpack x y = cons(u,cons(3,emptylist)) in -(x,y)" 4)

      ))
  )
