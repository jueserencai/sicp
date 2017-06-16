#lang racket

; 放在scheme-number包中
(put 'raise '(scheme-number)
	(lambda (n)
		((get 'make 'rational) n 1)))

; 放在rational包中
(put 'raise '(rational)
	(lambda (x)
		((get 'make 'real) (/ (numer x) (denom x)))))

; 放在real包中
(put 'raise '(real)
	(lambda (x)
		((get 'make-from-real-imag 'complex) x 0)))