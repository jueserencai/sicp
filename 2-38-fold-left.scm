#lang racket

; base process for the higher process
(define (fold-right op initial sequence)
	(if (null? sequence)
		initial
		(op (car sequence)
			(fold-right op initial (cdr sequence)))))

; main process
(define (fold-left op initial sequence)
	(define (iter result rest)
		(if (null? rest)
			result
			(iter (op result (car rest))
				(cdr rest))))
	(iter initial sequence))


(define x (list 1 2 3))

; run test
(fold-right / 1 x)
(fold-left / 1 x)
(fold-right list null x)
(fold-left list null x)

; (fold-right op i (a b c)) = (op a (op b (op c i)))
; (fold-left op i (a b c))  = (op (op (op i a) b) c)
;; 想要op保证fold-right 和 fold-left 对任何序列产生同样的结果，op应该满足交换律。
