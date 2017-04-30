#lang racket

(define (cons+ a b)
	(* (expt 2 a) (expt 3 b)))
(define (car+ A)
	(iter_car_cdr A 2 0))
(define (cdr+ A)
	(iter_car_cdr A 3 0))
(define (iter_car_cdr x divide n)
	(if (= 0 (remainder x divide))
		(iter_car_cdr (/ x divide) divide (+ n 1))
		n))

(define A (cons+ 2 5))
(car+ A)
