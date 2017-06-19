#lang racket


; 因为已经有了多项式的加法，题目中提示了写出一个通用的求负的过程就可以完成多项式的减法。

; base process
(define (adjoin-term term term-list)
	(if (=zero? (coeff term))
		term-list
		(cons term term-list)))
(define (the-empty-termlist) '())
(define (first-term term-list) (car term-list))
(define (rest-terms term-list) (cdr term-list))
(define (empty-termlist? term-list) (null? term-list))
(define (make-term order coeff) (list order coeff))
(define (order term) (car term))
(define (coeff term) (cadr term))
(define (=zero? poly)
	(or (= 0 poly) (empty-termlist? poly)))
(define (term? term)
	(and (not (null? term)) (pair? term) (number? (order term))))
(define (polynomial? poly)
	(and (not (null? poly)) (pair? poly) (term? (first-term poly))))

; main process
(define (for-negative poly)
	(cond ((null? poly) null)
		((number? poly) (- 0 poly))
		((term? poly) (make-term (order poly) (- 0 (coeff poly))))
		((polynomial? poly)
			(adjoin-term (for-negative (first-term poly)) (for-negative (rest-terms poly))))
		(else (error "can't distinguish"))))

; test
(define x100 (make-term 100 1))
(define x2 (make-term 2 2))
(define x0 (make-term 0 1))

(define poly1 (adjoin-term x0 (the-empty-termlist)))
(define poly2 (adjoin-term x2 poly1))
(define poly3 (adjoin-term x100 poly2))
; ((100 1) (2 2) (0 1))
(for-negative (first-term poly3))
; '((100 -1) (2 -2) (0 -1))