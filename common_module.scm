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