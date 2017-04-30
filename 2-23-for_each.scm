#lang racket

(define (for_each proc items)
  (if (not (null? items))
      ((lambda() (proc (car items))
       (for-each proc (cdr items))))
      #t))

(for_each (lambda (x) (newline) (display x))
	(list 57 321 88))