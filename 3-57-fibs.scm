

从书本 227 页的 fibs 定义以及 229 页的 fibs 图示分析可知，对于第 i 个斐波那契数，也即是 (stream-ref fibs i) ，需要对 (stream-ref fibs (- i 1)) 和 (stream-ref fibs (- i 2)) 进行一次加法。

对于使用记忆过程实现的，无重复的 fibs 来说，每个 (stream-ref fibs i) 只需要被计算一次，以后就可以根据记忆过程来直接返回计算结果。

因此，计算 (stream-ref fibs n) 总共需要 n 次加法，它产生的计算序列和书本 26 页的迭代版本的 fib 过程是一样的。

另一方面，如果使用不带记忆过程的 lambda 来实现 delay ，那么对于每个 (stream-ref fibs i) ，都要对 (stream-ref fibs (- i 1)) 和 (stream-ref fibs (- i 2)) 进行一次加法，而对 (stream-ref fibs (- i 1)) 的求值又引发 (stream-ref fibs (-i 2) 和 (stream-ref fibs (- i 3)) 进行相加，以此类推，一直回溯到 0 和 1 为止，这一计算所产生的加法序列和书本 24 页指数级复杂度的递归 fib 过程产生的加法序列一样，因此这一实现所需的加法将指数倍地上升。