indexSICP 解题集 »
练习 3.26
题目要求我们给出一个使用树作为底层实现的查找表过程，这和 练习 2.66 很相似，不过自第三章以来，有很多新知识都可以用到这个练习上，比如消息传递和闭包，因此没有必要受限于 练习 2.66 里给出的形式，我们可以给出一个实现得更好的表过程。

树
首先给出树的定义：

;;; 26-tree.scm

; constructor

(define (make-tree key value left-branch right-branch)
    (list key value left-branch right-branch))

; selector

(define (tree-key tree)
    (car tree))

(define (tree-value tree)
    (cadr tree))

(define (tree-left-branch tree)
    (caddr tree))

(define (tree-right-branch tree)
    (cadddr tree))

(define (tree-empty? tree)
    (null? tree))

; setter

(define (tree-set-key! new-key tree)
    (set-car! tree new-key))

(define (tree-set-value! new-value tree)
    (set-car! (cdr tree) new-value))

(define (tree-set-left-branch! new-left-branch tree)
    (set-car! (cddr tree) new-left-branch))

(define (tree-set-right-branch! new-right-branch tree)
    (set-car! (cdddr tree) new-right-branch))

; operator

(define (tree-insert! tree given-key value compare)
    (if (tree-empty? tree)
        (make-tree given-key value '() '())
        (let ((compare-result (compare given-key (tree-key tree))))
            (cond ((= 0 compare-result)
                    (tree-set-value! value tree)
                    tree)
                  ((= 1 compare-result)
                    (tree-set-right-branch!
                        (tree-insert! (tree-right-branch tree) given-key value compare)
                        tree)
                    tree)
                  ((= -1 compare-result)
                    (tree-set-left-branch!
                        (tree-insert! (tree-left-branch tree) given-key value compare)
                        tree)
                    tree)))))

(define (tree-search tree given-key compare)
    (if (tree-empty? tree)
        '()
        (let ((compare-result (compare given-key (tree-key tree))))
            (cond ((= 0 compare-result)
                    tree)
                  ((= 1 compare-result)
                    (tree-search (tree-right-branch tree) given-key compare))
                  ((= -1 compare-result)
                    (tree-search (tree-left-branch tree) given-key compare))))))

; comparer

(define (compare-string x y)
    (cond ((string=? x y)
            0)
          ((string>? x y)
            1)
          ((string<? x y)
            -1)))

(define (compare-symbol x y)
    (compare-string (symbol->string x)
                    (symbol->string y)))

(define (compare-number x y)
    (cond ((= x y)
            0)
          ((> x y)
            1)
          ((< x y)
            -1)))
这个树定义和书本第二章里的树没有什么大不同，主要的区别是这个定义使用了四个域，分别保存键、值和左右分支。

另外，这个树还增加了一个 compare 参数，用于接受不同类型数据的对比过程，对比过程根据两个值之间的关系，分别返回 0 （相等）、 1 （大于）和 -1 （小于）；为了方便进行测试，在源码的最后给出了常用的三个对比过程，分别可以用于字符串、符号和数字的对比。

测试：

1 ]=> (load "26-tree.scm")

;Loading "26-tree.scm"... done
;Value: compare-number

1 ]=> (define phone-tree (tree-insert! '() 'peter 1382000 compare-symbol))

;Value: phone-tree

1 ]=> (tree-search phone-tree 'peter compare-symbol)

;Value 11: (peter 1382000 () ())

1 ]=> (define phone-tree (tree-insert! phone-tree 'jack 137234234 compare-symbol))

;Value: phone-tree

1 ]=> phone-tree

;Value 11: (peter 1382000 (jack 137234234 () ()) ())

1 ]=> (define phone-tree (tree-insert! phone-tree 'sam 1579898 compare-symbol))

;Value: phone-tree

1 ]=> phone-tree

;Value 11: (peter 1382000 (jack 137234234 () ()) (sam 1579898 () ()))
表
既然已经有了树实现，接下来就是完成 make-table 、 lookup 和 insert! 过程了：

;;; 26-table.scm

(load "26-tree.scm")

(define (make-table compare)
    (let ((t '()))

        (define (empty?)
            (tree-empty? t))

        (define (insert! given-key value)
            (set! t (tree-insert! t given-key value compare))
            'ok)

        (define (lookup given-key)
            (let ((result (tree-search t given-key compare)))
                (if (null? result)
                    #f
                    (tree-value result))))

        (define (dispatch m)
            (cond ((eq? m 'insert!)
                    insert!)
                  ((eq? m 'lookup)
                    lookup)
                  ((eq? m 'empty?)
                    (empty?))
                  (else
                    (error "Unknow mode " m))))

        dispatch))
make-table 闭包起了 compare 和 t ，作为对比过程和树根（作用类似于书本 184 页的表格的表头），省去了将树根和对比过程作为参数传来传去的麻烦，为树过程的调用提供了很大的方便。

测试：

1 ]=> (load "26-table.scm")

;Loading "26-table.scm"...
;  Loading "26-tree.scm"... done
;... done
;Value: make-table

1 ]=> (define t (make-table compare-symbol))

;Value: t

1 ]=> (t 'empty?)

;Value: #t

1 ]=> ((t 'insert!) 'peter 10086)

;Value: ok

1 ]=> ((t 'lookup) 'peter)

;Value: 10086

1 ]=> (t 'empty?)

;Value: #f

1 ]=> ((t 'lookup) 'not-exists-key)

;Value: #f
See also 树实现中几个对比器所调用的内置过程，比如 string>=? 和 symbol->string ，可以在手册找到： http://www.gnu.org/software/mit-scheme/documentation/mit-scheme-ref/Comparison-of-Strings.html#Comparison-of-Strings 、 http://www.gnu.org/software/mit-scheme/documentation/mit-scheme-ref/Symbols.html#Symbols 。
讨论 
blog comments powered by Disqus
indexSICP 解题集 »
© Copyright 2014, huangz1990. Last updated on May 03, 2017. Created using Sphinx 1.5.3.
  v: latest 