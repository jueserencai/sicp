#lang racket

; base process
(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
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
; main process
(define (key record)
	(car record))
(define (lookup given-key tree-of-records)
    (if (null? tree-of-records)                                             ; 数据库为空，查找失败
        #f
        (let ((entry-key (key (entry tree-of-records))))                    ; 获取当前节点的键
            (cond ((= given-key entry-key)                                  ; 对比当前节点的键和给定的查找键
                    (entry tree-of-records))                                ; 决定查找的方向
                  ((> given-key entry-key)
                    (lookup given-key (right-branch tree-of-records)))
                  ((< given-key entry-key)
                    (lookup given-key (left-branch tree-of-records)))))))

; run test
(define x1 (list->tree '((1 "ke1") (3 "ke3") (5 "ke5") (7 "ke7") (9 "ke9") (11 "k11"))))
(lookup 3 x1)