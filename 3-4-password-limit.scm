

; main process
(define (make-account balance secret-password)
	(define password-limit 7)
	(define password-incorrect-times 0)
	(define (increase-incorrect-times)
		(set! password-incorrect-times (+ 1 password-incorrect-times)))
	(define (reset-password-incorrect-times) 
		(set! password-incorrect-times 0))
	(define (call-the-cops)
		"call-the-cops")

	(define (withdraw amount)
		(if (>= balance amount)
			(begin (set! balance (- balance amount))
				balance)
			"insufficient founds"))
	(define (deposit amount)
		(set! balance (+ balance amount)))

	(define (dispatch input-password operate)
		(cond ((not (eq? input-password secret-password))
				(lambda (amount)
					(begin (increase-incorrect-times)
						(cond ((< password-incorrect-times password-limit)
									"Incorrect password")
							(else (call-the-cops))))))
			(else
				(begin
					(if (> password-incorrect-times 0)
						(reset-password-incorrect-times))
					(cond 
						((eq? operate 'withdraw) withdraw)
						((eq? operate 'deposit) deposit)
						(else (error "unknown request -- MAKE-ACCOUNT" m)))))))
	dispatch)

; run test
(define acc (make-account 100 'wang))
; 情形一，连续7次错误密码后，call-the-cops
((acc 'wang 'withdraw) 1)
((acc 'xing 'deposit) 50)
((acc 'xing 'deposit) 50)
((acc 'xing 'deposit) 50)
((acc 'xing 'deposit) 50)
((acc 'xing 'deposit) 50)
((acc 'xing 'deposit) 50)
((acc 'xing 'deposit) 50)
((acc 'xing 'deposit) 50)
; 情形二，连续错误密码次数没有超过7次，则重置了错误次数。
((acc 'wang 'withdraw) 1)
((acc 'xing 'deposit) 50)
((acc 'xing 'deposit) 50)
((acc 'xing 'deposit) 50)
((acc 'xing 'deposit) 50)
((acc 'xing 'deposit) 50)
((acc 'wang 'withdraw) 1)
((acc 'xing 'deposit) 50)
((acc 'xing 'deposit) 50)
((acc 'xing 'deposit) 50)

; output result

; 99
; "Incorrect password"
; "Incorrect password"
; "Incorrect password"
; "Incorrect password"
; "Incorrect password"
; "Incorrect password"
; "call-the-cops"
; "call-the-cops"

; 98
; "Incorrect password"
; "Incorrect password"
; "Incorrect password"
; "Incorrect password"
; "Incorrect password"
; 97
; "Incorrect password"
; "Incorrect password"
; "Incorrect password"
