#lang racket

; newtons method
(define (newtons_method g guess)
	(define (newtons_transform g)
		(lambda (x)
			(- x (/ (g x) ((deriv g) x)))))
	(define (deriv g)
		(lambda (x) 
			(/ (- (g (+ x dx)) (g x))
				dx)))
	(define dx 0.00001)

	(fixed_point (newtons_transform g) guess))


; fixed_point
(define (fixed_point f first_guess)
	(define (close_enough? v1 v2)
		(< (abs (- v1 v2)) tolerance))
	(define tolerance 0.00001)
	(define (try guess)
		(let ((next (f guess)))
			(if (close_enough? guess next)
				next
				(try next))))
	(try first_guess))

(define (cublic a b c)
	(lambda (x)
		(+ (* x x x) (* a x x) (* b x) c)))

; test run
(newtons_method (cublic 1 1 -3) 1.0)