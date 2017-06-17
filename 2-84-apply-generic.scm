#lang racket

(define (apply-generic op . args)
	;; raise s into t, if success, return s; else return #f 
	(define (raise-into s t) 
	    (let ((s-type (type-tag s)) 
	           (t-type (type-tag t))) 
	      (cond ((equal? s-type t-type) s) 
	            ((get 'raise (list s-type))  
	             	(raise-into ((get 'raise (list s-type)) (contents s)) t)) 
	            (else #f)))) 
    (let ((type-tags (map type-tag args)))
        (let ((proc (get op type-tags)))
            (if proc
                (apply proc (map contents args))
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

; http://community.schemewiki.org/?sicp-ex-2.84
; 这个网址有更多的实现方法，可以借鉴。