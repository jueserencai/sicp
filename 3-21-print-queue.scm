练习 3.21
当解释器打印出 ((a b) b) 的时候，实际上是将 q1 变量的 car 和 cdr 部分都打印了出来，其中 car 的部分指向 (a b) ，而 cdr 部分指向 b ，这不仅暴露了队列的底层实现，而且还会让人造成误会（像 Louis 那样）。

要解决这个问题，我们可以使用一个只返回队列 car 部分的过程来作为打印队列中的值：

;;; 21-print-queue.scm

(define (print-queue queue)
    (car queue))
测试：

1 ]=> (load "p181-queue.scm")

;Loading "p181-queue.scm"... done
;Value: delete-queue!

1 ]=> (load "21-print-queue.scm")

;Loading "21-print-queue.scm"... done
;Value: print-queue

1 ]=> (define q1 (make-queue))

;Value: q1

1 ]=> (print-queue q1)

;Value: ()

1 ]=> (insert-queue! q1 'a)

;Value 13: ((a) a)

1 ]=> (print-queue q1)

;Value 14: (a)

1 ]=> (insert-queue! q1 'b)

;Value 13: ((a b) b)

1 ]=> (print-queue q1)

;Value 14: (a b)

1 ]=> (delete-queue! q1)

;Value 13: ((b) b)

1 ]=> (print-queue q1)

;Value 15: (b)

1 ]=> (delete-queue! q1)

;Value 13: (() b)

1 ]=> (print-queue q1)

;Value: ()
可以看到，在队列为空、新元素入队和前端元素出队这三种情况下， print-queue 都可以正确地打印队列中的元素。

(实际上，打印是由解释器完成的， print-queue 只是负责将队列中合适的部分返回给解释器而已。）

讨论 
blog comments powered by Disqus
indexSICP 解题集 »
© Copyright 2014, huangz1990. Last updated on May 03, 2017. Created using Sphinx 1.5.3.
  v: latest 