; #lang racket

; 素数检测
(define (prime? n)
	(fast_prime? n 10))

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
(define (fermat_test n)
  (define (try_it a)
    (= (expmod a n n) a))
  (try_it (+ 1 (random (- n 1)))))
(define (fast_prime? n times)
  (cond ((= times 0) true)
        ((fermat_test n) (fast_prime? n (- times 1)))
        (else false)))


; 判断是否是素数，若是则打印星号和执行时间
(define (timed_prime_test n)
	(define (start_prime_test start_time)
	  	(and (prime? n)
	            (report_prime (- (runtime) start_time))))
	(define (report_prime elapsed_time)
		(newline)
		(display n)
		(display " *** ")
		(display elapsed_time))
	(start_prime_test (runtime)))


; 查找大于n 的素数中，最小的count个
(define (search_for_primes n count)
	(cond ((= count 0) )
		((timed_prime_test n) (search_for_primes (+ n 1) (- count 1)))
		(else (search_for_primes (+ n 1) count))))

; 执行
; 1-22
(search_for_primes 10000000000 3)
(search_for_primes 100000000000 3)
(search_for_primes 1000000000000 3)

; ; 1-24
; (search_for_primes 10000000000 3)
; (search_for_primes 100000000000000000000 3)




; 测试
; (define (circle n)
; 	(cond ((< n 0)
; 		0)
; 		(else (circle (- n 1)))))
; (display (runtime))
; 	(newline)
; (circle 666666)
; (display (runtime))
; 	(newline)
; (circle 666666)
; (display (runtime))