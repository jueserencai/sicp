#lang racket

(define (fringe tree)
	(define (iter residue lst)
		(cond ((null? residue) lst)
			((not (pair? residue)) (cons residue lst))
			(else (iter (car residue) (iter (cdr residue) lst)))))
	(iter tree null))

(define x (list (list 1 2) (list 3 4)))
(fringe x)