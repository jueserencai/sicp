#lang racket


(define (make-tree entry left right)
	(list entry left right))


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

; run test
(list->tree '(1 3 5 7 9 11))
; 		  5
; 	 1		  9
;'()   3	7	11

; list->tree 将调用 partial-tree ，而 partial-tree 每次将输入的列表分成两半（右边可能比左边多一个元素，用作当前节点），然后组合成一个平衡树。

; The order of growth in the number of steps required by list->tree
; to convert a list of n elements is big-theta(log(n)).
; This results from halving the input with each recursive call which is 
; the distinguishing characteristic of logarithmic growth.