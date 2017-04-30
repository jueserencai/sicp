#lang racket

; return the last one element  
(define (last_pair a_list)
	(if (null? (cdr a_list))
		(car a_list)
		(last_pair (cdr a_list))))
; run test
; (last_pair (list 23 72 149 34))

; reverse the list
(define (list_reverse a_list)
	(define (reverse_iter remain result)
		(if (null? remain)
			result
			(reverse_iter (cdr remain) (cons (car remain) result))
			))
	(reverse_iter a_list null))
; run test
(list_reverse (list 23 72 149 34))
