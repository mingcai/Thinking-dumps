(load "../common/utils.scm")
(load "../common/test-utils.scm")

;; try to use the framework of my-eval.

(define *my-eval-do-test* #f)

(load "./my-eval-handler.scm")
(load "./my-eval-data-directed.scm")
(load "./my-eval-env.scm")
(load "./my-eval-utils.scm")
(load "./my-eval-maybe.scm")

(load "./my-eval-apply.scm")
(load "./my-eval-init-env.scm")

(load "./amb-eval-e-simple.scm")



(end-script)

;; Local variables:
;; proc-entry: ""
;; End:
