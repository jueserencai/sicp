; accumulate 抽象
(define (accumulate combiner null_value term a next b)
	(if (> a b)
		null_value
		(combiner (term a) (accumulate combiner null_value term (next a) next b))))

; 用accumulate构造出sum
(define (sum term a next b)
	(define (combiner p1 p2)
		(+ p1 p2))
	(accumulate combiner 0 term a next b))
; 用sum 进行定积分
(define (integral f a b dx)
	(define (add_dx x) (+ x dx))
	(* (sum f (+ a (/ dx 2.0)) add_dx b)
		dx))
(define (cube x) (* x x x))

; 运行测试
(integral cube 0 1 0.01)
