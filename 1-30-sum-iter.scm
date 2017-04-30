; 修改过的迭代的加和过程
(define (sum term a next b)
	(define (iter a result)
		(if (> a b)
			result
			(iter (next a) (+ result (term a)))))
	(iter a 0))


; 测试
(define (integral f a b dx)
	(define (add-dx x) (+ x dx))
	(* (sum f (+ a (/ dx 2.0)) add-dx b)
		dx))
(define (cube x) (* x x x))
(integral cube 0 1 0.01)