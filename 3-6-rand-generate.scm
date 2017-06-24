; #lang racket

(define random-init 100000)
(define rand
	(let ((state random-init))
		(lambda (mode)
			(cond ((eq? mode 'generate) (random state))
				((eq? mode 'reset)
					(lambda (new-value)
						(set! state new-value)
						state))
				(else (error "unknown mode -- rand" mode))))))

(rand 'generate)
((rand 'reset) 6)
(rand 'generate)
