#lang racket

; base process for the higher process
(define (accumulate op initial sequence)
	(if (null? sequence)
		initial
		(op (car sequence)
			(accumulate op initial (cdr sequence)))))
(define (accumulate-n op init seqs)
	(if (null? (car seqs))
		null
		(cons (accumulate op init (map (lambda (x) (car x)) seqs))
		(accumulate-n op init (map (lambda (x) (cdr x)) seqs)))))


; main process
(define (matrix-*-vector m v)
	(map (lambda (row) (accumulate + 0 (map * row v))) m))
(define (transpose mat)
	(accumulate-n cons null mat))
(define (matrix-*-matrix m n)
	(let ((cols (transpose n)))
		(map (lambda (row) (matrix-*-vector cols row)) m)))


(define m (list (list 1 2 3 4) (list 4 5 6 6) (list 6 7 8 9)))
(define v (list 1 1 1 1))
(define n (list (list 1 2 3) (list 2 3 4) (list 3 4 5) (list 4 5 6)))

; run test
(matrix-*-vector m v)
(transpose m)
(matrix-*-matrix m n)