

(define (ripple-carry-adder list-A list-B list-S C)
    (define (iter A B S value-of-c)
        (if (and (null? A) (null? B) (null? S))
            'ok
            (let ((Ak (car A))
                  (Bk (car B))
                  (Sk (car S))
                  (remain-A (cdr A))
                  (remain-B (cdr B))
                  (remain-S (cdr S))
                  (Ck (make-wire)))
                (set-signal! Ck value-of-c)
                (full-adder Ak Bk Ck Sk C)
                (iter remain-A remain-B remain-S (get-signal C)))))
    (iter list-A list-B list-S (get-signal C)))


ripple-carry-adder 的延迟
每个 ripple-carry-adder 由一个 full-adder 组成；而每个 full-adder 又由两个 half-adder 和一个 or-gate 组成；而每个 half-adder 又由一个 or-gate ，一个 inveter 以及两个 and-gate 组成。

根据以上关系，可以计算出 ripple-carry-adder-delay ：

ripple-carry-adder = full-adder-delay
                   = or-gate-delay + 2 * (half-adder-delay)
                   = or-gate-delay + 2 * (or-gate-delay + inveter-delay + (2 * and-gate-delay))
                   = or-gate-delay + (2 * or-gate-delay) + (2 * inveter-delay) + (4 * and-gate-delay)
                   = (3 * or-gate-delay) + (2 * inveter-delay) + (4 * and-gate-delay)
最后的结果表示， ripple-carry-adder-delay 的值为三个 or-gate-delay 、两个 inveter-delay 和四个 and-gate-delay 之和。

因此，计算 N 位二进制之和所需的延迟为 N * ripple-carry-adder-delay 。