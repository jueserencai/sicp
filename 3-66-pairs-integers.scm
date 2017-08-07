

这题可以这样来解：一直生成序对，直到遇到给定的序对为止（不包含给定的序对），然后计算已生成序对的数量。

为了达到生成序对并在合适的时候停止，需要一个 stream-take-while 函数：

;;; 66-stream-take-while.scm

(define (stream-take-while pred? stream)
    (if (stream-null? stream)
        '()
        (if (pred? (stream-car stream))
            (cons-stream (stream-car stream)
                         (stream-take-while pred? (stream-cdr stream)))
            '())))
测试：

1 ]=> (load "66-stream-take-while.scm")

;Loading "66-stream-take-while.scm"... done
;Value: stream-take-while

1 ]=> (load "p228-integers.scm")

;Loading "p228-integers.scm"...
;  Loading "p228-add-streams.scm"... done
;  Loading "p228-ones.scm"... done
;... done
;Value: integers

1 ]=> (stream->list
          (stream-take-while (lambda (x)
                                 (< x 10))
                             integers))

;Value 11: (1 2 3 4 5 6 7 8 9)
stream->list 可以将整个流转换成列表，作为一种方便的观察流的手段，非常有用。

计数 (1 100)
接着，载入 pairs ，对在 (1 100) 之前的序对进行计数：

1 ]=> (load "p237-pairs.scm")

;Loading "p237-pairs.scm"...
;  Loading "p237-interleave.scm"... done
;... done
;Value: pairs

1 ]=> (define before-1-100 (stream->list
                               (stream-take-while
                                   (lambda (pair)
                                       (not (equal? pair '(1 100))))
                                   (pairs integers integers))))

;Value: before-1-100

1 ]=> before-1-100

1 ]=> (length before-1-100)

;Value: 197
计数 (100 100)
然后对 (100 100) 之前的序对进行计数：

1 ]=> (define before-100-100 (stream->list
                                 (stream-take-while
                                     (lambda (pair)
                                         (not (equal? pair '(100 100))))
                                     (pairs integers integers))))

;Aborting!: maximum recursion depth exceeded
非常可惜，解释器的递归深度不足以支持这个计算，看来这个序列一定非常大。
