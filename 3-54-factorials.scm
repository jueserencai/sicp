先写出 mul-streams ：

;;; 54-mul-streams.scm

(define (mul-streams s1 s2)
    (stream-map * s1 s2))

factorial
factorial 的定义是，对于每个 (factorial i) ，有 1 * 2 * 3 * ... * i ，我们需要构造这样一个序列：

i : factorial           : product

1 : 1                   : 1
2 : 1 * 2               : 2
3 : 1 * 2 * 3           : 6
4 : 1 * 2 * 3 * 4       : 24
5 : 1 * 2 * 3 * 4 * 5   : 120
...
仔细观察上面的序列，可以发现 factorial 流当中蕴涵这两个流的乘法，一个是 1, 2, 3 ,4 ,5, ... ，另一个是 1, 1 * 2, 1 2 * 3, 1 * 2 * 3 * 4, ... ：

s1              s2

                1
1 *             2
1 * 2 *         3
1 * 2 * 3 *     4
1 * 2 * 3 * 4 * 5
将序列再换成前缀表达式，我们寻找的计算序列就会浮现出来：

op  s1          s2

*               1
*   1,          2
*   1, 2        3
*   1, 2, 3     4
*   1, 2, 3, 4  5
从给出的序列可以看出， s1 应该是 factorial 本身，而 s2 则是整数序列 integers ，根据这一发现，将过程定义补充完毕：

;;; 54-factorial.scm

(load "p228-integers.scm")
(load "54-mul-streams.scm")

(define factorial
    (cons-stream 1 
                 (mul-streams factorial
                              (stream-cdr integers))))  ; 因为 1 放在了定义前面，所以要从 stream-cdr 部分，也即是 2 开始给出整数序列流