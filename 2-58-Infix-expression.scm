#lang racket

(define (deriv exp var)
	(define (variable? x) (symbol? x))

	(define (same-variable? v1 v2)
		(and (variable? v1) (variable? v2) (eq? v1 v2)))
	(define (=number? exp num)
		(and (number? exp) (= exp num)))

	(define (sum? x)
		(and (pair? x) (eq? (cadr x) '+)))	;修改
	(define (addend s) (car s))	;修改
	(define (augend s) (caddr s))	;修改
	; (define (augend s)
	; 	(if (null? (cdddr s))
	; 		(caddr s)
	; 		(list '+ (caddr s) (cadddr s))))
	(define (make-sum a1 a2)
		(cond ((=number? a1 0) a2)
			((=number? a2 0) a1)
			((and (number? a1) (number? a2)) (+ a1 a2))
			(else (list a1 '+ a2))))	;修改

	(define (product? x)
		(and (pair? x) (eq? (cadr x) '*)))	;修改
	(define (multiplier p) (car p))	;修改
	(define (multiplicand p) (caddr p))	;修改
	; (define (multiplicand p)
	; 	(if (null? (cdddr p))
	; 		(caddr p)
	; 		(list '* (caddr p) (cadddr p))))
	(define (make-product m1 m2)
		(cond ((or (=number? m1 0) (=number? m2 0)) 0)
			((=number? m1 1) m2)
			((=number? m2 1) m1)
			((and (number? m1) (number? m2)) (* m1 m2))
			(else (list m1 '* m2))))	;修改

	(define (exponentiation? x)
		(and (pair? x) (eq? (cadr x) '**)))	;修改
	(define (base e) (car e))	;修改
	(define (exponent e) (caddr e))	;修改
	(define (make-exponentiation b e)
		(cond ((=number? e 0) 1)
			((=number? e 1) b)
			(else (list b '** e))))	;修改

	(cond ((number? exp) 0)
		((variable? exp)
			(if (same-variable? exp var) 1 0))
		((sum? exp)
			(make-sum (deriv (addend exp) var)
					(deriv (augend exp) var)))
		((product? exp)
			(make-sum
				(make-product (multiplier exp)
					(deriv (multiplicand exp) var))
				(make-product (deriv (multiplier exp) var)
					(multiplicand exp))))
		((exponentiation? exp)
			(make-product
				(exponent exp)
				(make-product
					(make-exponentiation (base exp) (- (exponent exp) 1))
					(deriv (base exp) var))))
		(else
			(error "unknown expression type -- DERIV" exp))))

; run test
(deriv '(x + (3 * (x + (y + 2)))) 'x)


; b
; 如果允许使用标准代数写法的话，那么我们就没办法只是通过修改谓词、选择函数和构造函数来达到正确计算求导的目的，因为这必须要修改 deriv 函数，提供符号的优先级处理功能。

; 比如说，对于输入 x + y * z ，有两种可能的求导顺序会产生（称之为二义性文法），一种是 (x + y) * z ，另一种是 x + (y * z) ；对于求导计算来说，后一种顺序才是正确的，但是这种顺序必须通过修改 deriv 来提供，只是修改谓词、选择函数和构造函数是没办法达到调整求导顺序的目的的。