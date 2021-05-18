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


(let* ((zero (f2cl-lib:cmplx 0.0 0.0)))
  (declare (type (f2cl-lib:complex8) zero)
           (ignorable zero))
  (defun ctrsv (uplo trans diag n a lda x incx)
    (declare (type (array f2cl-lib:complex8 (*)) x a)
             (type (f2cl-lib:integer4) incx lda n)
             (type (string *) diag trans uplo))
    (f2cl-lib:with-multi-array-data
        ((uplo character uplo-%data% uplo-%offset%)
         (trans character trans-%data% trans-%offset%)
         (diag character diag-%data% diag-%offset%)
         (a f2cl-lib:complex8 a-%data% a-%offset%)
         (x f2cl-lib:complex8 x-%data% x-%offset%))
      (prog ((noconj nil) (nounit nil) (i 0) (info 0) (ix 0) (j 0) (jx 0)
             (kx 0) (temp #C(0.0 0.0)))
        (declare (type f2cl-lib:logical noconj nounit)
                 (type (f2cl-lib:integer4) i info ix j jx kx)
                 (type (f2cl-lib:complex8) temp))
        (setf info 0)
        (cond
         ((and
           (not
            (multiple-value-bind (ret-val var-0 var-1)
                (lsame uplo "U")
              (declare (ignore var-1))
              (when var-0 (setf uplo var-0))
              ret-val))
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
         ((and
           (not
            (multiple-value-bind (ret-val var-0 var-1)
                (lsame diag "U")
              (declare (ignore var-1))
              (when var-0 (setf diag var-0))
              ret-val))
           (not
            (multiple-value-bind (ret-val var-0 var-1)
                (lsame diag "N")
              (declare (ignore var-1))
              (when var-0 (setf diag var-0))
              ret-val)))
          (setf info 3))
         ((< n 0) (setf info 4))
         ((< lda (max (the f2cl-lib:integer4 1) (the f2cl-lib:integer4 n)))
          (setf info 6))
         ((= incx 0) (setf info 8)))
        (cond
         ((/= info 0)
          (multiple-value-bind (var-0 var-1)
              (xerbla "CTRSV " info)
            (declare (ignore var-0))
            (when var-1 (setf info var-1)))
          (go end_label)))
        (if (= n 0)
            (go end_label))
        (setf noconj
                (multiple-value-bind (ret-val var-0 var-1)
                    (lsame trans "T")
                  (declare (ignore var-1))
                  (when var-0 (setf trans var-0))
                  ret-val))
        (setf nounit
                (multiple-value-bind (ret-val var-0 var-1)
                    (lsame diag "N")
                  (declare (ignore var-1))
                  (when var-0 (setf diag var-0))
                  ret-val))
        (cond
         ((<= incx 0)
          (setf kx
                  (f2cl-lib:int-sub 1
                                    (f2cl-lib:int-mul (f2cl-lib:int-sub n 1)
                                                      incx))))
         ((/= incx 1) (setf kx 1)))
        (cond
         ((multiple-value-bind (ret-val var-0 var-1)
              (lsame trans "N")
            (declare (ignore var-1))
            (when var-0 (setf trans var-0))
            ret-val)
          (cond
           ((multiple-value-bind (ret-val var-0 var-1)
                (lsame uplo "U")
              (declare (ignore var-1))
              (when var-0 (setf uplo var-0))
              ret-val)
            (cond
             ((= incx 1)
              (f2cl-lib:fdo (j n (f2cl-lib:int-add j (f2cl-lib:int-sub 1)))
                            ((> j 1) nil)
                (tagbody
                  (cond
                   ((/= (f2cl-lib:fref x (j) ((1 *))) zero)
                    (if nounit
                        (setf (f2cl-lib:fref x-%data% (j) ((1 *)) x-%offset%)
                                (/
                                 (f2cl-lib:fref x-%data% (j) ((1 *))
                                                x-%offset%)
                                 (f2cl-lib:fref a-%data% (j j) ((1 lda) (1 *))
                                                a-%offset%))))
                    (setf temp (f2cl-lib:fref x-%data% (j) ((1 *)) x-%offset%))
                    (f2cl-lib:fdo (i (f2cl-lib:int-add j (f2cl-lib:int-sub 1))
                                   (f2cl-lib:int-add i (f2cl-lib:int-sub 1)))
                                  ((> i 1) nil)
                      (tagbody
                        (setf (f2cl-lib:fref x-%data% (i) ((1 *)) x-%offset%)
                                (-
                                 (f2cl-lib:fref x-%data% (i) ((1 *))
                                                x-%offset%)
                                 (* temp
                                    (f2cl-lib:fref a-%data% (i j)
                                                   ((1 lda) (1 *))
                                                   a-%offset%))))
                       label10))))
                 label20)))
             (t
              (setf jx
                      (f2cl-lib:int-add kx
                                        (f2cl-lib:int-mul
                                         (f2cl-lib:int-sub n 1) incx)))
              (f2cl-lib:fdo (j n (f2cl-lib:int-add j (f2cl-lib:int-sub 1)))
                            ((> j 1) nil)
                (tagbody
                  (cond
                   ((/= (f2cl-lib:fref x (jx) ((1 *))) zero)
                    (if nounit
                        (setf (f2cl-lib:fref x-%data% (jx) ((1 *)) x-%offset%)
                                (/
                                 (f2cl-lib:fref x-%data% (jx) ((1 *))
                                                x-%offset%)
                                 (f2cl-lib:fref a-%data% (j j) ((1 lda) (1 *))
                                                a-%offset%))))
                    (setf temp
                            (f2cl-lib:fref x-%data% (jx) ((1 *)) x-%offset%))
                    (setf ix jx)
                    (f2cl-lib:fdo (i (f2cl-lib:int-add j (f2cl-lib:int-sub 1))
                                   (f2cl-lib:int-add i (f2cl-lib:int-sub 1)))
                                  ((> i 1) nil)
                      (tagbody
                        (setf ix (f2cl-lib:int-sub ix incx))
                        (setf (f2cl-lib:fref x-%data% (ix) ((1 *)) x-%offset%)
                                (-
                                 (f2cl-lib:fref x-%data% (ix) ((1 *))
                                                x-%offset%)
                                 (* temp
                                    (f2cl-lib:fref a-%data% (i j)
                                                   ((1 lda) (1 *))
                                                   a-%offset%))))
                       label30))))
                  (setf jx (f2cl-lib:int-sub jx incx))
                 label40)))))
           (t
            (cond
             ((= incx 1)
              (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                            ((> j n) nil)
                (tagbody
                  (cond
                   ((/= (f2cl-lib:fref x (j) ((1 *))) zero)
                    (if nounit
                        (setf (f2cl-lib:fref x-%data% (j) ((1 *)) x-%offset%)
                                (/
                                 (f2cl-lib:fref x-%data% (j) ((1 *))
                                                x-%offset%)
                                 (f2cl-lib:fref a-%data% (j j) ((1 lda) (1 *))
                                                a-%offset%))))
                    (setf temp (f2cl-lib:fref x-%data% (j) ((1 *)) x-%offset%))
                    (f2cl-lib:fdo (i (f2cl-lib:int-add j 1)
                                   (f2cl-lib:int-add i 1))
                                  ((> i n) nil)
                      (tagbody
                        (setf (f2cl-lib:fref x-%data% (i) ((1 *)) x-%offset%)
                                (-
                                 (f2cl-lib:fref x-%data% (i) ((1 *))
                                                x-%offset%)
                                 (* temp
                                    (f2cl-lib:fref a-%data% (i j)
                                                   ((1 lda) (1 *))
                                                   a-%offset%))))
                       label50))))
                 label60)))
             (t (setf jx kx)
              (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                            ((> j n) nil)
                (tagbody
                  (cond
                   ((/= (f2cl-lib:fref x (jx) ((1 *))) zero)
                    (if nounit
                        (setf (f2cl-lib:fref x-%data% (jx) ((1 *)) x-%offset%)
                                (/
                                 (f2cl-lib:fref x-%data% (jx) ((1 *))
                                                x-%offset%)
                                 (f2cl-lib:fref a-%data% (j j) ((1 lda) (1 *))
                                                a-%offset%))))
                    (setf temp
                            (f2cl-lib:fref x-%data% (jx) ((1 *)) x-%offset%))
                    (setf ix jx)
                    (f2cl-lib:fdo (i (f2cl-lib:int-add j 1)
                                   (f2cl-lib:int-add i 1))
                                  ((> i n) nil)
                      (tagbody
                        (setf ix (f2cl-lib:int-add ix incx))
                        (setf (f2cl-lib:fref x-%data% (ix) ((1 *)) x-%offset%)
                                (-
                                 (f2cl-lib:fref x-%data% (ix) ((1 *))
                                                x-%offset%)
                                 (* temp
                                    (f2cl-lib:fref a-%data% (i j)
                                                   ((1 lda) (1 *))
                                                   a-%offset%))))
                       label70))))
                  (setf jx (f2cl-lib:int-add jx incx))
                 label80)))))))
         (t
          (cond
           ((multiple-value-bind (ret-val var-0 var-1)
                (lsame uplo "U")
              (declare (ignore var-1))
              (when var-0 (setf uplo var-0))
              ret-val)
            (cond
             ((= incx 1)
              (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                            ((> j n) nil)
                (tagbody
                  (setf temp (f2cl-lib:fref x-%data% (j) ((1 *)) x-%offset%))
                  (cond
                   (noconj
                    (f2cl-lib:fdo (i 1 (f2cl-lib:int-add i 1))
                                  ((> i
                                      (f2cl-lib:int-add j
                                                        (f2cl-lib:int-sub 1)))
                                   nil)
                      (tagbody
                        (setf temp
                                (- temp
                                   (*
                                    (f2cl-lib:fref a-%data% (i j)
                                                   ((1 lda) (1 *)) a-%offset%)
                                    (f2cl-lib:fref x-%data% (i) ((1 *))
                                                   x-%offset%))))
                       label90))
                    (if nounit
                        (setf temp
                                (/ temp
                                   (f2cl-lib:fref a-%data% (j j)
                                                  ((1 lda) (1 *))
                                                  a-%offset%)))))
                   (t
                    (f2cl-lib:fdo (i 1 (f2cl-lib:int-add i 1))
                                  ((> i
                                      (f2cl-lib:int-add j
                                                        (f2cl-lib:int-sub 1)))
                                   nil)
                      (tagbody
                        (setf temp
                                (- temp
                                   (*
                                    (f2cl-lib:conjg
                                     (f2cl-lib:fref a-%data% (i j)
                                                    ((1 lda) (1 *))
                                                    a-%offset%))
                                    (f2cl-lib:fref x-%data% (i) ((1 *))
                                                   x-%offset%))))
                       label100))
                    (if nounit
                        (setf temp
                                (/ temp
                                   (f2cl-lib:conjg
                                    (f2cl-lib:fref a-%data% (j j)
                                                   ((1 lda) (1 *))
                                                   a-%offset%)))))))
                  (setf (f2cl-lib:fref x-%data% (j) ((1 *)) x-%offset%) temp)
                 label110)))
             (t (setf jx kx)
              (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                            ((> j n) nil)
                (tagbody
                  (setf ix kx)
                  (setf temp (f2cl-lib:fref x-%data% (jx) ((1 *)) x-%offset%))
                  (cond
                   (noconj
                    (f2cl-lib:fdo (i 1 (f2cl-lib:int-add i 1))
                                  ((> i
                                      (f2cl-lib:int-add j
                                                        (f2cl-lib:int-sub 1)))
                                   nil)
                      (tagbody
                        (setf temp
                                (- temp
                                   (*
                                    (f2cl-lib:fref a-%data% (i j)
                                                   ((1 lda) (1 *)) a-%offset%)
                                    (f2cl-lib:fref x-%data% (ix) ((1 *))
                                                   x-%offset%))))
                        (setf ix (f2cl-lib:int-add ix incx))
                       label120))
                    (if nounit
                        (setf temp
                                (/ temp
                                   (f2cl-lib:fref a-%data% (j j)
                                                  ((1 lda) (1 *))
                                                  a-%offset%)))))
                   (t
                    (f2cl-lib:fdo (i 1 (f2cl-lib:int-add i 1))
                                  ((> i
                                      (f2cl-lib:int-add j
                                                        (f2cl-lib:int-sub 1)))
                                   nil)
                      (tagbody
                        (setf temp
                                (- temp
                                   (*
                                    (f2cl-lib:conjg
                                     (f2cl-lib:fref a-%data% (i j)
                                                    ((1 lda) (1 *))
                                                    a-%offset%))
                                    (f2cl-lib:fref x-%data% (ix) ((1 *))
                                                   x-%offset%))))
                        (setf ix (f2cl-lib:int-add ix incx))
                       label130))
                    (if nounit
                        (setf temp
                                (/ temp
                                   (f2cl-lib:conjg
                                    (f2cl-lib:fref a-%data% (j j)
                                                   ((1 lda) (1 *))
                                                   a-%offset%)))))))
                  (setf (f2cl-lib:fref x-%data% (jx) ((1 *)) x-%offset%) temp)
                  (setf jx (f2cl-lib:int-add jx incx))
                 label140)))))
           (t
            (cond
             ((= incx 1)
              (f2cl-lib:fdo (j n (f2cl-lib:int-add j (f2cl-lib:int-sub 1)))
                            ((> j 1) nil)
                (tagbody
                  (setf temp (f2cl-lib:fref x-%data% (j) ((1 *)) x-%offset%))
                  (cond
                   (noconj
                    (f2cl-lib:fdo (i n
                                   (f2cl-lib:int-add i (f2cl-lib:int-sub 1)))
                                  ((> i (f2cl-lib:int-add j 1)) nil)
                      (tagbody
                        (setf temp
                                (- temp
                                   (*
                                    (f2cl-lib:fref a-%data% (i j)
                                                   ((1 lda) (1 *)) a-%offset%)
                                    (f2cl-lib:fref x-%data% (i) ((1 *))
                                                   x-%offset%))))
                       label150))
                    (if nounit
                        (setf temp
                                (/ temp
                                   (f2cl-lib:fref a-%data% (j j)
                                                  ((1 lda) (1 *))
                                                  a-%offset%)))))
                   (t
                    (f2cl-lib:fdo (i n
                                   (f2cl-lib:int-add i (f2cl-lib:int-sub 1)))
                                  ((> i (f2cl-lib:int-add j 1)) nil)
                      (tagbody
                        (setf temp
                                (- temp
                                   (*
                                    (f2cl-lib:conjg
                                     (f2cl-lib:fref a-%data% (i j)
                                                    ((1 lda) (1 *))
                                                    a-%offset%))
                                    (f2cl-lib:fref x-%data% (i) ((1 *))
                                                   x-%offset%))))
                       label160))
                    (if nounit
                        (setf temp
                                (/ temp
                                   (f2cl-lib:conjg
                                    (f2cl-lib:fref a-%data% (j j)
                                                   ((1 lda) (1 *))
                                                   a-%offset%)))))))
                  (setf (f2cl-lib:fref x-%data% (j) ((1 *)) x-%offset%) temp)
                 label170)))
             (t
              (setf kx
                      (f2cl-lib:int-add kx
                                        (f2cl-lib:int-mul
                                         (f2cl-lib:int-sub n 1) incx)))
              (setf jx kx)
              (f2cl-lib:fdo (j n (f2cl-lib:int-add j (f2cl-lib:int-sub 1)))
                            ((> j 1) nil)
                (tagbody
                  (setf ix kx)
                  (setf temp (f2cl-lib:fref x-%data% (jx) ((1 *)) x-%offset%))
                  (cond
                   (noconj
                    (f2cl-lib:fdo (i n
                                   (f2cl-lib:int-add i (f2cl-lib:int-sub 1)))
                                  ((> i (f2cl-lib:int-add j 1)) nil)
                      (tagbody
                        (setf temp
                                (- temp
                                   (*
                                    (f2cl-lib:fref a-%data% (i j)
                                                   ((1 lda) (1 *)) a-%offset%)
                                    (f2cl-lib:fref x-%data% (ix) ((1 *))
                                                   x-%offset%))))
                        (setf ix (f2cl-lib:int-sub ix incx))
                       label180))
                    (if nounit
                        (setf temp
                                (/ temp
                                   (f2cl-lib:fref a-%data% (j j)
                                                  ((1 lda) (1 *))
                                                  a-%offset%)))))
                   (t
                    (f2cl-lib:fdo (i n
                                   (f2cl-lib:int-add i (f2cl-lib:int-sub 1)))
                                  ((> i (f2cl-lib:int-add j 1)) nil)
                      (tagbody
                        (setf temp
                                (- temp
                                   (*
                                    (f2cl-lib:conjg
                                     (f2cl-lib:fref a-%data% (i j)
                                                    ((1 lda) (1 *))
                                                    a-%offset%))
                                    (f2cl-lib:fref x-%data% (ix) ((1 *))
                                                   x-%offset%))))
                        (setf ix (f2cl-lib:int-sub ix incx))
                       label190))
                    (if nounit
                        (setf temp
                                (/ temp
                                   (f2cl-lib:conjg
                                    (f2cl-lib:fref a-%data% (j j)
                                                   ((1 lda) (1 *))
                                                   a-%offset%)))))))
                  (setf (f2cl-lib:fref x-%data% (jx) ((1 *)) x-%offset%) temp)
                  (setf jx (f2cl-lib:int-sub jx incx))
                 label200))))))))
        (go end_label)
       end_label
        (return (values uplo trans diag nil nil nil nil nil))))))

(in-package #-gcl #:cl-user #+gcl "CL-USER")
#+#.(cl:if (cl:find-package '#:f2cl) '(and) '(or))
(eval-when (:load-toplevel :compile-toplevel :execute)
  (setf (gethash 'fortran-to-lisp::ctrsv fortran-to-lisp::*f2cl-function-info*)
          (fortran-to-lisp::make-f2cl-finfo :arg-types
                                            '((string) (string) (string)
                                              (fortran-to-lisp::integer4)
                                              (array fortran-to-lisp::complex8
                                               (*))
                                              (fortran-to-lisp::integer4)
                                              (array fortran-to-lisp::complex8
                                               (*))
                                              (fortran-to-lisp::integer4))
                                            :return-values
                                            '(fortran-to-lisp::uplo
                                              fortran-to-lisp::trans
                                              fortran-to-lisp::diag nil nil nil
                                              nil nil)
                                            :calls 'nil)))
