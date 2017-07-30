

1 ]=> (define (show x)
          (display x)
          x)

;Value: show

1 ]=> (define x (stream-map show (stream-enumerate-interval 0 10))) ; 只有流的 stream-car 部分被求值(延迟求值的效果)
0
;Value: x

1 ]=> (stream-ref x 5)                                              ; 只计算所需的值，不多也不少(延迟求值的效果)
12345
;Value: 5

1 ]=> (stream-ref x 7)                                              ; 只需计算 6 和 7 ，没有重复计算(记忆性过程和延时求值的效果)
67
;Value: 7