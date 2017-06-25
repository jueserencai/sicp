

; main process
(define (make-account balance secret-password)
	(define (withdraw amount)
		(if (>= balance amount)
			(begin (set! balance (- balance amount))
				balance)
			"insufficient founds"))
	(define (deposit amount)
		(begin (set! balance (+ balance amount))
			balance))

	(define (dispatch input-secret-password operate)
		(cond ((not (eq? input-secret-password secret-password))
				(lambda (amount) "Incorrect password"))
			((eq? operate 'withdraw) withdraw)
			((eq? operate 'deposit) deposit)
			(else (error "Unknown request -- MAKE-ACCOUNT" m))))
	dispatch)

(define (make-joint acc password new-password)
	(lambda (given-password mode)
		(if (eq? given-password new-password)
			(acc password mode)
			(lambda (x) (display "Incorrect another password")))))

; run test
(define acc (make-account 100 'wang))
(define joint-acc (make-joint acc 'wang 'xing))

((acc 'wang 'withdraw) 40)
((joint-acc 'xing 'deposit) 50)

; output result
; 60
; 110