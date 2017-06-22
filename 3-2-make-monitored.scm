; r5rs

; mian process
(define (make-monitored f)
	(define count 0)
	(define (incease-count)
		(set! count (+ 1 count)))
	(define (reset-count)
		(set! count 0))
	(define (how-many-calls?) count)
	(define (dispatch m)
		(cond ((eq? m 'how-many-calls) (how-many-calls?))
			((eq? m 'reset-count) (reset-count))
			(else (begin (incease-count) (f m)))))
	dispatch)

; run test
(define s (make-monitored sqrt))
(s 100)
(s 'how-many-calls)
(s 50)
(s 'how-many-calls)
(s 'reset-count)
(s 'how-many-calls)

; the output result
; 10
; 1
; 7.0710678118654755
; 2
; 0