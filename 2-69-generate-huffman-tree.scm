#lang racket

; base process
(define (make-leaf symbol weight)
	(list 'leaf symbol weight))
(define (leaf? object)
	(eq? (car object) 'leaf))
(define (symbol-leaf x) (cadr x))
(define (weight-leaf x) (caddr x))

(define (make-code-tree left right)
	(list left
		right
		(append (symbols left) (symbols right))
		(+ (weight left) (weight right))))
(define (left-branch tree) (car tree))
(define (right-branch tree) (cadr tree))
(define (symbols tree)
	(if (leaf? tree)
		(list (symbol-leaf tree))
		(caddr tree)))
(define (weight tree)
	(if (leaf? tree)
		(weight-leaf tree)
		(cadddr tree)))

(define (adjoin-set x set)
	(cond ((null? set) (list x))
		((< (weight x) (weight (car set))) (cons x set))
		(else (cons (car set)
					(adjoin-set x (cdr set))))))
(define (make-leaf-set pairs)
	(if (null? pairs)
		'()
		(let ([pair (car pairs)])
			(adjoin-set (make-leaf (car pair)
									(cadr pair))
						(make-leaf-set (cdr pairs))))))

; main process
(define (generate-huffman-tree pairs)
	(successive-merge (make-leaf-set pairs)))
(define (successive-merge ordered-set)
    (cond ((= 0 (length ordered-set))
            '())
          ((= 1 (length ordered-set))
            (car ordered-set))
          (else
            (let ((new-sub-tree (make-code-tree (car ordered-set)
                                                (cadr ordered-set)))
                  (remained-ordered-set (cddr ordered-set)))
                (successive-merge (adjoin-set new-sub-tree remained-ordered-set))))))

; run test
(define set1 '((A 4) (B 2) (C 1) (D 1)))
(generate-huffman-tree set1)