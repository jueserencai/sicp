#lang racket
#| 
	^ y
	|	1		  2
	|	-----------
	|	|		  |
	|	|		  |
	|	-----------
	|	4		  3
    |------------------> x
|#

; input the point no.1 and no.3
(define (make_rectangle point_1 point_3) (cons point_1 point_3))
; get any point in rectangle by the serial number declared at the start
(define (point_in_rectangle rectangle serial_number)
	(cond ((= serial_number 1) (car rectangle))
		((= serial_number 2) (make_point (x_point (cdr rectangle)) (y_point (car rectangle))))
		((= serial_number 3) (cdr rectangle))
		((= serial_number 4) (make_point (x_point (car rectangle)) (y_point (cdr rectangle))))
		(else "error serial_number")))
(define (rec_length rectangle)
	(- (x_point (point_in_rectangle rectangle 2)) (x_point (point_in_rectangle rectangle 1))))
(define (rec_width rectangle)
	(- (y_point (point_in_rectangle rectangle 1)) (y_point (point_in_rectangle rectangle 4))))
(define (area rectangle)
	(* (rec_length rectangle) (rec_width rectangle)))
(define (perimeter rectangle)
	(* 2 (+ (rec_length rectangle) (rec_width rectangle))))

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
(define A (make_point 1 10))
(define B (make_point 5 6))
(define rec_a (make_rectangle A B))
(print_point (point_in_rectangle rec_a 1))
(print_point (point_in_rectangle rec_a 2))
(print_point (point_in_rectangle rec_a 3))
(print_point (point_in_rectangle rec_a 4))

(newline)
(display (rec_length rec_a))
(newline)
(display (rec_width rec_a))
(newline)
(display (perimeter rec_a))
(newline)
(display (area rec_a))