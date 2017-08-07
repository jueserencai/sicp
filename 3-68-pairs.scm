

; 不会工作，这个程序将会陷入无限循环。因为没有在

; (pairs (stream-cdr s) (stream-cdr t))

; 中使用delay进行延时求值，而这又会不断的递归，因此将进入无线循环中。