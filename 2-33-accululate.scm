#lang racket

(define (accumulate op initial sequence)
	(if (null? sequence)
		initial
		(op (car sequence)
			(accumulate op initial (cdr sequence)))))

(define (map p sequence)
	(accumulate (lambda (x y) (cons (p x) y)) null sequence))

(define (append seq1 seq2)
	(accumulate cons seq1 seq2))

(define (length sequence)
	(accumulate (lambda (x y) (+ x y))  0 sequence))

(define square (lambda (x) (* x x)))


(define x (list 1 2 3))
(define y (list 4 5 6))

(map square x)