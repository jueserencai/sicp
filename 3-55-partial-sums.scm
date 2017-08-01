

使用 练习 3.54 的方法，分析 (partial-sums s) 流，并找出隐藏在其中的流规律：

(partial-sums s)                x                           y

s0                                                          s0
s0 + s1                         s0                          s1
s0 + s1 + s2                    s0 + s1                     s2
s0 + s1 + s2 + s3               s0 + s1 + s2                s3
s0 + s1 + s2 + s3 + s4          s0 + s1 + s2 + s3           s4
s0 + s1 + s2 + s3 + s4 + s5     s0 + s1 + s2 + s3 +s 4      s5
...                             ...                         ...
分析的结果表明， (partial-sums s) 可以表示为两个流之和： x 流为 (partial-sums s) 本身， y 流则是流 s ：

(define (partial-sums s)
    (cons-stream (stream-car s)
                 (add-streams (partial-sums s)
                              (stream-cdr s))))