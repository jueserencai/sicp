#lang racket
(define tolerance 0.00001)

; 不动点fixed_point
(define (fixed_point f first_guess)
	(define (close_enough? v1 v2)
		(< (abs (- v1 v2)) tolerance))
	(define (try guess)
		#| ; 打印近似值序列
		(newline)
		(display guess) |#

		(let ((next (f guess)))
			(if (close_enough? guess next)
				next
				(try next))))
	(try first_guess))

; 黄金分割率
;(fixed_point (lambda (x) (+ 1.0 (/ 1.0 x))) 1.0)

; 方程 x^x = 1000 求得一个根x
; 不使用平均阻尼, 结果计算步数 34次
(fixed_point (lambda (x) (/ (log 1000.0) (log x))) 1.5)
; 使用平均阻尼 结果计算步数 10次
(fixed_point (lambda (x) (/ (+ x (/ (log 1000.0) (log x))) 2)) 1.5)

