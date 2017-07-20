indexSICP 解题集 »
练习 3.36
为了更容易地分析和构建环境图，先将要用到的几个程序分别转换成一系列 lambda 表达式：

;;; 36.scm

(define make-connector

    ((lambda (value informant constraints)

        (define set-my-value
            (lambda (newval setter)
                (cond 
                    ((not (has-value? me))
                        (set! value newval)
                        (set! informant setter)
                        (for-each-except setter
                                         inform-about-value
                                         constraints))
                    ((not (= value newval))
                        (error "Contradiction" (list value newval)))
                    (else 'ignored))))

        (define forget-my-value
            (lambda (retractor)
                (if (eq? retractor informant)
                    (begin
                        (set! informant #f)
                        (for-each-except retractor
                                         inform-about-no-value
                                         constraints))
                    'ignored)))

        (define connect
            (lambda (new-constraint)
                (if (not (memq new-constraint constraints))
                    (set!
                        constraints
                        (cons new-constraint constraints)))
                (if (has-value? me)
                    (inform-about-value new-constraint))
                'done))

        (define me
            (lambda (request)   
                (cond
                    ((eq? request 'has-value?)
                        (if informant #t #f))
                    ((eq? request 'value)
                        value)
                    ((eq? request 'set-value!)
                        set-my-value)
                    ((eq? request 'forget)
                        forget-my-value)
                    ((eq? request 'connect)
                        connect)
                    (else
                        (error "Unknown operation -- CONNECTOR" request)))))

    me)

     #f #f '()))

(define for-each-except
    (lambda (exception procedure list)

        (define loop
            (lambda (items)
                (cond
                    ((null? items)
                        'done)
                    ((eq? (car items) exception)
                        (loop (cdr items)))
                    (else
                        (procedure (car items))
                        (loop (cdr items))))))

        (loop list)))

(define inform-about-value
    (lambda (constraint)
        (constraint 'I-have-a-value)))

(define set-value!
    (lambda (connecotr new-value informant)
        ((connecotr 'set-value!) new-value informant)))
环境图
执行

(define a (make-connector))
(define b (make-connector))
之后的环境图如下：

           +--------------------------------------------------------------------------------------------------------------------------+
           |                                                                                                                          |
global --> |  a                                                             b                                                         |
env        |  |                                                             |                                                         |
           +--|-------------------------------------------------------------|---------------------------------------------------------+
              |                   ^                                         |           ^
              |                   |                                         |           |
              |         +------------------+                                |     +------------------+
              |         |                  |                                |     |                  |
              |         | value: #f        |                                |     | value: #f        |
              |         | informant: #f    |                                |     | informant: #f    |
              |         | constraints: '() |                                |     | constraints: '() |
              |         |                  |                                |     |                  |
              |         |                  |<--------+                      |     |                  |<--------+
              |         |                  |         |                      |     |                  |         |
              |         | set-my-value: -------> [*][*]                     |     | set-my-value: -------> [*][*]
              |         |                  | parameters: newvalue setter    |     |                  | parameters: newvalue setter
              |         |                  | body: ...                      |     |                  | body: ...
              |         |                  |                                |     |                  |
              |         |                  |<--------+                      |     |                  |<--------+
              |         |                  |         |                      |     |                  |         |
              |         | forget-my-value: ----> [*][*]                     |     | forget-my-value: ----> [*][*]
              |         |                  | parameters: retractor          |     |                  | parameters: retractor
              |         |                  | body: ...                      |     |                  | body: ...
              |         |                  |                                |     |                  |
              |         |                  |<--------+                      |     |                  |<--------+
              |         |                  |         |                      |     |                  |         |
              |         | connect: ------------> [*][*]                     |     | connect: ------------> [*][*]
              |         |                  | parameters: new-constraint     |     |                  | parameters: new-constraint
              |         |                  | body: ...                      |     |                  | body: ...
              |         |                  |                                |     |                  |
              |         |                  |<--------+                      |     |                  |<--------+
              |         |                  |         |                      |     |                  |         |
              +---------->me: -----------------> [*][*]                     +------>me: -----------------> [*][*]
                        |                  | parameters: request                  |                  | parameters: request
                        |                  | body: ...                            |                  | body: ...
                        |                  |                                      |                  |
                        +------------------+                                      +------------------+
当 (set-value! a 10 'user) 执行到 (for-each-except setter inform-about-value constraints) 这一步时，环境图如下：

           +---------------------------------------------------------------------------------------------------------------------------+
           |                                                                                                                           |
           |                                                       inform-about-value                                                  |
           |                                                              |                                                            |
global --> |  a                                                           |     b                                                      |
env        |  |                                          set-value!       |     |                                                      |
           +--|---------------------------------------------|-------------|-----|------------------------------------------------------+
              |                   ^                         |  ^          |  ^  |         ^
              |                   |                        [*][*]         |  |  |         |
              |         +------------------+            parameters:       |  |  |   +------------------+
              |         |                  |                connector     |  |  |   |                  |
              |         | value: 10        |                new-value     |  |  |   | value: #f        |
              |         | informant: 'user |                informant     |  |  |   | informant: #f    |
              |         | constraints: '() |            body: ...         |  |  |   | constraints: '() |
              |         |                  |                              |  |  |   |                  |
              |         |                  |<--------+                    |  |  |   |                  |<--------+
              |         |                  |         |                    |  |  |   |                  |         |
              |         | set-my-value: -------> [*][*]                   |  |  |   | set-my-value: -------> [*][*]
              |         |                  | parameters: newvalue setter  |  |  |   |                  | parameters: newvalue setter
              |         |                  | body: ...                    |  |  |   |                  | body: ...
              |         |                  |                              |  |  |   |                  |
              |         |                  |<--------+                    |  |  |   |                  |<--------+
              |         |                  |         |                    |  |  |   |                  |         |
              |         | forget-my-value: ----> [*][*]                   |  |  |   | forget-my-value: ----> [*][*]
              |         |                  | parameters: retractor        |  |  |   |                  | parameters: retractor
              |         |                  | body: ...                    |  |  |   |                  | body: ...
              |         |                  |                              |  |  |   |                  |
              |         |                  |<--------+                    |  |  |   |                  |<--------+
              |         |                  |         |                    |  |  |   |                  |         |
              |         | connect: ------------> [*][*]                   |  |  |   | connect: ------------> [*][*]
              |         |                  | parameters: new-constraint   |  |  |   |                  | parameters: new-constraint
              |         |                  | body: ...                    |  |  |   |                  | body: ...
              |         |                  |                              |  |  |   |                  |
              |         |                  |<--------+                    |  |  |   |                  |<--------+
              |         |                  |         |                    |  |  |   |                  |         |
              +---------->me: -----------------> [*][*]                   |  |  +------>me: -----------------> [*][*]
                        |                  | parameters: request          |  |      |                  | parameters: request
                        |                  | body: ...                    |  |      |                  | body: ...
                        |                  |                              |  |      |                  |
                        +------------------+                              |  |      +------------------+
                                 ^                                        |  |
                                 |                                        |  |
      (set-my-value 10 'user)    |                                        |  |
                                 |                                        |  |
                                 |                                        |  |
                        +------------------+                              |  |
                        |                  |                              |  |
                        | newval: 10       |                              |  |
                        | setter: 'user    |                              |  |
                        |                  |                              |  |
                        +------------------+                              |  |
                                 ^                                        |  |
                                 |                                        |  |
    (for-each-except             |                                        |  |
        'user                    |                                        |  |
        inform-about-new-value   |                                        |  |
        '())                     |                                        |  |
                                 |                                        |  |
                                 |                                        |  |
                        +--------------------+                            |  |
                        |                    |                            |  |
                        | exception: 'user   |   inform-about-value       v  |
                        | procedure:-----------------------------------> [*][*]
                        | constraints: '()   |                           parameters: constraint
                        |                    |                           body: (constraint 'I-have-a-value)
                        |                    |<---------+
                        |                    |          |
                        | loop: ------------------> [*][*]
                        |                    | parameters: items
                        |                    | body: ...
                        |                    |
                        +--------------------+
                                 ^
                                 |
                (loop '())       |
                                 |
                                 |
                        +--------------------+
                        |                    |
                        | items: '()         |
                        |                    |
                        +--------------------+
                        (cond
                            ((null? items)
                                'done)
                            ((eq? (car items) exception)
                                (loop (cdr items)))
                            (else
                                (procedure (car items))
                                (loop (cdr items))))
注意 a 的内部环境中的 value 和 informant 都被改变了，执行的最后返回 'done 。
