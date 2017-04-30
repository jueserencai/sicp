#lang racket

(define (square_list items)
	(if (null? items)
		null
		(cons (* (car items) (car items)) (square_list (cdr items)))))

(define (square_list_2 items)
	(map (lambda (x) (* x x))
		items))

(square_list_2 (list 1 2 3 4))