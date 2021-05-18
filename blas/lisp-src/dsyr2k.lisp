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


(let* ((one 1.0d0) (zero 0.0d0))
  (declare (type (double-float 1.0d0 1.0d0) one)
           (type (double-float 0.0d0 0.0d0) zero)
           (ignorable one zero))
  (defun dsyr2k (uplo trans n k alpha a lda b ldb$ beta c ldc)
    (declare (type (array double-float (*)) c b a)
             (type (double-float) beta alpha)
             (type (f2cl-lib:integer4) ldc ldb$ lda k n)
             (type (string *) trans uplo))
    (f2cl-lib:with-multi-array-data
        ((uplo character uplo-%data% uplo-%offset%)
         (trans character trans-%data% trans-%offset%)
         (a double-float a-%data% a-%offset%)
         (b double-float b-%data% b-%offset%)
         (c double-float c-%data% c-%offset%))
      (prog ((upper nil) (i 0) (info 0) (j 0) (l 0) (nrowa 0) (temp1 0.0d0)
             (temp2 0.0d0))
        (declare (type f2cl-lib:logical upper)
                 (type (f2cl-lib:integer4) i info j l nrowa)
                 (type (double-float) temp1 temp2))
        (cond
         ((multiple-value-bind (ret-val var-0 var-1)
              (lsame trans "N")
            (declare (ignore var-1))
            (when var-0 (setf trans var-0))
            ret-val)
          (setf nrowa n))
         (t (setf nrowa k)))
        (setf upper
                (multiple-value-bind (ret-val var-0 var-1)
                    (lsame uplo "U")
                  (declare (ignore var-1))
                  (when var-0 (setf uplo var-0))
                  ret-val))
        (setf info 0)
        (cond
         ((and (not upper)
               (not
                (multiple-value-bind (ret-val var-0 var-1)
                    (lsame uplo "L")
                  (declare (ignore var-1))
                  (when var-0 (setf uplo var-0))
                  ret-val)))
          (setf info 1))
         ((and
           (not
            (multiple-value-bind (ret-val var-0 var-1)
                (lsame trans "N")
              (declare (ignore var-1))
              (when var-0 (setf trans var-0))
              ret-val))
           (not
            (multiple-value-bind (ret-val var-0 var-1)
                (lsame trans "T")
              (declare (ignore var-1))
              (when var-0 (setf trans var-0))
              ret-val))
           (not
            (multiple-value-bind (ret-val var-0 var-1)
                (lsame trans "C")
              (declare (ignore var-1))
              (when var-0 (setf trans var-0))
              ret-val)))
          (setf info 2))
         ((< n 0) (setf info 3)) ((< k 0) (setf info 4))
         ((< lda (max (the f2cl-lib:integer4 1) (the f2cl-lib:integer4 nrowa)))
          (setf info 7))
         ((< ldb$
             (max (the f2cl-lib:integer4 1) (the f2cl-lib:integer4 nrowa)))
          (setf info 9))
         ((< ldc (max (the f2cl-lib:integer4 1) (the f2cl-lib:integer4 n)))
          (setf info 12)))
        (cond
         ((/= info 0)
          (multiple-value-bind (var-0 var-1)
              (xerbla "DSYR2K" info)
            (declare (ignore var-0))
            (when var-1 (setf info var-1)))
          (go end_label)))
        (if (or (= n 0) (and (or (= alpha zero) (= k 0)) (= beta one)))
            (go end_label))
        (cond
         ((= alpha zero)
          (cond
           (upper
            (cond
             ((= beta zero)
              (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                            ((> j n) nil)
                (tagbody
                  (f2cl-lib:fdo (i 1 (f2cl-lib:int-add i 1))
                                ((> i j) nil)
                    (tagbody
                      (setf (f2cl-lib:fref c-%data% (i j) ((1 ldc) (1 *))
                                           c-%offset%)
                              zero)
                     label10))
                 label20)))
             (t
              (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                            ((> j n) nil)
                (tagbody
                  (f2cl-lib:fdo (i 1 (f2cl-lib:int-add i 1))
                                ((> i j) nil)
                    (tagbody
                      (setf (f2cl-lib:fref c-%data% (i j) ((1 ldc) (1 *))
                                           c-%offset%)
                              (* beta
                                 (f2cl-lib:fref c-%data% (i j) ((1 ldc) (1 *))
                                                c-%offset%)))
                     label30))
                 label40)))))
           (t
            (cond
             ((= beta zero)
              (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                            ((> j n) nil)
                (tagbody
                  (f2cl-lib:fdo (i j (f2cl-lib:int-add i 1))
                                ((> i n) nil)
                    (tagbody
                      (setf (f2cl-lib:fref c-%data% (i j) ((1 ldc) (1 *))
                                           c-%offset%)
                              zero)
                     label50))
                 label60)))
             (t
              (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                            ((> j n) nil)
                (tagbody
                  (f2cl-lib:fdo (i j (f2cl-lib:int-add i 1))
                                ((> i n) nil)
                    (tagbody
                      (setf (f2cl-lib:fref c-%data% (i j) ((1 ldc) (1 *))
                                           c-%offset%)
                              (* beta
                                 (f2cl-lib:fref c-%data% (i j) ((1 ldc) (1 *))
                                                c-%offset%)))
                     label70))
                 label80))))))
          (go end_label)))
        (cond
         ((multiple-value-bind (ret-val var-0 var-1)
              (lsame trans "N")
            (declare (ignore var-1))
            (when var-0 (setf trans var-0))
            ret-val)
          (cond
           (upper
            (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                          ((> j n) nil)
              (tagbody
                (cond
                 ((= beta zero)
                  (f2cl-lib:fdo (i 1 (f2cl-lib:int-add i 1))
                                ((> i j) nil)
                    (tagbody
                      (setf (f2cl-lib:fref c-%data% (i j) ((1 ldc) (1 *))
                                           c-%offset%)
                              zero)
                     label90)))
                 ((/= beta one)
                  (f2cl-lib:fdo (i 1 (f2cl-lib:int-add i 1))
                                ((> i j) nil)
                    (tagbody
                      (setf (f2cl-lib:fref c-%data% (i j) ((1 ldc) (1 *))
                                           c-%offset%)
                              (* beta
                                 (f2cl-lib:fref c-%data% (i j) ((1 ldc) (1 *))
                                                c-%offset%)))
                     label100))))
                (f2cl-lib:fdo (l 1 (f2cl-lib:int-add l 1))
                              ((> l k) nil)
                  (tagbody
                    (cond
                     ((or (/= (f2cl-lib:fref a (j l) ((1 lda) (1 *))) zero)
                          (/= (f2cl-lib:fref b (j l) ((1 ldb$) (1 *))) zero))
                      (setf temp1
                              (* alpha
                                 (f2cl-lib:fref b-%data% (j l) ((1 ldb$) (1 *))
                                                b-%offset%)))
                      (setf temp2
                              (* alpha
                                 (f2cl-lib:fref a-%data% (j l) ((1 lda) (1 *))
                                                a-%offset%)))
                      (f2cl-lib:fdo (i 1 (f2cl-lib:int-add i 1))
                                    ((> i j) nil)
                        (tagbody
                          (setf (f2cl-lib:fref c-%data% (i j) ((1 ldc) (1 *))
                                               c-%offset%)
                                  (+
                                   (f2cl-lib:fref c-%data% (i j)
                                                  ((1 ldc) (1 *)) c-%offset%)
                                   (*
                                    (f2cl-lib:fref a-%data% (i l)
                                                   ((1 lda) (1 *)) a-%offset%)
                                    temp1)
                                   (*
                                    (f2cl-lib:fref b-%data% (i l)
                                                   ((1 ldb$) (1 *)) b-%offset%)
                                    temp2)))
                         label110))))
                   label120))
               label130)))
           (t
            (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                          ((> j n) nil)
              (tagbody
                (cond
                 ((= beta zero)
                  (f2cl-lib:fdo (i j (f2cl-lib:int-add i 1))
                                ((> i n) nil)
                    (tagbody
                      (setf (f2cl-lib:fref c-%data% (i j) ((1 ldc) (1 *))
                                           c-%offset%)
                              zero)
                     label140)))
                 ((/= beta one)
                  (f2cl-lib:fdo (i j (f2cl-lib:int-add i 1))
                                ((> i n) nil)
                    (tagbody
                      (setf (f2cl-lib:fref c-%data% (i j) ((1 ldc) (1 *))
                                           c-%offset%)
                              (* beta
                                 (f2cl-lib:fref c-%data% (i j) ((1 ldc) (1 *))
                                                c-%offset%)))
                     label150))))
                (f2cl-lib:fdo (l 1 (f2cl-lib:int-add l 1))
                              ((> l k) nil)
                  (tagbody
                    (cond
                     ((or (/= (f2cl-lib:fref a (j l) ((1 lda) (1 *))) zero)
                          (/= (f2cl-lib:fref b (j l) ((1 ldb$) (1 *))) zero))
                      (setf temp1
                              (* alpha
                                 (f2cl-lib:fref b-%data% (j l) ((1 ldb$) (1 *))
                                                b-%offset%)))
                      (setf temp2
                              (* alpha
                                 (f2cl-lib:fref a-%data% (j l) ((1 lda) (1 *))
                                                a-%offset%)))
                      (f2cl-lib:fdo (i j (f2cl-lib:int-add i 1))
                                    ((> i n) nil)
                        (tagbody
                          (setf (f2cl-lib:fref c-%data% (i j) ((1 ldc) (1 *))
                                               c-%offset%)
                                  (+
                                   (f2cl-lib:fref c-%data% (i j)
                                                  ((1 ldc) (1 *)) c-%offset%)
                                   (*
                                    (f2cl-lib:fref a-%data% (i l)
                                                   ((1 lda) (1 *)) a-%offset%)
                                    temp1)
                                   (*
                                    (f2cl-lib:fref b-%data% (i l)
                                                   ((1 ldb$) (1 *)) b-%offset%)
                                    temp2)))
                         label160))))
                   label170))
               label180)))))
         (t
          (cond
           (upper
            (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                          ((> j n) nil)
              (tagbody
                (f2cl-lib:fdo (i 1 (f2cl-lib:int-add i 1))
                              ((> i j) nil)
                  (tagbody
                    (setf temp1 zero)
                    (setf temp2 zero)
                    (f2cl-lib:fdo (l 1 (f2cl-lib:int-add l 1))
                                  ((> l k) nil)
                      (tagbody
                        (setf temp1
                                (+ temp1
                                   (*
                                    (f2cl-lib:fref a-%data% (l i)
                                                   ((1 lda) (1 *)) a-%offset%)
                                    (f2cl-lib:fref b-%data% (l j)
                                                   ((1 ldb$) (1 *))
                                                   b-%offset%))))
                        (setf temp2
                                (+ temp2
                                   (*
                                    (f2cl-lib:fref b-%data% (l i)
                                                   ((1 ldb$) (1 *)) b-%offset%)
                                    (f2cl-lib:fref a-%data% (l j)
                                                   ((1 lda) (1 *))
                                                   a-%offset%))))
                       label190))
                    (cond
                     ((= beta zero)
                      (setf (f2cl-lib:fref c-%data% (i j) ((1 ldc) (1 *))
                                           c-%offset%)
                              (+ (* alpha temp1) (* alpha temp2))))
                     (t
                      (setf (f2cl-lib:fref c-%data% (i j) ((1 ldc) (1 *))
                                           c-%offset%)
                              (+
                               (* beta
                                  (f2cl-lib:fref c-%data% (i j) ((1 ldc) (1 *))
                                                 c-%offset%))
                               (* alpha temp1) (* alpha temp2)))))
                   label200))
               label210)))
           (t
            (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                          ((> j n) nil)
              (tagbody
                (f2cl-lib:fdo (i j (f2cl-lib:int-add i 1))
                              ((> i n) nil)
                  (tagbody
                    (setf temp1 zero)
                    (setf temp2 zero)
                    (f2cl-lib:fdo (l 1 (f2cl-lib:int-add l 1))
                                  ((> l k) nil)
                      (tagbody
                        (setf temp1
                                (+ temp1
                                   (*
                                    (f2cl-lib:fref a-%data% (l i)
                                                   ((1 lda) (1 *)) a-%offset%)
                                    (f2cl-lib:fref b-%data% (l j)
                                                   ((1 ldb$) (1 *))
                                                   b-%offset%))))
                        (setf temp2
                                (+ temp2
                                   (*
                                    (f2cl-lib:fref b-%data% (l i)
                                                   ((1 ldb$) (1 *)) b-%offset%)
                                    (f2cl-lib:fref a-%data% (l j)
                                                   ((1 lda) (1 *))
                                                   a-%offset%))))
                       label220))
                    (cond
                     ((= beta zero)
                      (setf (f2cl-lib:fref c-%data% (i j) ((1 ldc) (1 *))
                                           c-%offset%)
                              (+ (* alpha temp1) (* alpha temp2))))
                     (t
                      (setf (f2cl-lib:fref c-%data% (i j) ((1 ldc) (1 *))
                                           c-%offset%)
                              (+
                               (* beta
                                  (f2cl-lib:fref c-%data% (i j) ((1 ldc) (1 *))
                                                 c-%offset%))
                               (* alpha temp1) (* alpha temp2)))))
                   label230))
               label240))))))
        (go end_label)
       end_label
        (return (values uplo trans nil nil nil nil nil nil nil nil nil nil))))))

(in-package #-gcl #:cl-user #+gcl "CL-USER")
#+#.(cl:if (cl:find-package '#:f2cl) '(and) '(or))
(eval-when (:load-toplevel :compile-toplevel :execute)
  (setf (gethash 'fortran-to-lisp::dsyr2k
                 fortran-to-lisp::*f2cl-function-info*)
          (fortran-to-lisp::make-f2cl-finfo :arg-types
                                            '((string) (string)
                                              (fortran-to-lisp::integer4)
                                              (fortran-to-lisp::integer4)
                                              (double-float)
                                              (array double-float (*))
                                              (fortran-to-lisp::integer4)
                                              (array double-float (*))
                                              (fortran-to-lisp::integer4)
                                              (double-float)
                                              (array double-float (*))
                                              (fortran-to-lisp::integer4))
                                            :return-values
                                            '(fortran-to-lisp::uplo
                                              fortran-to-lisp::trans nil nil
                                              nil nil nil nil nil nil nil nil)
                                            :calls 'nil)))
