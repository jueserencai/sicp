; 素数检测
(define (prime? n)
	(fast_prime? n 10))

(define (fast_prime? n times)
  (cond ((= times 0) true)
        ((fermat_test n) (fast_prime? n (- times 1)))
        (else false)))
(define (fermat_test n)
  (define (try_it a)
    (= (expmod a n n) a))
  (try_it (+ 1 (random (- n 1)))))

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         	(remainder (square (expmod base (/ exp 2) m))
                    m))
        (else
         	(remainder (* base (expmod base (- exp 1) m))
                    m))))  

(define (cha))      

(define (square n)
  (* n n))