

(define (squarer a b)
    (define (process-new-value)
        (if (has-value? b)
            (if (< (get-value b) 0)
                (error "square less than 0 -- SQUARER" (get-value b))
                (set-value! a
                            (sqrt (get-value b))
                            me))
            (if (has-value? a)
                (set-value! b
                            (square (get-value a))
                            me)
                (error "Neither a nor b has value"))))
    (define (process-forget-value)
        (forget-value! a me)
        (forget-value! b me))
    (define (me request)
        (cond
            ((eq? request 'I-have-a-value)
                (process-new-value))
            ((eq? request 'I-lost-my-value)
                (process-forget-value))
            (else
                (error "Unknown request -- MULTIPLIER" request))))
    (connect a me)
    (connect b me)
    me)

注意， squarer 约束和书本给出的 adder 和 multiplier 约束都不同的地方是， squarer 只有两个连接器输入，因此在 process-forget-value 的最后，不必再调用 (process-new-value) ，否则就会出错（这肯定是作者设置的一个陷阱）。