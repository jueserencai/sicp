
练习 3.52
先载入所需的过程：

1 ]=> (load "p222-display-stream.scm")

;Loading "p222-display-stream.scm"... done
;Value: display-line

1 ]=> (load "p223-stream-enumerate-interval.scm")

;Loading "p223-stream-enumerate-interval.scm"... done
;Value: stream-enumerate-interval
定义 sum 和 accum ：

1 ]=> (define sum 0)

;Value: sum

1 ]=> (define (accum x)
          (set! sum (+ x sum))
          sum)

;Value: accum
从 sum 的值可以看出，在定义 seq 的时候，只有 1 被求值了：

1 ]=> (define seq (stream-map accum (stream-enumerate-interval 1 20)))

;Value: seq

1 ]=> sum

;Value: 1
从 sum 的值可以看出，在定义 y 的时候， seq 的求值进行到了 3 就停止了，因为 3 是 stream-filter 遇到的第一个非偶数值，其中 sum = 1 + 2 + 3 = 6 ：

1 ]=> (define y (stream-filter even? seq))

;Value: y

1 ]=> sum

;Value: 6
从 sum 的值可以看出，在定义 z 的时候， seq 的求值进行到 4 就停止了，这时 sum = 1 + 2 + 3 + 4 = 10 ：

1 ]=> (define z (stream-filter (lambda (x)
                                   (= (remainder x 5) 0))
                               seq))

;Value: z

1 ]=> sum

;Value: 10
调用 (stream-ref y 7) 会让 y 被强迫求值，一直到第七个元素为止，这时 sum 也被设为了 (stream-ref y 7) 的值：

1 ]=> (stream-ref y 7)

;Value: 136

1 ]=> sum

;Value: 136
使用 display-stream 会强迫整个流求值：

1 ]=> (display-stream z)

10
15
45
55
105
120
190
210
;Unspecified return value

1 ]=> sum

;Value: 210
最后的问题是，如果将 (delay <exp) 的实现从 memo-proc 改为 (lambda () <exp>) ，会发生什么变化？

答案是，如果不使用记忆过程的话，那么对 seq 流的求值就会产生重复计算，而每次重复对 seq 的流的求值，都会引起 accum 过程的调用，结果会产生一个很不相同的 sum 值。

举个例子，即使再次调用 (display-stream z) ，这里的 sum 值也不会改变，但如果是没有使用记忆过程的 delay 实现，那么 sum 的值将会变成 420 ：

1 ]=> (display-stream z)

10
15
45
55
105
120
190
210
;Unspecified return value

1 ]=> sum

;Value: 210
