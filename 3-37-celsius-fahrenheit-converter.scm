

c+
c+ 的定义在练习中已经给出了：

;;; 37-c-add.scm

(define (c+ x y)
    (let ((sum (make-connector)))
        (adder x y sum)
        sum))
c-
根据公式 x+y=sum x+y=sum 、 sum−x=y sum−x=y 和 sum−y=x sum−y=x ，可以通过 adder 约束器来实现减法约束：

;;; 37-c-sub.scm

(define (c-sub x y)
    (let ((diff (make-connector)))
        (adder y diff x)
        diff))
c*
c* 的定义就是对 multiplier 约束器的简单包装：

;;; 37-c-mul.scm

(define (c* x y)
    (let ((product (make-connector)))
        (multiplier x y product)
        product))
c/
根据公式 p=q*r  p=q*r 、 r=p/q r=p/q 和 q=p/r q=p/r ，可以通过 multiplier 约束器来实现除法约束：

;;; 37-c-div.scm

(define (c/ p q)
    (let ((r (make-connector)))
        (multiplier q r p)
        r))


(define (cv x)
	(let ((z (make-connector)))
		(constant x z)
		z))