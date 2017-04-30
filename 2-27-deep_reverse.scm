#lang racket

(define (deep_reverse lst)
;	(newline)
;	(display lst)
	(cond ((pair? lst) 
			(if (null? (cdr lst))
				(deep_reverse (car lst))
				(cons (deep_reverse (cdr lst)) (deep_reverse (car lst)))))
		  (else lst)))

(define x (list (list 1 2) (list 3 4)))
(deep_reverse x)