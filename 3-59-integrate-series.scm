

a)
integrate-series 的定义非常直接：接受一个流 a0,a1,a2,…a0,a1,a2,… ，返回另一个流 a0,(12)a1,(13)a2,(14)a3,…a0,(12)a1,(13)a2,(14)a3,… 。

流的每个元素 (1i)ai−1(1i)ai−1 的乘积可以用 mul-streams 计算得出，另外还需要一个 div-streams 过程来定义流 11,12,13,…11,12,13,… ，它的定义如下：

;;; 59-div-streams.scm

(define (div-streams s1 s2)
    (stream-map / s1 s2))
然后使用 ones 、 integers 和 div-streams 定义流 11,12,13,…11,12,13,… ：

1 ]=> (load "59-div-streams.scm")

;Loading "59-div-streams.scm"... done
;Value: div-streams

1 ]=> (load "p228-ones.scm")

;Loading "p228-ones.scm"... done
;Value: ones

1 ]=> (load "p228-integers.scm")

;Loading "p228-integers.scm"...
;  Loading "p228-add-streams.scm"... done
;  Loading "p228-ones.scm"... done
;... done
;Value: integers

1 ]=> (stream-head (div-streams ones integers) 10)

;Value 11: (1 1/2 1/3 1/4 1/5 1/6 1/7 1/8 1/9 1/10)
最后，给出 integrate-series 的定义：

;;; 59-integrate-series.scm

(load "54-mul-streams.scm")
(load "59-div-streams.scm")
(load "p228-ones.scm")
(load "p228-integers.scm")

(define (integrate-series a)
    (mul-streams a                                  ; a0, a1, a2, ...
                 (div-streams ones integers)))      ; 1/1, 1/2, 1/3, ...


b

(define sine-series (cons-stream 0 (integrate-series cosine-series)))
(define cosine-series (cons-stream 1 (integrate-series (scale-stream sine-series -1))))