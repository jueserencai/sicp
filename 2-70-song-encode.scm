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

(define (encode message tree)
	(if (null? message)
		'()
		(append (encode-symbol (car message) tree)
			(encode (cdr message) tree))))
(define (encode-symbol symbol tree)
	(define (encode-iter current-tree result)
		(cond ((null? current-tree) false)
			((not (leaf? current-tree))
				(let ([left-result (encode-iter (left-branch current-tree) (append result '(0)))]
						[right-result (encode-iter (right-branch current-tree) (append result '(1)))])
					(if (eq? false left-result)
						right-result
						left-result)))
			(else (if (eq? symbol (symbol-leaf current-tree))
						result
						false))))
	(encode-iter tree '()))

; run test
(define song-character-set '((A 2) (NA 16) (BOOM 1) (SHA 3) (GET 2) (YIP 9) (JOB 2) (WAH 1)))
(define song-huffman-tree (generate-huffman-tree song-character-set))
(define song '(GET A JOB SHA NA NA NA NA NA NA NA NA GET A JOB SHA NA NA NA NA NA NA NA NA WAH YIP YIP YIP YIP YIP YIP YIP YIP YIP SHA BOOM))

(display song-huffman-tree)
; ((leaf NA 16) ((leaf YIP 9) (((leaf A 2) ((leaf WAH 1) (leaf BOOM 1) (WAH BOOM) 2) (A WAH BOOM) 4) ((leaf SHA 3) ((leaf JOB 2) (leaf GET 2) (JOB GET) 4) (SHA JOB GET) 7) (A WAH BOOM SHA JOB GET) 11) (YIP A WAH BOOM SHA JOB GET) 20) (NA YIP A WAH BOOM SHA JOB GET) 36)

(encode song song-huffman-tree)
; the '*' separate the two word
; '(1  1  1  1  1*  1  1  0  0*  1  1  1  1  0*  1  1  1  0*  0*  0*  0*  0*  0*  0*  0*  0*  1  1  1  1  1*  1  1  0  0*  1  1  1  1  0*  1  1  1  0*  0*  0*  0*  0*  0*  0*  0*  0*  1  1  0  1  0*  1  0*  1  0*  1  0*  1  0*  1  0*  1  0*  1  0*  1  0*  1  0*  1  1  1  0*  1  1  0  1  1)