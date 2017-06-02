#lang racket

(define (element-of-set? x set)
	(cond ((null? set) false)
		((equal? x (car set)) true)
		(else (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
	(cons x set))	; 修改

(define (intersection-set set1 set2)
	(cond ((or (null? set1) (null? set2)) '())
		((element-of-set? (car set1) set2)
			(cons (car set1)
				(intersection-set (cdr set1) set2)))
		(else (intersection-set (cdr set1) set2))))

(define (union-set set1 set2)
	(append set1 set2))	; 修改

; run test
(define s1 '(2 3 2 1 3 2 2))
(define s2 '(9 2 3 4 8 10))

(newline)
(display (intersection-set s1 s2))

(newline)
(display (union-set s1 s2))

; element-of-set? 和intersection-set的复杂度急剧上升，而adjoin-set和union-set的复杂度下降了一个O(n)。

; 在adjoin-set操作和union-set操作比较多，element-of-set?和intersection-set操作比较少的时候，使用允许重复元素的表