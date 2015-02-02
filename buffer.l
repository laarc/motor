;; -*- mode: lisp -*-

(define ffi (require 'ffi))

(define default-size 4096)

(define allocate (n)
  (ffi.new "char[?]" n))

(define create (n)
  (let (n (or n default-size))
    (obj length: 0
         storage: (allocate n)
         capacity: n)))

(define length (b) b.length)

(define extend (b n)
  (let (n (or n (* b.capacity 2))
        x (allocate n))
    (ffi.copy x b.storage b.length)
    (set b.storage x)
    (set b.capacity n)))

(define full? (b)
  (= b.length b.capacity))

(define pointer (b)
  (+ b.storage b.length))

(define space (b)
  (- b.capacity b.length))

(define string (b off len)
  (let (off (or off 0)
        max (- b.length off)
        n (min (or len max) max))
    (if (< off b.length)
        (ffi.string (+ b.storage off) n)
      "")))

(export create
        length
        extend
        full?
        pointer
        space
        string)