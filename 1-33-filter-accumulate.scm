; filtered_accumulate 抽象
(define (filtered_accumulate combiner null_value term a next b filter)
	(cond ((> a b) null_value)
		((filter a) (combiner (term a) (filtered_accumulate combiner null_value term (next a) next b filter)))
		(else (filtered_accumulate combiner null_value term (next a) next b filter))
		))


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


; filtered_accumulate 构造prime_sum
(define (prime_sum a b)
	(define (combiner p1 p2)
		(+ p1 p2))
	(define (term p1) p1)
	(define (next p1) (+ p1 1))
	(define (filter p1)
		(if (prime? p1)
			#t
			#f))
	(filtered_accumulate combiner 0 term a next b filter))


; 运行测试
(prime_sum 2 7)