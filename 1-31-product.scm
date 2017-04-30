; 求积过程
(define (product term a next b)
	(if (> a b)
		1
		(* (term a)
			(product term (next a) next b))))
; 计算π/4的公式中 当前位置返回的数值
(define (term i)
	; 偶数
	(if (= (remainder i 2) 0)
		(/ (+ i 2) (+ i 1.0))
		(/ (+ i 1) (+ i 2.0))))
 
; 计算π/4 
(define (factorial_product n)
	(define (next i) 
		(+ i 1))
	(product term 1 next n))

; 运行测试
(factorial_product 10)