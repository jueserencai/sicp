(define (simpson f a b n)
	(define (add-h x) (+ x (/ (- b a) n)))

	(define (sum term a next b i)
		(if (> a b)
			0
			(+ (* (cond 
					((= i 1) 1)
					((= i n) 1)
					((= (remainder i 2) 0) 2)
					((= (remainder i 2) 1) 4)) 
				(term a))
				(sum term (next a) next b (+ i 1)))))


	(* (sum f a add-h b 0) 
		(/ (- b a) n 3)))


(define (cube x) (* x x x))

(simpson cube 0 1 100)
