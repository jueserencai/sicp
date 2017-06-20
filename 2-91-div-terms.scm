#lang racket

(define (div-terms l1 l2)
	(if (empty-termlist? l1)
		(list (the-empty-termlist) (the-empty-termlist))
		(let ((t1 (firset-term l1))
				(t2 (firset-term l2)))
			(if (> (order t2) (order t1))
				(list (the-empty-termlist) l1)
				(let ((new-c (div (coeff t1) (coeff t2)))
						(new-o (- (order t1) (order t2))))
					(let ((rest-of-result
							(div-terms 
								(add-poly l1 
									(negate 
										(mul (adjoin-term (make-term new-o new-c) (the-empty-termlist)) l2))) l2)))
						(list (adjoin-term (make-term new-o new-c) (car rest-of-result)) (cadr rest-of-result))))))))

(define (div-poly p1 p2) 
  (if (same-variable? (variable p1) (variable p2)) 
      (let ((result (div-terms (term-list p1) 
                               (term-list p2)))) 
        (list (make-poly (variable p1) 
                         (car result)) 
              (make-poly (variable p1) 
                         (cadr result)))) 
      	(error "Variable is not the same -- DIV-POLY" (list (variable p1) (variable p2))))) 