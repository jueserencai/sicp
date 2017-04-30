#lang racket

; improved make_rat, can dispose the positive number and negative number in a standard
(define (make_rat n d)
	(let ((g (gcd n d))
			(sign (if (< (* n d) 0) -1 1)))
		(cons (/ (* sign (abs n)) g) (/ (abs d) g))))
(define (numer x) (car x))
(define (denom x) (cdr x))
; print number
(define (print_rat x)
	(newline)
	(display (numer x))
	(display "/")
	(display (denom x)))

(define one_half (make_rat 4 -2))
(print_rat one_half)