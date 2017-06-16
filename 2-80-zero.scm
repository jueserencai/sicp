#lang racket


; 需要在多个包中修改，代码过多，只列出每个包新增的代码

; ---------------------- complex 包：------------------------

;; 新增以下代码就行
    (put '=zero? '(complex)
        (lambda (x)
            (and (= (real-part x) 0)
                 (= (imag-part x) 0))))

    ;; =zero? 的另一种实现， magnitude  判断是否为0

    ; (put '=zero? '(complex)
    ;    (lambda (x)
    ;        (= (magnitude x) 0)))


; ---------------------- rational 包：------------------------

 ;; 新增
    (put '=zero? '(rational)
        (lambda (x)
            (= (numer x) 0)))


; ---------------------- scheme-number 包：------------------------

 ;; 新增
    (put '=zero? '(scheme-number)
        (lambda (x)
            (= x 0)))
