#lang racket
;; 无穷连分式

; process
(define (cont_frac n d k)
	(define (cont_frac_iter i)
		(if (= i k)
			(/ (n i) (d i))
			(/ (n i) (+ (d i) (cont_frac_iter (+ i 1))))))
	(cont_frac_iter 1))

;; 37
#| ; test run 
(cont_frac (lambda (i) 1.0)
	(lambda (i) 1.0)
	10) |#

#| ; obtain the k for 4 bit precision
(define (accuracy double)
	(define (get_phai k)
		(/ 1.0 (cont_frac (lambda (i) 1.0)
					(lambda (i) 1.0)
					k)))
	(define (iter i)
		; (if (< (abs (- (cont_frac n d i) (cont_frac n d (+ i 1)))) double)
			; (+ i 1)
		(if (< (abs (- (get_phai i) 1.6180)) double)
			i
			(iter (+ i 1))))
	(iter 5))
(accuracy 0.00005) |#

;; 38
; i 除以 3，商a，余b。若b != 2，则D为1；否则，D为2*(a+1)
(cont_frac (lambda (i) 1.0)
	(lambda (i) (if (= (remainder i 3) 2)
					(* 2 (+ 1 (quotient i 3)))
					1))
	10)

