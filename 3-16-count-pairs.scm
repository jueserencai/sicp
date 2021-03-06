indexSICP 解题集 »
练习 3.16
以下是 Ben 的 count-pairs 定义：

;;; 16-count-pairs.scm

(define (count-pairs x)
    (if (not (pair? x))
        0
        (+ (count-pairs (car x))
           (count-pairs (cdr x))
           1)))
事实上，我们可以将序对之间的连接看作是有向图，比如 (cons 1 (cons 2 '())) 可以表示为：

*----> *---->
|      |
v      v
1      2
而这个 count-pairs 的问题是，当图中的点（也即是序对）有多于一个入度的时候，它的计算方式就不对了。

以下是其中一个可能的情况：

*------+
|      |
|      v
+----> *---->
       |
       v
       1
题目要求我们构造一个能让 count-pairs 返回几个不同结果的序对组合，其实就是要求我们构成一个个图，其中需要遍历 N 步才能走到一个未连接到任何点的边（也即是 '() ）。

不返回结果的组合可以用一个环来解决（会让程序直接崩溃）：

1 ]=> (define crycle (cons 1 (cons 2 (cons 3 '()))))

;Value: crycle

1 ]=> (set-cdr! (last-pair crycle) crycle)

;Unspecified return value

1 ]=> (count-pairs crycle)

;Aborting!: maximum recursion depth exceeded
以下是 crycle 的盒子图形：

            +--------------------------+
            |              			   |
            v              			   |
crycle --> [*][*]---> [*][*]----> [*][*]
            |          |		   |
            v          v 		   v
            1          2		   3
返回结果 3 的组合也很容易做出来：

1 ]=> (define three (cons (cons 1 '()) (cons 2 '())))

;Value: three

1 ]=> three

;Value 12: ((1) 2)

1 ]=> (count-pairs three)

;Value: 3
以下是 three 的盒子图形：

three --> [*][*]---> [*][/]
           |          |
           |          v
           |          2
           v
          [*][/]
           |
           v
           1
返回结果 4 的组合需要将同一个序对的两个指针分别指向一个长度为 2 的列表的首个元素和第二个元素：

1 ]=> (define four (cons two (cdr two)))

;Value: four

1 ]=> four

;Value 15: ((1 2) 2)

1 ]=> (count-pairs four)

;Value: 4
以下是 (cons two (cdr two)) 的盒子图形：

four --> [*][*]------+
         |       	|
         v       	v
        [*][*]---> [*][/] 
         |			|
         v 			v
         1			2


最后，是返回 7 的组合：

1 ]=> (define one (list 1))

;Value: one

1 ]=> (define three (cons one one))

;Value: three

1 ]=> (define seven (cons three three))

;Value: seven

1 ]=> (count-pairs seven)

;Value: 7
以下是相应的盒子图形：

seven --> [*]
          ||
          ||
          vv
three --> [*]
          ||
          ||
          vv
  one --> [*]---> [/]
           |
           v
           1
最后要说的是，构造的组合并不是唯一的，比如说，以下组合也可以让 count-pairs 返回 4 ：

1 ]=> (define x (cons 1 '()))

;Value: x

1 ]=> (define y (cons x '()))

;Value: y

1 ]=> (define z (cons y x))

;Value: z

1 ]=> (count-pairs z)

;Value: 4

1 ]=> z

;Value 12: (((1)) 1)
它的盒子图形是：

z --> [*]---------------+
       |                |
       |                |
       v                |
y --> [*]---> [/]       |
       |                |
       |                |
       +---------------+|
                       ||
                       ||
                       vv
                 x --> [*]---> [/]
                        |
                        v
                        1
