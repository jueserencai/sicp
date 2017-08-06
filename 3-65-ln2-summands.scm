


; 基本的流
(define (ln2-summands n)
        (cons-stream (/ 1.0 n) 
                     (stream-map - (ln2-summands (+ n 1)))))
(define ln2-stream
        (partial-sums (ln2-summands 1)))

; 欧拉加速的
; 超级加速的流的流（表列）
; 如课本p234所示