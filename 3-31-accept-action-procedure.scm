indexSICP 解题集 »
练习 3.31
Note 在看了『待处理表的实现』这一节之后再来解这个问题，会比较容易理解。
为了让问题简化，让我们来追踪一个 inverter 的执行过程(道理是一样的，但是 half-adder 的追踪要复杂很多)。

假设现在有两条线路，分别是 input 和 output ，求值 (inverter input output) 会执行这样一个展开序列：

(inverter input output)

(define (invert-input)
    (let ((new-value (logical-not (get-signal input))))
        (after-delay invert-delay
                     (lambda ()
                        (set-signal! output new-value)))))
注意，前面只是定义 invert-input 过程，但是还没有执行它，接下来，当 add-action! 执行时，以下的执行过程发生：

(add-action! input invert-input)

(((eq? m 'add-action!) accept-action-procedure!) invert-input)

(accept-action-procedure! invert-input)

(set! action-procedures
      (cons proc action-procedures) ; 将 invert-input 加入线路的 action-procedures 中
      (invert-input))               ; (proc)
可以看到，在上面展开的最后一步， invert-input 才会被执行，它的执行过程展开如下：

(after-delay invert-delay
             (lambda ()
                (set-signal! output new-value)))

(add-to-agenda! (+ delay (current-time the-agenda))
                action
                the-agenda)
after-delay 会调用 add-to-agenda! ，将指定的动作添加到模拟器的待处理列表中，当调用 (propagate) 时，这个指定的动作会被执行。

如果我们按照题目所讲，将 accept-action-procedure! 的 (proc) 这一行去掉的话，那么相应的动作过程就不会被添加到待处理列表。

以这个 inveter 作例子，如果 accept-action-procedure! 缺少 (proc) 这一步，那么 (invert-input) 就不会被执行，反门的动作也不会被添加到模拟器的处理列表里；如果这时候运行 (propagate) 的话，那么什么东西也不会发生，因为待处理列表里面空无一物。

可以通过实际的模拟数据来支持上面的论证，以下是去掉 (proc) 之后执行 inverter 模拟的结果：

1 ]=> (load "p194-simula.scm")

;Loading "p194-simula.scm"...
;  Loading "28-or-gate.scm"... done
;  Loading "p190-full-adder.scm"... done
;  Loading "p190-half-adder.scm"... done
;  Loading "p191-and-gate.scm"... done
;  Loading "p191-inverter.scm"... done
;  Loading "p192-wire.scm"... done
;  Loading "p194-after-delay.scm"... done
;  Loading "p194-probe.scm"... done
;  Loading "p194-propagate.scm"... done
;  Loading "p196-agenda.scm"...
;    Loading "p181-queue.scm"... done
;  ... done
;... done
;Value: or-gate-delay

1 ]=> (define input (make-wire))

;Value: input

1 ]=> (define output (make-wire))

;Value: output

1 ]=> (inverter input output)

;Value: ok

1 ]=> the-agenda                    ; 待处理列表里面什么也没有

;Value 11: (0)

1 ]=> (propagate)                   ; 没有任何动作被执行

;Value: done

1 ]=> (get-signal output)           ; 输出自然也没有被修改

;Value: 0

1 ]=> the-agenda                    ; 模拟器的时间也没有变

;Value 11: (0)
以下是原本的模拟程序的执行结果（没有去掉 (proc) ）：

1 ]=> (load "p194-simula.scm")

;Loading "p194-simula.scm"...
;  Loading "28-or-gate.scm"... done
;  Loading "p190-full-adder.scm"... done
;  Loading "p190-half-adder.scm"... done
;  Loading "p191-and-gate.scm"... done
;  Loading "p191-inverter.scm"... done
;  Loading "p192-wire.scm"... done
;  Loading "p194-after-delay.scm"... done
;  Loading "p194-probe.scm"... done
;  Loading "p194-propagate.scm"... done
;  Loading "p196-agenda.scm"...
;    Loading "p181-queue.scm"... done
;  ... done
;... done
;Value: or-gate-delay

1 ]=> (define input (make-wire))

;Value: input

1 ]=> (define output (make-wire))

;Value: output

1 ]=> (inverter input output)

;Value: ok

1 ]=> the-agenda                    ; 对 output 进行求反的过程被放进待处理列表中

;Value 11: (0 (2 (#[compound-procedure 12]) #[compound-procedure 12]))

1 ]=> (propagate)

;Value: done

1 ]=> (get-signal output)           ; 输出被正确地设置

;Value: 1

1 ]=> the-agenda                    ; 求反的过程已经被执行，模拟器的时间也改变了

;Value 11: (2)
在打印 the-agenda 的值 (0 (2 (#[compound-procedure 12]) #[compound-procedure 12])) 的时候， #[compound-procedure 12] 出现了两次，实际上这里的队列只保存着一个 #[compound-procedure 12] 过程，关于这个问题，请参考 练习 3.21 。

讨论 
blog comments powered by Disqus
indexSICP 解题集 »
© Copyright 2014, huangz1990. Last updated on May 03, 2017. Created using Sphinx 1.5.3.
  v: latest 