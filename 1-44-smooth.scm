#lang racket

(define (smooth f)
	(define dx 0.00001)
	(lambda (x)
		(/ (+ (f (- x dx)) (f x) (f (+ x dx))) 3.0)))
(define (smooth_n f n)
	(repeated smooth n) f)

(define (repeated f n)
	(if (= n 1)
		f
		(compose f (repeated f (- n 1)))))
(define (compose f g)
	(lambda (x)
		(f (g x))))
(define (square x)
	(* x x))



((smooth square) 5)
((smooth_n square 2) 5)