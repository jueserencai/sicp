#lang racket

; base process
(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
	(list entry left right))
(define (element-of-set? x set)
	(cond ((null? set) false)
		((= x (entry set)) true)
		((< x (entry set))
			(element-of-set? x (left-branch)))
		((> x (entry set))
			(element-of-set? x (right-branch set)))))
(define (adjoin-set x set)
	(cond ((null? set) (make-tree x '() '()))
		((= x (entry set)) set)
		((< x (entry set))
			(make-tree (entry set)
				(adjoin-set x (left-branch set))
				(right-branch set)))
		((> x (entry set))
			(make-tree (entry set)
				(left-branch set)
				(adjoin-set x (right-branch set))))))

(define (tree->list tree)
	(define (copy-to-list tree result-list)
		(if (null? tree)
			result-list
			(copy-to-list (left-branch tree)
				(cons (entry tree)
					(copy-to-list (right-branch tree)
						result-list)))))
	(copy-to-list tree '()))

(define (list->tree elements)
	(car (partial-tree elements (length elements))))
(define (partial-tree elts n)
	(if (= n 0)
		(cons '() elts)
		(let ([left-size (quotient (- n 1) 2)])
			(let ([left-result (partial-tree elts left-size)])
				(let ([left-tree (car left-result)]
						[non-left-elts (cdr left-result)]
						[right-size (- n (+ left-size 1))])
					(let ([this-entry (car non-left-elts)]
							[right-result (partial-tree (cdr non-left-elts)
														right-size)])
						(let ([right-tree (car right-result)]
								[remaining-elts (cdr right-result)])
							(cons (make-tree this-entry left-tree right-tree)
								remaining-elts))))))))

(define (list-union-set set1 set2)
	(cond ((or (null? set1) (null? set2)) (append set1 set2))
		((< (car set1) (car set2))
			(cons (car set1) (list-union-set (cdr set1) set2)))
		((= (car set1) (car set2))
			(cons (car set1) (list-union-set (cdr set1) (cdr set2))))
		((> (car set1) (car set2))
			(cons (car set2) (list-union-set set1 (cdr set2))))))
(define (list-intersection-set set1 set2)
	(if (or (null? set1) (null? set2))
		'()
		(let ([x1 (car set1)] [x2 (car set2)])
			(cond ((= x1 x2)
					(cons x1
						(list-intersection-set (cdr set1) (cdr set2))))
				((< x1 x2)
					(list-intersection-set (cdr set1) set2))
				((< x2 x1)
					(list-intersection-set set1 (cdr set2)))))))

; main process
(define (tree-union-set set1 set2)
	(list->tree (list-union-set (tree->list set1) (tree->list set2))))
(define (tree-intersection-set set1 set2)
	(list->tree (list-intersection-set (tree->list set1) (tree->list set2))))

; run test
(define set1 (list->tree '(1 3 5 7 9 11)))
(define set2 (list->tree '(1 2 4 5 8 9 10 15)))

(tree-union-set set1 set2)
(tree-intersection-set set1 set2)
