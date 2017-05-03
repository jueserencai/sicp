#lang racket

; base process for the higher process
(define (fold-right op initial sequence)
	(if (null? sequence)
		initial
		(op (car sequence)
			(fold-right op initial (cdr sequence)))))
(define (fold-left op initial sequence)
	(define (iter result rest)
		(if (null? rest)
			result
			(iter (op result (car rest))
				(cdr rest))))
	(iter initial sequence))


; main process
(define (reverse-fold-right sequence)
	(fold-right (lambda (x y) (append y (list x))) null sequence))

(define (reverse-fold-left sequence)
	(fold-left (lambda (x y) (cons y x)) null sequence))


(define x (list 1 2 3))

; run test
(reverse-fold-right x)
(reverse-fold-left x)
