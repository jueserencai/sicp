练习 3.25
题目实际上就是要求我们写出 N 维列表的插入和查找过程，构造 N 维列表这种递归结构的最好办法就是使用递归过程。

以下是相应的过程定义：

;;; 25-table.scm

(define (insert! key-list value table)
    (if (list? key-list)
        (let ((current-key (car key-list))
              (remain-key (cdr key-list)))
            (let ((record (assoc current-key (cdr table))))
                (cond 
                    ; 1) 有记录，且没有其他关键字
                    ;    更新记录的值
                    ((and record (null? remain-key))
                         (set-cdr! record value)
                         table)
                    ; 2) 有记录，且还有其他关键字
                    ;    说明这个记录实际上是一个子表
                    ;    使用 insert! 递归地进行插入操作
                    ((and record remain-key)
                        (insert! remain-key value record)
                        table)
                    ; 3) 无记录，且有其他关键字
                    ;    需要执行以下三步：
                    ;    一、 创建子表
                    ;    二、 对子表进行插入
                    ;    三、 将子表加入到 table
                    ;    这三个步骤可以用一句完成，wow！
                    ((and (not record) (not (null? remain-key)))
                        (join-in-table (insert! remain-key value (make-table current-key)) table)
                        table)
                    ; 4) 无记录，且无其他关键字
                    ;    创建记录并将它加入到 table
                    ((and (not record) (null? remain-key))
                        (let ((new-record (cons current-key value)))
                            (join-in-table new-record table)
                            table)))))
        (insert! (list key-list) value table)))  ; 将单个键转换成列表

(define (join-in-table new-record table)
    (set-cdr! table
              (cons new-record (cdr table))))

(define (lookup key-list table)
    (if (list? key-list)
        (let ((current-key (car key-list))
              (remain-key (cdr key-list)))
            (let ((record (assoc current-key (cdr table))))
                (if record
                    (if (null? remain-key)
                        (cdr record)
                        (lookup remain-key record))
                    #f)))
        (lookup (list key-list) table)))    ; 将单个键转换成列表

(define (make-table . table-name) 
    (if (null? table-name)
        (list '*table*)
        table-name))

; p 184
(define (assoc key records)
    (cond ((null? records)
            #f)
          ((equal? key (caar records))
            (car records))
          (else
            (assoc key (cdr records)))))
insert! 内的各个 case 都有详细的注释，这里不再多说了。以下是另外几个需要注意的地方：

在 insert! 的每个 case 之后，都会将 table 返回，当需要递归地创建子表时，就会用上这些返回值。
当 insert! 或者 lookup 的输入键只是单个值而不是一个列表时，它会被转换成一个列表，然后重新调用过程。
为了可读性，将新记录添加到表的操作被抽象成 join-in-table 过程。
对 make-table 做了修改，让它可以在调用时接受给定的表名， insert! 的第三个 case 就用到了这个特性；如果没有给定表名，那么就使用默认的 '*table* 。
测试 make-table ：

1 ]=> (load "25-table.scm")

;Loading "25-table.scm"... done
;Value: assoc

1 ]=> (make-table)

;Value 11: (*table*)

1 ]=> (make-table 'my-table)

;Value 13: (my-table)
测试 insert! 和 lookup ：

1 ]=> (load "25-table.scm")

;Loading "25-table.scm"... done
;Value: make-table

1 ]=> (define t (make-table))

;Value: t

1 ]=> (insert! 'a-single-key 10086 t)                                               ; 一维表插入和查找

;Value 26: (*table* (a-single-key . 10086))

1 ]=> (lookup 'a-single-key t)

;Value: 10086

1 ]=> (insert! (list 'key-1 'key-2 'key-3) 123 t)

;Value 26: (*table* (key-1 (key-2 (key-3 . 123))) (a-single-key . 10086))           ; 三维表插入和查找

1 ]=> (lookup (list 'key-1 'key-2 'key-3) t)

;Value: 123

1 ]=> (insert! (list 'key-1 'key-2 'key-3) 'hello-moto t)                           ; 修改三维表中元素的值

;Value 26: (*table* (key-1 (key-2 (key-3 . hello-moto))) (a-single-key . 10086))

1 ]=> (lookup (list 'key-1 'key-2 'key-3) t)

;Value: hello-moto
