#lang racket

; composite data define
(define (make_mobile left right)
	(list left right))
(define (make_branch the_length structure)
	(list the_length structure))

; composite data operator
(define (left_branch mobile)
	(car mobile))
(define (right_branch mobile)
	(cadr mobile))
(define (branch_length branch)
	(car branch))
(define (branch_structure branch)
	(cadr branch))

; return the total weight of the mobile
(define (total_weight mobile)
	; get the weight of branch
	(define (weight branch)
		(let ((right (branch_structure branch)))
			(if (pair? right) 
				(+ (weight (left_branch right)) (weight (right_branch right)))
				right)))
	; the weight of left branch add the weight of right branch  
	(+ (weight (left_branch mobile)) (weight (right_branch mobile))))

(define (balance? mobile)
	(define (momental branch)
		(let ((structure (branch_structure branch)))
			(if (not (pair? structure))
				(* (branch_length branch) structure)
				(* (branch_length branch) (total_weight structure)))))
	(define (balance_mo? mobile_iter)
		(let ((left (left_branch mobile_iter))
				(right  (right_branch mobile_iter)))
			(and (= (momental left) (momental right))
				(balance_br? left)
				(balance_br? right))))
	(define (balance_br? branch)
		(if (pair? (branch_structure branch))
			(balance_mo? (branch_structure branch))
			#t))
	(balance_mo? mobile))


; run test
(define a (make_branch 5 4))
(define b (make_branch 4 5))
(define x (make_mobile a b))
(define c (make_branch 6 x))
(define e (make_branch 9 6))
(define y (make_mobile c e))
(newline)
(display y)
(newline)
(total_weight y)
(newline)
(balance? y)