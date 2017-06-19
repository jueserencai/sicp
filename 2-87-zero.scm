#lang racket

; 添加进polynomial包中
(define (=zero? poly)
	(or (= 0 poly) (empty-termlist? poly)))

(put '=zero 'polynomial =zero?)