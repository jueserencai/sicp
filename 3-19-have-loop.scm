
使用常量空间判断列表是否有环的算法可以很容易地在网络上找到，算法的核心思想是这样的：

使用两个变量，一个变量以步长为 1 遍历列表，另一个变量以步长为 2 遍历列表，每次在两个变量移动之后对比它们，如果两个变量相遇，那么列表有环；如果能走完整个列表（遇到 '() ），那么列表没有环。

以下是这一算法相应的过程定义：

;;; 19-loop.scm

(define (loop? lst)
    (define (iter x y)
        (let ((x-walk (list-walk 1 x))
              (y-walk (list-walk 2 y)))
            (cond ((or (null? x-walk) (null? y-walk))
                    #f)
                  ((eq? x-walk y-walk)
                    #t)
                  (else
                    (iter x-walk y-walk)))))
    (iter lst lst))

(define (list-walk step lst)
    (cond ((null? lst)
            '())
          ((= step 0)
            lst)
          (else
            (list-walk (- step 1)
                       (cdr lst)))))
测试：

1 ]=> (load "19-loop.scm")

;Loading "19-loop.scm"... done
;Value: list-walk

1 ]=> (loop? (list 1 2 3))

;Value: #f

1 ]=> (define circular-list (list 1 2 3))

;Value: circular-list

1 ]=> (set-cdr! (last-pair circular-list) circular-list)

;Unspecified return value

1 ]=> (loop? circular-list)

;Value: #t
讨论 
blog comments powered by Disqus
indexSICP 解题集 »
© Copyright 2014, huangz1990. Last updated on May 03, 2017. Created using Sphinx 1.5.3.
  v: latest 