#lang racket

; fixed_point
(define (fixed_point f first_guess)
	(define (close_enough? v1 v2)
		(< (abs (- v1 v2)) tolerance))
	(define tolerance 0.00001)
	(define (average_damp x)
		(/ (+ x (f x)) 2))
	(define (try guess)
		; 
		(let ((next ((repeated average_damp 2) guess)))
			(if (close_enough? guess next)
				next
				(try next))))
	(try first_guess))


(define (repeated f n)
	(if (= n 1)
		f
		(compose f (repeated f (- n 1)))))
(define (compose f g)
	(lambda (x)
		(f (g x))))

(define (sqrt x)
	(fixed_point (lambda (y)
		(/ x y y y))
		1.0))
(sqrt 50)