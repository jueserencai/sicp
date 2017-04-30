#lang racket

(define (same_parity x . lst)
	(define (filter lst ok?)
		(if (null? lst)
			null
			(if (ok? (car lst))
				(cons (car lst) (filter (cdr lst) ok?))
				(filter (cdr lst) ok?))))
	(let ((odd_or_even (remainder x 2)))
		(cons x (filter lst (lambda (y) (= odd_or_even (remainder y 2)))))))
(same_parity 1 2 3 4 5 6 7 8)