#lang racket/base
;
; Linux eventfd support
;

(require racket/contract)

(require "private/ffi.rkt")

(provide
  (contract-out
    (eventfd? predicate/c)

    (rename new-eventfd eventfd
            (->* ()
                 (exact-nonnegative-integer?
                  #:semaphore? boolean?)
                 eventfd?))

    (fd->eventfd (-> exact-nonnegative-integer?
                     (and/c eventfd? (evt/c exact-nonnegative-integer?))))

    (eventfd-post (->* (eventfd?) (exact-nonnegative-integer?) void?))
    (eventfd-wait (-> eventfd? exact-nonnegative-integer?))

    (eventfd-fd (-> eventfd? exact-nonnegative-integer?))))


(struct eventfd
  (fd evt)
  #:property prop:evt (struct-field-index evt))


(define (fd->eventfd fd)
  (eventfd fd (guard-evt
                (λ () (wrap-evt (fd->semaphore fd 1 #t)
                                (λ (sema)
                                  (eventfd-read fd)))))))

(define (new-eventfd (initial-value 0) #:semaphore? (semaphore? #f))
  (fd->eventfd
    (make-eventfd initial-value (if semaphore? #x80801 #x80800))))

(define (eventfd-post efd (value 1))
  (unless (eventfd-write (eventfd-fd efd) value)
    (error 'eventfd-post "failed to increment eventfd semaphore")))

(define (eventfd-wait efd)
  (sync efd))


; vim:set ts=2 sw=2 et:
