#lang racket

; segment operation
(define (make_segment start_point end_point) (cons start_point end_point))
(define (start_segment segment) (car segment))
(define (end_segment segment) (cdr segment))
(define (midpoint_segment segment)
	(make_point (/ (+ (x_point (start_segment segment)) (x_point (end_segment segment))) 2.0) (/ (+ (y_point (start_segment segment)) (y_point (end_segment segment))) 2.0)))

; point operation
(define (make_point x y) (cons x y))
(define (x_point point) (car point))
(define (y_point point) (cdr point))
(define (print_point p)
	(newline)
	(display "(")
	(display (x_point p))
	(display ",")
	(display (y_point p))
	(display ")"))

; run test
(define A (make_point 1 2))
(define B (make_point 5 12))
(print_point A)
(print_point B)
(define segment_a (make_segment A B))
(print_point (end_segment segment_a))
(print_point (midpoint_segment segment_a))