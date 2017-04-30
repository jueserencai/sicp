;;;;常用定义
; 平方
(define (square n)
		(* n n))

; 计算base的exp次幂 对m取模的结果
(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         	(remainder (square (expmod base (/ exp 2) m))
                    m))
        (else
         	(remainder (* base (expmod base (- exp 1) m))
                    m))))


; 主体 
(define (test_carmichael n)
	; 测试小于n的所有a，逆序测试
	(define (test_iter a n)
		(cond ((= a 0) 
				#t)
			((= (expmod a n n) a) 
				(test_iter (- a 1) n))
			(else 
				#f)))
	(test_iter (- n 1) n))

; 执行
(test_carmichael 561)
(test_carmichael 1104)
(test_carmichael 1105)
