

按照练习的提示，将 s 的定义补充完整：

;;; 56-s.scm

(load "p229-scale-stream.scm")
(load "56-merge.scm")

(define s (cons-stream 1 
                       (merge (scale-stream s 2)
                              (merge (scale-stream s 3)
                                     (scale-stream s 5)))))

以上的数都能够被 2 、 3 或者 5 整除。

另外值得一提的是， merge 过程和我们在书本 105 页看过的 intersection-set 过程共享着一个非常相似的模型，最大的区别就是两个过程一个使用列表，另一个使用流。