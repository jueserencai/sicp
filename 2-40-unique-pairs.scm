#lang racket 

; some base process
(define (accumulate op initial sequence)
	(if (null? sequence)
		initial
		(op (car sequence)
			(accumulate op initial (cdr sequence)))))
(define (flatmap proc seq)
	(accumulate append null (map proc seq)))
(define (make-pair-sum pair)
	(list (car pair) (cadr pair) (+ (car pair) (cadr pair))))
(define (prime-sum? pair)
	(prime? (+ (car pair) (cadr pair))))
; prime definition
(define (prime? n)
	(define (square n)
		(* n n))
	(define (expmod base exp m)
	  (cond ((= exp 0) 1)
	        ((even? exp)
	         	(remainder (square (expmod base (/ exp 2) m))
	                    m))
	        (else
	         	(remainder (* base (expmod base (- exp 1) m))
	                    m))))        
	(define (fermat-test n)
	  (define (try_it a)
	    (= (expmod a n n) a))
	  (try_it (+ 1 (random (- n 1)))))
	(define (fast-prime? n times)
	  (cond ((= times 0) true)
	        ((fermat-test n) (fast-prime? n (- times 1)))
	        (else false)))
	(fast-prime? n 10))
(define (enumerate-interval begin end)
	(define (iter result i)
		(if (> i end)
			result
			(iter (append result (list i)) (+ i 1))))
	(iter null begin))


; answer of the exercise 
; 书本 83 页的第一段代码其实就是 unique-pairs 的定义：
; (accumulate append
;             '()
;             (map (lambda (i)
;                      (map (lambda (j) (list i j))
;                           (enumerate-interval 1 (- i 1))))
;                  (enumerate 1 n)))
; 不过书本给出的这段代码并没有使用 flatmap 函数，我们将那这段代码改成使用 flatmap 的版本就行了：
(define (unique-pairs n)
	(flatmap (lambda (i) (map (lambda (j) (list i j))
								(enumerate-interval 1 (- i 1))))
				(enumerate-interval 1 n)))

; main process
(define (prime-sum-pairs n)
	(map make-pair-sum
		(filter prime-sum? (unique-pairs n))))

; run test
(prime-sum-pairs 10)
