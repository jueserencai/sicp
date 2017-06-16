#lang racket


; 需要在多个包中修改，代码过多，只列出每个包新增的代码

; ---------------------- complex 包：------------------------

;; 新增以下代码就行
    (put 'equ? '(complex complex)
        (lambda (x y)
            (and (= (real-part x) (real-part y))
                 (= (imag-part x) (imag-part y)))))

    ;; equ? 的另一种实现，对比 magnitude 和 angle

    ; (put 'equ? '(complex complex)
    ;    (lambda (x y)
    ;        (and (= (magnitude x) (magnitude x))
    ;             (= (angle x) (angle y)))))


; ---------------------- rational 包：------------------------

 ;; 新增
    (put 'equ? '(rational rational)
        (lambda (x y)
            (and (= (numer x) (numer y))
                 (= (denom x) (denom y)))))


; ---------------------- scheme-number 包：------------------------

 ;; 新增
    (put 'equ? '(scheme-number scheme-number)
        (lambda (x y)
            (= x y)))
