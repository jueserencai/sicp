

信号量的核心就是一个计数器，如果计数器不为 0 ，那么 acquire 操作就对计数器减一，获取信号量，否则的话，就一直等待直到可以获取信号量为止； release 操作为计数器加一。

以下是信号量的基本实现（为了实现的简单性，省略了错误的检测和处理条件）：

;;; 47-unsafe-semaphore.scm

(define (make-semaphore n)

    (define (acquire)
        (if (> n 0)
            (begin (set! n (- n 1))
                   'ok)
            (acquire)))

    (define (release)
        (set! n (+ n 1))
        'ok)

    (define (dispatch mode)
        (cond ((eq? mode 'acquire)
                (acquire))
              ((eq? mode 'release)
                (release))
              (else
                (error "Unknown mode MAKE-SEMAPHORE" mode))))

    dispatch)
测试：

1 ]=>(load "47-unsafe-semaphore.scm")

;Loading "47-unsafe-semaphore.scm"... done
;Value: make-semaphore

1 ]=> (define s (make-semaphore 5))

;Value: s

1 ]=> (s 'acquire)

;Value: ok

1 ]=> (s 'release)

;Value: ok
可惜的是，这个简单的信号量实现并不安全，因为在有多个进程进行并发获取信号量的时候，对 n 的设置很容易出现问题（在前面的章节中我们已经清楚这一点了），因此，以下分别使用互斥元和基于原子的 test-and-set! 操作来保证信号量的安全性。

基于互斥元的信号量
基于互斥元的信号量的主要修改是，在对 n 进行修改之前，获取互斥元，在修改完毕之后，释放互斥元，这样就可以保证每次只有一个进程在修改 n ，因此也就保证了 n 的正确性：

;;; 47-semaphore-using-mutex.scm

(load "p217-make-mutex.scm")

(define (make-semaphore n)

    (let ((mutex (make-mutex)))
        
        (define (acquire)
            (mutex 'acquire)
            (if (> n 0)                     ; 用互斥元保护 n 的修改
                (begin (set! n (- n 1))     ; 获取信号量之后
                       (mutex 'release)     ; 释放互斥元
                       'ok)
                (begin (mutex 'release)     ; 获取信号量不成功，先释放互斥元
                       (acquire))))         ; 然后再次尝试获取信号量

        (define (release)
            (mutex 'acquire)
            (set! n (+ n 1))                ; release 操作也需要用互斥元保护
            (mutex 'release)
            'ok)

        (define (dispatch mode)
            (cond ((eq? mode 'acquire)
                    (acquire))
                  ((eq? mode 'release)
                    (release))
                  (else
                    (error "Unknown mode MAKE-SEMAPHORE" mode))))

        dispatch))
一定要小心处理互斥元的获取和释放，否则很容易就会造成死锁。

测试：

1 ]=> (load "47-semaphore-using-mutex.scm")

;Loading "47-semaphore-using-mutex.scm"...
;  Loading "p217-make-mutex.scm"... done
;... done
;Value: make-semaphore

1 ]=> (define s (make-semaphore 5))

;Value: s

1 ]=> (s 'acquire)

;Value: ok

1 ]=> (s 'release)

;Value: ok

1 ]=> (load "parallel.scm")

;Loading "parallel.scm"... done
;Value: write

1 ]=> (parallel-execute (lambda () (s 'acquire))
                        (lambda () (s 'acquire)))

;Value 11: #[compound-procedure 11 terminator]

1 ]=> (s 'release)

;Value: ok

1 ]=> (s 'release)

;Value: ok
基于原子性 test-and-set! 的信号量
基于原子性 test-and-set! 操作的信号量实现比前面的互斥元实现要简单得多，因为它只要保证 test-and-set! 的正确性就行了，不用担心互斥元的释放和获取，也不必担心产生死锁：

;;; 47-semaphore-using-test-and-set.scm

(define (make-semaphore n)

    (define (acquire)
        (if (test-and-set! n)
            (acquire)
            'ok))
    
    (define (release)
        (set! n (+ n 1))
        'ok)

    (define (dispatch mode)
        (cond ((eq? mode 'acquire)
                (acquire))
              ((eq? mode 'release)
                (release))
              (else
                (error "Unknown mode MAKE-SEMAPHORE" mode))))

    dispatch)

(define (test-and-set! n)
    (if (= n 0)
        #t
        (begin (set! n (- n 1))
               #f)))

#|
; 根据注释 174
; 以下是一个可以在采用时间片模型的单处理器的 MIT Scheme 里实际运行的 test-and-set!

(define (test-and-set! n)
    (without-interrupts
        (lambda ()
            (if (= n 0)
                #t
                (begin (set! n (- n 1))
                       #f)))))

|#
注意， test-and-set! 的实现并不是一个真正的原子操作，这里只是做一个演示。被注释掉的另一个 test-and-set! 是实际的原子性操作，但它只能在使用时间片模型的单处理器的 MIT Scheme 中使用，因为现在基本都是多核处理器，所以那个实现实际上也没什么用。

测试：

1 ]=> (load "47-semaphore-using-test-and-set.scm")

;Loading "47-semaphore-using-test-and-set.scm"... done
;Value: test-and-set!

1 ]=> (define s (make-semaphore 5))

;Value: s

1 ]=> (s 'acquire)

;Value: ok

1 ]=> (s 'release)

;Value: ok

1 ]=> (load "parallel.scm")

;Loading "parallel.scm"... done
;Value: write

1 ]=> (parallel-execute (lambda () (s 'acquire))
                        (lambda () (s 'acquire)))

;Value 11: #[compound-procedure 11 terminator]

1 ]=> (s 'release)

;Value: ok

1 ]=> (s 'release)

;Value: ok
