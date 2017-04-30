#lang racket

(define zero (lambda (f) (lambda (x) x)))
(define (add_1 n)
	(lambda (f) (lambda (x) (f ((n f) x)))))

; ((add_1 5) 7)
(zero)rac