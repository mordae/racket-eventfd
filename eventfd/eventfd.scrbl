#lang scribble/manual

@require[(for-label eventfd)
         (for-label racket)]

@title{eventfd}
@author+email["Jan Dvořák" "mordae@anilinux.org"]

Linux @tt{eventfd} interface for Racket.

@defmodule[eventfd]

Interface that allows manipulation of Linux @tt{eventfd} descriptors in a way
similar to Racket's semaphores.

@defproc[(eventfd? (value any/c)) boolean?]{
  Predicate identifying an event descriptor structure.
  These event descriptors also act as a synchronizable event that
  produces same results as @racket[eventfd-wait] would.
}

@defproc[(eventfd (initial-value exact-nonnegative-integer?)
                  (#:semaphore? semaphore? boolean? #f))
         eventfd?]{
  Create completely new event descriptor.
  Remember that these count towards process file descriptor count.
}

@defproc[(fd->eventfd (fd exact-nonnegative-integer?)) eventfd?]{
  Create an @racket[eventfd?] structure for an existing descriptor.
  It is undefined what happens when you pass it something that is not a
  valid event descriptor.
}

@defproc[(eventfd-post (efd eventfd?)
                       (value exact-nonnegative-integer? 1))
         void?]{
  Post given @racket[value] to the semaphore.
}

@defproc[(eventfd-wait (efd eventfd?)) exact-nonnegative-integer?]{
  Wait until the semaphore represented by the descriptor becomes
  higher than zero and then return either it's value, resetting it back
  to zero (when @racket[#:semaphore?] set to @racket[#f]) or return just
  @racket[1], decrementing the semaphore.
}

@defproc[(eventfd-fd (efd eventfd?)) exact-nonnegative-integer?]{
  Return event descriptor as an integer.
}


@; vim:set ft=scribble sw=2 ts=2 et:
