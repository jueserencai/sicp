

; 书中第233页的sqrt-stream和Louis的相比差别在于其用了gusses作为返回结果，而其是一个流。其每一次的运算都会调用上一次的结果，仅仅是多计算一次。因为有了memo-proc，复杂度就是theta(n)。

; 虽然Louis也是返回流，但是它相比于书中的定义，不是从上一次开始调用而是从n=1开始。因此对于任意的计算，其都需要n步。所以它的复杂度是theta(n^2)。

; 而如果去掉了sqrt-stream的memo-proc，则两者的效果是相同的，因为其实通过guesses来维持着流以达到memo-proc的效果。而Louis的定义则没有依靠memo-proc。