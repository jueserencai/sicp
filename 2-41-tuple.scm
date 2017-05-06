#lang racket

; base process
(define (accumulate op initial sequence)
	(if (null? sequence)
		initial
		(op (car sequence)
			(accumulate op initial (cdr sequence)))))
(define (enumerate-interval begin end)
	(define (iter result i)
		(if (> i end)
			result
			(iter (append result (list i)) (+ i 1))))
	(iter '() begin))
; compute the difference-set of two list
(define (difference-set seq1 seq2)
	(let ([seq1 (if (< (length seq1) (length seq2)) seq1 seq2)]
		  [seq2 (if (< (length seq1) (length seq2)) seq2 seq1)])
		(define (in? x)
			(if (null? (filter (lambda (y)
							(if (= y x)
								#t
								#f))
							seq1))
				#t
				#f))
		(filter in? seq2)))

; main process
(define (tuple n)
	(let ([seq (enumerate-interval 1 n)])
		(accumulate append '() 
			(map (lambda (i)
					(accumulate append '()
						(map (lambda (j)
							(map (lambda (k)
									(list i j k))
								(difference-set (list i j) seq)))
						(difference-set (list i) seq))))
				seq))))

; run test
(tuple 4)