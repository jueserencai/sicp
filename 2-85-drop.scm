#lang racket

; 放在complex包中
(put 'project '(complex)
	(lambda (z)
		(make-real (real-part z))))

; 放在real包中
(put 'project 'real 
    (lambda (x)  
        (let ((rat (rationalize  
                   		(inexact->exact x) 1/100))) 
          	(make-rational 
	            (numerator rat) 
	            (denominator rat))))) 

; 放在rational包中
(put 'project 'rational
	(lambda (x)
		(make-integer (numer x)))) 


(define (apply-generic op . args)
	;; raise s into t, if success, return s; else return #f 
	(define (raise-into s t) 
	    (let ((s-type (type-tag s)) 
	           (t-type (type-tag t))) 
	      (cond ((equal? s-type t-type) s) 
	            ((get 'raise (list s-type))  
	             	(raise-into ((get 'raise (list s-type)) (contents s)) t)) 
	            (else #f)))) 
	; drop
	(define (drop x) 
	  	(let ((project-proc (get 'project (type-tag x)))) 
	    	(if project-proc 
		      	(let ((project-number (project-proc (contents x)))) 
			        (if (equ? x (raise project-number)) 
			          	(drop project-number) 
			          	x)) 
		    	x))) 

    (let ((type-tags (map type-tag args)))
        (let ((proc (get op type-tags)))
            (if proc
            	; 添加drop，将结果尽可能下降。
                (drop (apply proc (map contents args)))
                (if (= (length args) 2)
                    (let ((type1 (car type-tags))
                          (type2 (cadr type-tags))
                          (a1 (car args))
                          (a2 (cadr args)))
                        (if (equal? type1 type2)
                            (error "No method for these types" (list op type-tags)) ; 
                            ; 修改的部分
                            (cond  
			                   ((raise-into a1 a2) 
			                    	(apply-generic op (raise-into a1 a2) a2)) 
			                   ((raise-into a2 a1) 
			                    	(apply-generic op a1 (raise-into a2 a1))) 
			                   (else (error "No method for these types" 
			                         (list op type-tags))))))
                    (error "No method for these types"
                            (list op type-tags)))))))