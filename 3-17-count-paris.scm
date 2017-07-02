
; 可以使用 eq? 判断对象的唯一性,利用 eq? 的这个特性，我们可以通过维持一个记录列表，然后遍历给定的序对结构，每当遇到一个序对时，判断它是否已经存在于记录列表，如果不存在就将它加进记录列表，并继续遍历这个序对的 car 和 cdr 部分，当给定的序对结构遍历完之后，记录列表的长度就是序对的真正个数。


; main process
(define (count-pairs x)
    (length (inner x '())))

(define (inner x memo-list)
    (if (and (pair? x)
             (not (memq x memo-list)))
        (inner (car x)
               (inner (cdr x)
                      (cons x memo-list)))
        memo-list))

; run test
(count-pairs (cons (cons 1 2) (cons 3 4)))
(count-pairs (list 1 2 3))
(count-pairs (let ((x (cons 1 2)))    ; 带有重复指针的序对
                     (cons x x)))

; result
; 3
; 3
; 2