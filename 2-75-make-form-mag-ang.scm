#lang racket

; main process
(define (make-from-mag-ang mag ang)
	(define (dispatch op)
		(cond ((eq? op 'magnitude) mag)
			((eq? op 'angle) ang)
			((eq? op 'real-part) (* mag (cos ang)))
			((eq? op 'imag-part) (* mag (sin ang)))
			(else
				(error "Unknown op -- MAKE-FROM-MAG-ANG" op))))
	dispatch)

; run test
(define c (make-from-mag-ang 3 4))
(c 'real-part)
; 结果 -1.960930862590836
(define d (make-from-mag-ang 2 (/ 3.14 3)))
(d 'real-part)
; 结果 1.0009193780164116