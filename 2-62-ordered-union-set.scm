#lang racket

(define (union-set set1 set2)
	(cond ((or (null? set1) (null? set2)) (append set1 set2))
		((< (car set1) (car set2))
			(cons (car set1) (union-set (cdr set1) set2)))
		((= (car set1) (car set2))
			(cons (car set1) (union-set (cdr set1) (cdr set2))))
		((> (car set1) (car set2))
			(cons (car set2) (union-set set1 (cdr set2))))))

; run test
(union-set '(3 5 9) '(1 2 4 5))
