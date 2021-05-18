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
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;           (:coerce-assigns :as-needed) (:array-type ':array)
;;;           (:array-slicing t) (:declare-common nil)
;;;           (:float-format single-float))

(in-package :magicl.lisp-blas)


(let* ((zero 0.0))
  (declare (type (single-float 0.0 0.0) zero)
           (ignorable zero))
  (defun ssyr (uplo n alpha x incx a lda)
    (declare (type (array single-float (*)) a x)
             (type (single-float) alpha)
             (type (f2cl-lib:integer4) lda incx n)
             (type (string *) uplo))
    (f2cl-lib:with-multi-array-data
        ((uplo character uplo-%data% uplo-%offset%)
         (x single-float x-%data% x-%offset%)
         (a single-float a-%data% a-%offset%))
      (prog ((i 0) (info 0) (ix 0) (j 0) (jx 0) (kx 0) (temp 0.0))
        (declare (type (f2cl-lib:integer4) i info ix j jx kx)
                 (type (single-float) temp))
        (setf info 0)
        (cond
         ((and (not (lsame uplo "U")) (not (lsame uplo "L"))) (setf info 1))
         ((< n 0) (setf info 2)) ((= incx 0) (setf info 5))
         ((< lda (max (the f2cl-lib:integer4 1) (the f2cl-lib:integer4 n)))
          (setf info 7)))
        (cond
         ((/= info 0)
          (multiple-value-bind (var-0 var-1)
              (xerbla "SSYR  " info)
            (declare (ignore var-0))
            (when var-1 (setf info var-1)))
          (go end_label)))
        (if (or (= n 0) (= alpha zero))
            (go end_label))
        (cond
         ((<= incx 0)
          (setf kx
                  (f2cl-lib:int-sub 1
                                    (f2cl-lib:int-mul (f2cl-lib:int-sub n 1)
                                                      incx))))
         ((/= incx 1) (setf kx 1)))
        (cond
         ((lsame uplo "U")
          (cond
           ((= incx 1)
            (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                          ((> j n) nil)
              (tagbody
                (cond
                 ((/= (f2cl-lib:fref x (j) ((1 *))) zero)
                  (setf temp
                          (* alpha
                             (f2cl-lib:fref x-%data% (j) ((1 *)) x-%offset%)))
                  (f2cl-lib:fdo (i 1 (f2cl-lib:int-add i 1))
                                ((> i j) nil)
                    (tagbody
                      (setf (f2cl-lib:fref a-%data% (i j) ((1 lda) (1 *))
                                           a-%offset%)
                              (+
                               (f2cl-lib:fref a-%data% (i j) ((1 lda) (1 *))
                                              a-%offset%)
                               (*
                                (f2cl-lib:fref x-%data% (i) ((1 *)) x-%offset%)
                                temp)))
                     label10))))
               label20)))
           (t (setf jx kx)
            (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                          ((> j n) nil)
              (tagbody
                (cond
                 ((/= (f2cl-lib:fref x (jx) ((1 *))) zero)
                  (setf temp
                          (* alpha
                             (f2cl-lib:fref x-%data% (jx) ((1 *)) x-%offset%)))
                  (setf ix kx)
                  (f2cl-lib:fdo (i 1 (f2cl-lib:int-add i 1))
                                ((> i j) nil)
                    (tagbody
                      (setf (f2cl-lib:fref a-%data% (i j) ((1 lda) (1 *))
                                           a-%offset%)
                              (+
                               (f2cl-lib:fref a-%data% (i j) ((1 lda) (1 *))
                                              a-%offset%)
                               (*
                                (f2cl-lib:fref x-%data% (ix) ((1 *))
                                               x-%offset%)
                                temp)))
                      (setf ix (f2cl-lib:int-add ix incx))
                     label30))))
                (setf jx (f2cl-lib:int-add jx incx))
               label40)))))
         (t
          (cond
           ((= incx 1)
            (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                          ((> j n) nil)
              (tagbody
                (cond
                 ((/= (f2cl-lib:fref x (j) ((1 *))) zero)
                  (setf temp
                          (* alpha
                             (f2cl-lib:fref x-%data% (j) ((1 *)) x-%offset%)))
                  (f2cl-lib:fdo (i j (f2cl-lib:int-add i 1))
                                ((> i n) nil)
                    (tagbody
                      (setf (f2cl-lib:fref a-%data% (i j) ((1 lda) (1 *))
                                           a-%offset%)
                              (+
                               (f2cl-lib:fref a-%data% (i j) ((1 lda) (1 *))
                                              a-%offset%)
                               (*
                                (f2cl-lib:fref x-%data% (i) ((1 *)) x-%offset%)
                                temp)))
                     label50))))
               label60)))
           (t (setf jx kx)
            (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                          ((> j n) nil)
              (tagbody
                (cond
                 ((/= (f2cl-lib:fref x (jx) ((1 *))) zero)
                  (setf temp
                          (* alpha
                             (f2cl-lib:fref x-%data% (jx) ((1 *)) x-%offset%)))
                  (setf ix jx)
                  (f2cl-lib:fdo (i j (f2cl-lib:int-add i 1))
                                ((> i n) nil)
                    (tagbody
                      (setf (f2cl-lib:fref a-%data% (i j) ((1 lda) (1 *))
                                           a-%offset%)
                              (+
                               (f2cl-lib:fref a-%data% (i j) ((1 lda) (1 *))
                                              a-%offset%)
                               (*
                                (f2cl-lib:fref x-%data% (ix) ((1 *))
                                               x-%offset%)
                                temp)))
                      (setf ix (f2cl-lib:int-add ix incx))
                     label70))))
                (setf jx (f2cl-lib:int-add jx incx))
               label80))))))
        (go end_label)
       end_label
        (return (values nil nil nil nil nil nil nil))))))

(in-package #-gcl #:cl-user #+gcl "CL-USER")
#+#.(cl:if (cl:find-package '#:f2cl) '(and) '(or))
(eval-when (:load-toplevel :compile-toplevel :execute)
  (setf (gethash 'fortran-to-lisp::ssyr fortran-to-lisp::*f2cl-function-info*)
          (fortran-to-lisp::make-f2cl-finfo :arg-types
                                            '((string)
                                              (fortran-to-lisp::integer4)
                                              (single-float)
                                              (array single-float (*))
                                              (fortran-to-lisp::integer4)
                                              (array single-float (*))
                                              (fortran-to-lisp::integer4))
                                            :return-values
                                            '(nil nil nil nil nil nil nil)
                                            :calls '(fortran-to-lisp::lsame))))
