; #lang racket
; (require scheme/mpair)

; base process
; 187页的代码，实现get、put过程
(define (make-table)
    (let ((local-table (list '*table*)))
        (define (lookup key-1 key-2)
            (let ((subtable (assoc key-1 (cdr local-table))))
                (if subtable
                    (let ((record (assoc key-2 (cdr subtable))))
                        (if record
                            (cdr record)
                            #f))
                    #f)))
        (define (insert! key-1 key-2 value)
            (let ((subtable (assoc key-1 (cdr local-table))))
                (if subtable
                    (let ((record (assoc key-2 (cdr subtable))))
                        (if record
                            (set-cdr! record value)
                            (set-cdr! subtable
                                      (cons (cons key-2 value)
                                            (cdr subtable)))))
                    (set-cdr! local-table
                              (cons (list key-1
                                          (cons key-2 value))
                                    (cdr local-table)))))
            'ok)
        (define (dispatch m)
            (cond ((eq? m 'lookup-proc) lookup)
                  ((eq? m 'insert-proc!) insert!)
                  (else 
                    (error "Unknown operation -- TABLE" m))))
        dispatch))
(define operation-table (make-table))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))

; 数据导向风格的求导过程
(define (deriv exp var)
	(cond ((number? exp) 0)
		((variable? exp) (if (same-variable? exp var) 1 0))
		(else ((get 'deriv (operator exp)) (operands exp) var))))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

; 求导用到的一些基本谓词过程
(define (variable? x) (symbol? x))
(define (same-variable? v1 v2)
	(and (variable? v1) (variable? v2) (eq? v1 v2)))
(define (=number? exp num)
	(and (number? exp) (= exp num)))

(define (attach-tag type-tag x y)
	(list type-tag x y))
(define (type-tag datumn)
	(car datumn))
(define (contents datum)
	(if (pair? datum)
		(cdr datum)
		(error "bad tagged datum -- CONTENTS" datum)))
; b)
(define (install-sum-package)
    ;;; internal procedures 
    (define (addend s)
        (car s))
    (define (augend s)
        (cadr s))
    (define (make-sum x y)
        (cond ((=number? x 0)
                y)
              ((=number? y 0)
                x)
              ((and (number? x) (number? y))
                (+ x y))
              (else
                (attach-tag '+ x y))))
    ;;; interface to the rest of the system
    (put 'addend '+ addend)
    (put 'augend '+ augend)
    (put 'make-sum '+ make-sum)
    (put 'deriv '+
        (lambda (exp var)
            (make-sum (deriv (addend exp) var)
                      (deriv (augend exp) var))))
	'done)
(define (make-sum x y)
    ((get 'make-sum '+) x y))
(define (addend sum)
    ((get 'addend '+) (contents sum)))
(define (augend sum)
    ((get 'augend '+) (contents sum)))

(define (install-product-package)
    (define (multiplier p) (car p))
    (define (multiplicand p) (cadr p))
    (define (make-product x y)
        (cond ((or (=number? x 0) (=number? y 0)) 0)
               ((=number? x 1) y)
               ((=number? y 1) x)
               ((and (number? x) (number? y))
                (* x y))
               (else
                (attach-tag '* x y))))
    (put 'multiplier '* multiplier)
    (put 'multiplicand '* multiplicand)
    (put 'make-product '* make-product)
    (put 'deriv '* 
        (lambda (exp var)
          	(make-sum (make-product (multiplier exp)
                                    (deriv (multiplicand exp) var))
                      (make-product (deriv (multiplier exp) var)
                                     (multiplicand exp)))))
    'done)
(define (make-product x y)
    ((get 'make-product '*) x y))
(define (multiplier product)
    ((get 'multiplier '*) (contents product)))
(define (multiplicand product)
    ((get 'multiplicand '*) (contents product)))

; run test
(install-sum-package)
(install-product-package)
(deriv '(+ (* 2 x) 3) 'x)


; 回答问题
; a)
; deriv 过程没有对 number? 和 same-variable? 使用数据导向处理的原因是，在求导程序中，数字被直接表示为 Scheme 的数值类型，而变量被直接表示为 Scheme 的符号类型（查看书本 100 页），因此只使用 number? 和 same-variable? 这两种内置的谓词语句，就足以对这两中类型进行判断了，没有必要画蛇添足。

; 当然，如果一定要做的话，也不是不可以，但是这样一来，求导程序的每个包都要加上 number? 和 same-variable? 谓词，而这样的分派实际上是没有必要的。

; 举个例子，可以为数字类型加上标识，比如 integer ：

; (cons 'integer 10086)
; 当 deriv 函数接收到这个对象时，它执行查找：

; ((get 'number? 'integer) 10086)
; 然后 (get 'number 'integer) 查找过程 number? ，对 10086 进行判断：

; (number? 10086)
; 得出结果 #t 。

; 虽然结果是正确的，但是你会发现以上的工作实际上就是饶了个圈子，给调用 number? 多增加了一个步骤而已，因此在实际中，对 number? 和 same-variable? 进行数据导向处理是没有必要的。


; b) 的求和、求积在上面。 c)

; d)
; 包里面的主体程序无须变动，但是调用 put 的参数的位置需要调整。

; 比如原本的：

; (put 'make-sum '+ make-sum)
; 现在要改成：

; (put '+ 'make-sum make-sum)
; 但是 make-sum 程序本身不必修改。