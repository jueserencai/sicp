

(define (last-pair x)
    (if (null? (cdr x))
        x
        (last-pair (cdr x))))

; main process
(define (make-cycle x)
    (set-cdr! (last-pair x) x)
    x)

; run test
(define z (make-cycle (list 'a 'b 'c)))
(display z)
; result
; #0=(a b c . #0#)

;          +-----------------------+
;          |                       |
;          v                       |
; z ----> [*]----> [*]----> [*]----+
;          |        |        |
;          v        v        v
;         'a       'b       'c