; r5rs 环境

; main process
(define (make-accumulator acount)
	(define (increase inc)
		(begin (set! acount (+ acount inc))
			acount))
	increase)

; run test
(define A (make-accumulator 5))
(A 10)
(A 10)

; the output result
; 15
; 25