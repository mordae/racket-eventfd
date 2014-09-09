#lang racket/base
;
; eventfd bindings
;

(require ffi/unsafe/define
         ffi/unsafe/alloc)

(require
  (rename-in ffi/unsafe (-> -->)))

(provide
  (all-defined-out))


(define-ffi-definer define-scheme #f
                    #:default-make-fail make-not-available)


(define-scheme close
               (_fun (fd : _int)
                     --> (result : _int)
                     --> (= 0 result)))

(define-scheme make-eventfd
               (_fun (initval : _uint)
                     (flags : _uint)
                     --> (result : _int)
                     --> (and (>= result 0) result))
               #:c-id eventfd
               #:wrap (allocator close))

(define-scheme eventfd-read
               (_fun (fd : _int)
                     (value : (_ptr o _uint64))
                     --> (result : _int)
                     --> (and (= 0 result) value))
               #:c-id eventfd_read)

(define-scheme eventfd-write
               (_fun (fd : _int)
                     (bstr : _uint64)
                     --> (result : _int)
                     --> (= 0 result))
               #:c-id eventfd_write)

(define-scheme fd->semaphore
               (_fun (fd : _intptr)
                     (mode : _int)
                     (socket? : _bool)
                     --> (result : _racket))
               #:c-id scheme_fd_to_semaphore)

; vim:set ts=2 sw=2 et:
