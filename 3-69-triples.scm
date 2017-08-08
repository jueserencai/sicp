

(define (triples s t u)
  (cons-stream (list
        (stream-car s)
        (stream-car t)
        (stream-car u))
           (interleave
        (stream-map (lambda (x) (cons (stream-car s) x))
                (stream-cdr (pairs t u)))
        (triples (stream-cdr s)
             (stream-cdr t)
             (stream-cdr u)))))
;Value: triples

(define (phythagorean-numbers)
  (define (square x) (* x x))
  (define numbers (triles integers integers integers))
  (stream-filter (lambda (x)
           (= (square (caddr x))
              (+ (square (car x)) (square (cadr x)))))
         numbers))
;Value: phythagorean-numbers