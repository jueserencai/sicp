

; main process
(define (mystery x)
    (define (loop x y)
        (if (null? x)
            y
            (let ((temp (cdr x)))
                (set-cdr! x y)
                (loop temp x))))
    (loop x '()))

; run test
(define v (list 'a 'b 'c))
(define w (mystery v))
(display w)

; result
; (c b a)