

从定义来看， expand 每次生成 (* num radix) 除以 den 的商，然后将 (* num radix) 除以 den 的余数作为 num 参数，递归地调用 expand ：

;;; 58-expand.scm

(define (expand num den radix)
    (cons-stream
        (quotient (* num radix) den)
        (expand (remainder (* num radix) den) den radix)))
测试：

1 ]=> (load "58-expand.scm")

;Loading "58-expand.scm"... done
;Value: expand

1 ]=> (stream-head (expand 1 7 10) 20)

;Value 13: (1 4 2 8 5 7 1 4 2 8 5 7 1 4 2 8 5 7 1 4)

1 ]=> (stream-head (expand 3 8 10) 20)

;Value 14: (3 7 5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
quotient 返回两个除数之商，而 remainder 返沪两个除数之余：

1 ]=> (quotient 10 3)

;Value: 3

1 ]=> (remainder 10 3)

;Value: 1