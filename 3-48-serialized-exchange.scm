

这里先给出新的 make-account 定义和新的 serialized-exchange 定义，然后再来解释避免死锁的方法。

make-account
;;; 48-make-account.scm

(load "parallel.scm")   ; 载入 make-serializer

; 修改自书本 214 页的 make-account-and-serializer
; 带注释的行是新添加的

(define (make-account balance)
    
    (let ((id (generate-account-id)))                       ; +

        (define (withdraw amount)
            (if (>= balance amount)
                (begin (set! balance (- balance amount))
                       balance)
                "Insufficient funds"))

        (define (deposit amount)
            (set! balance (+ balance amount))
            balance)

        (let ((balance-serializer (make-serializer)))
            (define (dispatch m)
                (cond
                    ((eq? m 'withdraw)
                        withdraw)
                    ((eq? m 'deposit)
                        deposit)
                    ((eq? m 'balance)
                        balance)
                    ((eq? m 'serializer)
                        balance-serializer)
                    ((eq? m 'id)                            ; +
                        id)                                 ; +
                    (else
                        (error "Unknown request -- MAKE-ACCOUNT" m))))

            dispatch)))

(define (counter)
    (let ((i 0))
        (lambda ()
            (set! i (+ 1 i))
            i)))

(define generate-account-id (counter))

generate-account-id 是 counter 对象的一个实例，每次调用它就会返回一个新的数值。

每次在创建银行帐号的时候，都会调用 generate-account-id 为 id 设置值，而这个 id 值可以通过向帐号发送 'id 消息来查看。


(define (serialized-exchange acc-1 acc-2)
    ; 获取并对比两个帐号的 id 值
    ; 然后传给 serialize-and-exchange
    (if (< (acc-1 'id) (acc-2 'id))
        (serialize-and-exchange acc-1 acc-2)
        (serialize-and-exchange acc-2 acc-1)))

(define (serialize-and-exchange smaller-id-account bigger-id-account)
    ; 使用两个 let 结构
    ; 按顺序先后获取两个帐号的 serializer
    (let ((smaller-serializer (smaller-id-account 'serializer)))
        (let ((bigger-serializer (bigger-id-account 'serializer)))
            ((smaller-serializer (bigger-serializer exchange))
             smaller-id-account
             bigger-id-account))))
serialized-exchange 获取输入的两个帐号的 id ，并使用 serialize-and-exchange 保证 id 值较小的那个帐号的 serializer 先获取，然后再获取 id 值较大的那个帐号的 serializer 。


原理解释
根据书本的例子，当 peter 试图互换 peter-acc 和 paul-acc ，而 paul 试图互换 paul-acc 和 peter-acc 时，死锁会在两个交换过程争抢缺少的另一个 serializer 时发生。

在前面给出的修改版的 serialized-exchange 中， serialized-exchange 会根据传入的两个帐号的 id 值的大小，先让 id 值较小的帐号获取 serializer ，然后让 id 值较大的帐号获取 serializer ，从而避免两个帐号交叉争抢 serializer 从而发生死锁的情况。

比如说，假设 peter-acc 的 id 值为 1 ，而 paul-acc 的 id 值为 2 ，那么在使用新的 serialized-exchange 进行余额交换的时候，都总会先尝试获取 peter-acc 的 serializer ，然后再获取 paul-acc 的 serializer 。

如果 peter 和 paul 同时执行余额交换过程，那么他们其中一人的程序先得到 peter-acc 的 serializer ，而另一人的程序则必须等待 peter-acc 的 serializer 的释放，这也就避免了死锁。
