
省略图形画法。
第一个版本，创建环境结构：

(n=6) 		(n=5) 		(n=4) 		(n=3) 		(n=2) 		(n=1)  
(factorial)	(factorial)	(factorial)	(factorial)	(factorial)	(factorial)

第二个版本，创建的环境结构：
(n=6)			(product=1 counter=1 max-count=6)	...
(factorial 6) 	(fact-iter)							...


(fact-iter 1 1 6)
(fact-iter 1 2 6)
(fact-iter 2 3 6)
(fact-iter 6 4 6)
(fact-iter 24 5 6)
(fact-iter 120 6 6)
(fact-iter 720 7 6)