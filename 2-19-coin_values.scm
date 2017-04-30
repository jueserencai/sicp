#lang racket
(define (cc amount coin_values)
	(define (first_denomination coin_values)
		(car coin_values))
	(define (except_first_denomination coin_values)
		(cdr coin_values))
	(define (no_more? coin_values)
		(null? coin_values))

	(cond ((= amount 0) 1)
			((or (< amount 0) (no_more? coin_values)) 0)
			(else 
				(+ (cc amount
						(except_first_denomination coin_values))
					(cc (- amount (first_denomination coin_values))
						coin_values)))))


(define us_coins (list 50 25 10 5 1))

(cc 100 us_coins)