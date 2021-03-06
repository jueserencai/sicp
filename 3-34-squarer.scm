indexSICP 解题集 »
练习 3.34
通过对 Louis 的 squarer 过程进行测试发现，当为 a 设置值的时候， b 的值可以正确地计算出来，但如果只为 b 设置值，那么 a 没有办法计算出来。

1 ]=> (load "34-squarer.scm")

;Loading "34-squarer.scm"...
;  Loading "p205-constraint.scm"...
;    Loading "p201-constraint-interface.scm"... done
;    Loading "p201-adder.scm"... done
;    Loading "p202-multiplier.scm"... done
;    Loading "p202-constant.scm"... done
;    Loading "p203-probe.scm"... done
;    Loading "p203-make-connector.scm"... done
;  ... done
;... done
;Value: squarer

1 ]=> (define a (make-connector))

;Value: a

1 ]=> (define b (make-connector))

;Value: b

1 ]=> (probe "a" a)

;Value 11: #[compound-procedure 11 me]

1 ]=> (probe "b" b)

;Value 12: #[compound-procedure 12 me]

1 ]=> (squarer a b)

;Value 14: #[compound-procedure 14 me]

1 ]=> (set-value! a 3 'user)            ; 可以正确地通过 a 计算 b

Probe: b = 9
Probe: a = 3
;Value: done

1 ]=> (forget-value! a 'user)

Probe: b = ?
Probe: a = ?
;Value: done

1 ]=> (set-value! b 16 'user)           ; 但是没有办法通过 b 计算 a (只有 b 的值被改变了)

Probe: b = 16
;Value: done
问题的原因
要了解 squarer 运行不正确的原因，需要对它的执行轨迹进行追踪。

先来分析 (set-value! a 3 'user) 是如何正确地执行的：

当 (squarer a b) 被调用时， (multiplier a a b) 会被执行， a 、 b 两个连接器被连接到 multiplier 约束上，当 a 的值被修改时， multiplier 约束中的 process-new-value 过程会被调用，然后落入到 (and (has-value? a) (has-value? a)) 这个 case 上，于是 (set-value! b (* (get-value a) (get-value a)) me) 这个表达式被求值，连接器 b 的值被设置为 (* 3 3) = 9 。

接下来，分析 (set-value! b 16 'user) 的执行过程：

当 b 的值被修改时， multiplier 的 process-new-value 过程被执行，这时的状态是 a 没有值，而 b 有值，但 process-new-value 并没有处理这一 case 的定义：

(define (multiplier m1 m2 product)
    (define (process-new-value)
        (cond
            ((or (and (has-value? m1) (= 0 (get-value m1)))
                 (and (has-value? m2) (= 0 (get-value m2))))
                ; ...)
            ((and (has-value? m1) (has-value? m2))
                ; ...)
            ((and (has-value? product) (has-value? m1))
                ; ...)
            ((and (has-value? product) (has-value? m2))
                ; ...)))
; ...)
这就是 (set-value! b 16 'user) 不会正确地计算连接器 a 的值的真正原因： process-new-value 过程不知道怎么去处理 m1 和 m2 连接器都没有值的情况（在这个例子中， m1 和 m2 都是 a ）。

要证明以上推论的正确性，可以在 process-new-value 过程里增加这样一个 case ：当 m1 和 m2 都没有值的时候，打印一个错误信息：

;;; 34-multiplier.scm

(define (multiplier m1 m2 product)
    (define (process-new-value)
        (cond
            ((or (and (has-value? m1) (= 0 (get-value m1)))
                 (and (has-value? m2) (= 0 (get-value m2))))
                (set-value! product 0 me))
            ((and (has-value? m1) (has-value? m2))
                (set-value! product
                            (* (get-value m1) (get-value m2))
                            me))
            ((and (has-value? product) (has-value? m1))
                (set-value! m2
                            (/ (get-value product) (get-value m1))
                            me))
            ((and (has-value? product) (has-value? m2))
                (set-value! m1
                            (/ (get-value product) (get-value m2))
                            me))
            ((and (not (has-value? m1)) (not (has-value? m2)))      ; 新增 case
                (error "Nither m1 nor m2 has value."))))            ;
    (define (process-forget-value)
        (forget-value! product me)
        (forget-value! m1 me)
        (forget-value! m2 me)
        (process-new-value))
    (define (me request)
        (cond
            ((eq? request 'I-have-a-value)
                (process-new-value))
            ((eq? request 'I-lost-my-value)
                (process-forget-value))
            (else
                (error "Unknown request -- MULTIPLIER" request))))
    (connect m1 me)
    (connect m2 me)
    (connect product me)
    me)
然后再次进行测试：

1 ]=> (load "34-squarer.scm")

;Loading "34-squarer.scm"...
;  Loading "p205-constraint.scm"...
;    Loading "p201-constraint-interface.scm"... done
;    Loading "p201-adder.scm"... done
;    Loading "p202-multiplier.scm"... done
;    Loading "p202-constant.scm"... done
;    Loading "p203-probe.scm"... done
;    Loading "p203-make-connector.scm"... done
;  ... done
;... done
;Value: squarer

1 ]=> (load "34-multiplier.scm")        ; 载入修改过的 multiplier ，覆盖原本的 multiplier

;Loading "34-multiplier.scm"... done
;Value: multiplier

1 ]=> (define a (make-connector))

;Value: a

1 ]=> (define b (make-connector))

;Value: b

1 ]=> (probe "a" a)                     ; 监视三个连接器

;Value 11: #[compound-procedure 11 me]

1 ]=> (probe "b" b)

;Value 12: #[compound-procedure 12 me]

1 ]=> (squarer a b)

;Value 13: #[compound-procedure 13 me]

1 ]=> (set-value! b 16 'user)

;Nither m1 nor m2 has value.
;To continue, call RESTART with an option number:
; (RESTART 1) => Return to read-eval-print level 1.
可以看到， process-new-value 新增 case 的错误语句被打印了出来，证明我们的推论是正确的。
