

; main process
(define (make-account balance secret-password)
	(define (withdraw amount)
		(if (>= balance amount)
			(begin (set! balance (- balance amount))
				balance)
			"insufficient founds"))
	(define (deposit amount)
		(set! balance (+ balance amount)))
	(define (dispatch input-secret-password operate)
		(cond ((not (eq? input-secret-password secret-password))
				(lambda (amount) "Incorrect password"))
			((eq? operate 'withdraw) withdraw)
			((eq? operate 'deposit) deposit)
			(else (error "unknown request -- MAKE-ACCOUNT" m))))
	dispatch)

; run test
(define acc (make-account 100 'wang))

((acc 'wang 'withdraw) 40)
((acc 'xing 'deposit) 50)

; output result
; 60
; "Incorrect password"