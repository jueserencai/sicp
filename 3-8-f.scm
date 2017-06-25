

; main process
; f1与f2完全相同
(define f1
	(lambda (first-value)
		(begin (set! f1 (lambda (second-value) 0))
			first-value)))
(define f2
	(lambda (first-value)
		(begin (set! f2 (lambda (second-value) 0))
			first-value)))

; run test
(+ (f1 0) (f1 1))
(+ (f2 1) (f2 0))

; output result
; 0
; 1
; 可看出racket解释器是从左向右求值计算的