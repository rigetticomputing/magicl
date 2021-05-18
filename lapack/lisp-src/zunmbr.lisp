;;; Compiled by f2cl version:
;;; ("f2cl1.l,v 95098eb54f13 2013/04/01 00:45:16 toy $"
;;;  "f2cl2.l,v 95098eb54f13 2013/04/01 00:45:16 toy $"
;;;  "f2cl3.l,v 96616d88fb7e 2008/02/22 22:19:34 rtoy $"
;;;  "f2cl4.l,v 96616d88fb7e 2008/02/22 22:19:34 rtoy $"
;;;  "f2cl5.l,v 95098eb54f13 2013/04/01 00:45:16 toy $"
;;;  "f2cl6.l,v 1d5cbacbb977 2008/08/24 00:56:27 rtoy $"
;;;  "macros.l,v 1409c1352feb 2013/03/24 20:44:50 toy $")

;;; Using Lisp SBCL 2.0.9
;;; 
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls nil)
;;;           (:coerce-assigns :as-needed) (:array-type ':array)
;;;           (:array-slicing t) (:declare-common nil)
;;;           (:float-format single-float))

(in-package :magicl.lisp-lapack)


(defun zunmbr (vect side trans m n k a lda tau c ldc work lwork info)
  (declare (type (array f2cl-lib:complex16 (*)) work c tau a)
           (type (f2cl-lib:integer4) info lwork ldc lda k n m)
           (type (string 1) trans side vect))
  (f2cl-lib:with-multi-array-data
      ((vect character vect-%data% vect-%offset%)
       (side character side-%data% side-%offset%)
       (trans character trans-%data% trans-%offset%)
       (a f2cl-lib:complex16 a-%data% a-%offset%)
       (tau f2cl-lib:complex16 tau-%data% tau-%offset%)
       (c f2cl-lib:complex16 c-%data% c-%offset%)
       (work f2cl-lib:complex16 work-%data% work-%offset%))
    (prog ((i1 0) (i2 0) (iinfo 0) (lwkopt 0) (mi 0) (nb 0) (ni 0) (nq 0)
           (nw 0)
           (transt
            (make-array '(1) :element-type 'character :initial-element #\ ))
           (applyq nil) (left nil) (lquery nil) (notran nil))
      (declare (type f2cl-lib:logical notran lquery left applyq)
               (type (string 1) transt)
               (type (f2cl-lib:integer4) nw nq ni nb mi lwkopt iinfo i2 i1))
      (setf info 0)
      (setf applyq (lsame vect "Q"))
      (setf left (lsame side "L"))
      (setf notran (lsame trans "N"))
      (setf lquery (coerce (= lwork -1) 'f2cl-lib:logical))
      (cond (left (setf nq m) (setf nw n)) (t (setf nq n) (setf nw m)))
      (cond ((or (= m 0) (= n 0)) (setf nw 0)))
      (cond ((and (not applyq) (not (lsame vect "P"))) (setf info -1))
            ((and (not left) (not (lsame side "R"))) (setf info -2))
            ((and (not notran) (not (lsame trans "C"))) (setf info -3))
            ((< m 0) (setf info -4)) ((< n 0) (setf info -5))
            ((< k 0) (setf info -6))
            ((or
              (and applyq
                   (< lda
                      (max (the f2cl-lib:integer4 1)
                           (the f2cl-lib:integer4 nq))))
              (and (not applyq)
                   (< lda
                      (max (the f2cl-lib:integer4 1)
                           (the f2cl-lib:integer4
                                (min (the f2cl-lib:integer4 nq)
                                     (the f2cl-lib:integer4 k)))))))
             (setf info -8))
            ((< ldc (max (the f2cl-lib:integer4 1) (the f2cl-lib:integer4 m)))
             (setf info -11))
            ((and
              (< lwork
                 (max (the f2cl-lib:integer4 1) (the f2cl-lib:integer4 nw)))
              (not lquery))
             (setf info -13)))
      (cond
       ((= info 0)
        (cond
         ((> nw 0)
          (cond
           (applyq
            (cond
             (left
              (setf nb
                      (ilaenv 1 "ZUNMQR" (f2cl-lib:f2cl-// side trans)
                       (f2cl-lib:int-sub m 1) n (f2cl-lib:int-sub m 1) -1)))
             (t
              (setf nb
                      (ilaenv 1 "ZUNMQR" (f2cl-lib:f2cl-// side trans) m
                       (f2cl-lib:int-sub n 1) (f2cl-lib:int-sub n 1) -1)))))
           (t
            (cond
             (left
              (setf nb
                      (ilaenv 1 "ZUNMLQ" (f2cl-lib:f2cl-// side trans)
                       (f2cl-lib:int-sub m 1) n (f2cl-lib:int-sub m 1) -1)))
             (t
              (setf nb
                      (ilaenv 1 "ZUNMLQ" (f2cl-lib:f2cl-// side trans) m
                       (f2cl-lib:int-sub n 1) (f2cl-lib:int-sub n 1) -1))))))
          (setf lwkopt
                  (max (the f2cl-lib:integer4 1)
                       (the f2cl-lib:integer4 (f2cl-lib:int-mul nw nb)))))
         (t (setf lwkopt 1)))
        (setf (f2cl-lib:fref work-%data% (1) ((1 *)) work-%offset%)
                (coerce lwkopt 'f2cl-lib:complex16))))
      (cond
       ((/= info 0) (xerbla "ZUNMBR" (f2cl-lib:int-sub info)) (go end_label))
       (lquery (go end_label)))
      (if (or (= m 0) (= n 0))
          (go end_label))
      (cond
       (applyq
        (cond
         ((>= nq k)
          (multiple-value-bind
              (var-0 var-1 var-2 var-3 var-4 var-5 var-6 var-7 var-8 var-9
               var-10 var-11 var-12)
              (zunmqr side trans m n k a lda tau c ldc work lwork iinfo)
            (declare
             (ignore var-0 var-1 var-2 var-3 var-4 var-5 var-6 var-7 var-8
              var-9 var-10 var-11))
            (setf iinfo var-12)))
         ((> nq 1)
          (cond
           (left (setf mi (f2cl-lib:int-sub m 1)) (setf ni n) (setf i1 2)
            (setf i2 1))
           (t (setf mi m) (setf ni (f2cl-lib:int-sub n 1)) (setf i1 1)
            (setf i2 2)))
          (multiple-value-bind
              (var-0 var-1 var-2 var-3 var-4 var-5 var-6 var-7 var-8 var-9
               var-10 var-11 var-12)
              (zunmqr side trans mi ni (f2cl-lib:int-sub nq 1)
               (f2cl-lib:array-slice a-%data% f2cl-lib:complex16 (2 1)
                                     ((1 lda) (1 *)) a-%offset%)
               lda tau
               (f2cl-lib:array-slice c-%data% f2cl-lib:complex16 (i1 i2)
                                     ((1 ldc) (1 *)) c-%offset%)
               ldc work lwork iinfo)
            (declare
             (ignore var-0 var-1 var-2 var-3 var-4 var-5 var-6 var-7 var-8
              var-9 var-10 var-11))
            (setf iinfo var-12)))))
       (t
        (cond (notran (f2cl-lib:f2cl-set-string transt "C" (string 1)))
              (t (f2cl-lib:f2cl-set-string transt "N" (string 1))))
        (cond
         ((> nq k)
          (multiple-value-bind
              (var-0 var-1 var-2 var-3 var-4 var-5 var-6 var-7 var-8 var-9
               var-10 var-11 var-12)
              (zunmlq side transt m n k a lda tau c ldc work lwork iinfo)
            (declare
             (ignore var-0 var-1 var-2 var-3 var-4 var-5 var-6 var-7 var-8
              var-9 var-10 var-11))
            (setf iinfo var-12)))
         ((> nq 1)
          (cond
           (left (setf mi (f2cl-lib:int-sub m 1)) (setf ni n) (setf i1 2)
            (setf i2 1))
           (t (setf mi m) (setf ni (f2cl-lib:int-sub n 1)) (setf i1 1)
            (setf i2 2)))
          (multiple-value-bind
              (var-0 var-1 var-2 var-3 var-4 var-5 var-6 var-7 var-8 var-9
               var-10 var-11 var-12)
              (zunmlq side transt mi ni (f2cl-lib:int-sub nq 1)
               (f2cl-lib:array-slice a-%data% f2cl-lib:complex16 (1 2)
                                     ((1 lda) (1 *)) a-%offset%)
               lda tau
               (f2cl-lib:array-slice c-%data% f2cl-lib:complex16 (i1 i2)
                                     ((1 ldc) (1 *)) c-%offset%)
               ldc work lwork iinfo)
            (declare
             (ignore var-0 var-1 var-2 var-3 var-4 var-5 var-6 var-7 var-8
              var-9 var-10 var-11))
            (setf iinfo var-12))))))
      (setf (f2cl-lib:fref work-%data% (1) ((1 *)) work-%offset%)
              (coerce lwkopt 'f2cl-lib:complex16))
      (go end_label)
     end_label
      (return
       (values nil nil nil nil nil nil nil nil nil nil nil nil nil info)))))

(in-package #-gcl #:cl-user #+gcl "CL-USER")
#+#.(cl:if (cl:find-package '#:f2cl) '(and) '(or))
(eval-when (:load-toplevel :compile-toplevel :execute)
  (setf (gethash 'fortran-to-lisp::zunmbr
                 fortran-to-lisp::*f2cl-function-info*)
          (fortran-to-lisp::make-f2cl-finfo :arg-types
                                            '((string 1) (string 1) (string 1)
                                              (fortran-to-lisp::integer4)
                                              (fortran-to-lisp::integer4)
                                              (fortran-to-lisp::integer4)
                                              (array fortran-to-lisp::complex16
                                               (*))
                                              (fortran-to-lisp::integer4)
                                              (array fortran-to-lisp::complex16
                                               (*))
                                              (array fortran-to-lisp::complex16
                                               (*))
                                              (fortran-to-lisp::integer4)
                                              (array fortran-to-lisp::complex16
                                               (*))
                                              (fortran-to-lisp::integer4)
                                              (fortran-to-lisp::integer4))
                                            :return-values
                                            '(nil nil nil nil nil nil nil nil
                                              nil nil nil nil nil
                                              fortran-to-lisp::info)
                                            :calls
                                            '(fortran-to-lisp::zunmlq
                                              fortran-to-lisp::zunmqr
                                              fortran-to-lisp::xerbla
                                              fortran-to-lisp::ilaenv
                                              fortran-to-lisp::lsame))))
