(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload :f2cl :silent t))

(defpackage #:magicl.build-lapack
  (:use #:cl)
  (:export #:build-lisp-sources #:print-system-definition #:print-package-definition))

(in-package #:magicl.build-lapack)

;;; TODO: relative to this system?
(defparameter *fortran-source-dir*
  (asdf:system-relative-pathname '#:magicl "lapack/fortran-src/"))

(defparameter *lisp-source-dir*
  (asdf:system-relative-pathname '#:magicl "lapack/lisp-src/"))

(defvar *lapack-dependencies*
  '((dbdsqr dlasr dlamch dlas2 dlasq1 dlasv2 dlartg)
    (dgebak)
    (dgebal dlamch)
    (dgebd2 dlarf dlarfg)
    (dgebrd dgebd2 dlabrd ilaenv)
    (dgeev dlamch dlange dlascl dlabad dgebal dlacpy dgebak dlapy2 dtrevc dorghr dgehrd dhseqr ilaenv dlartg)
    (dgehd2 dlarf dlarfg)
    (dgehrd dgehd2 ilaenv dlarfb dlahrd)
    (dgelq2 dlarf dlarfg)
    (dgelqf dgelq2 ilaenv dlarfb dlarft)
    (dgeqr2 dlarf dlarfg)
    (dgeqrf dgeqr2 ilaenv dlarfb dlarft)
    (dgesvd dorgbr dlamch dlaset dlange dlascl dgelqf dorglq dormbr dbdsqr dlacpy dgebrd ilaenv dgeqrf dorgqr)
    (dgetf2)
    (dgetrf dgetf2 dlaswp ilaenv)
    (dhseqr dlamch dlapy2 dlarfg dlanhs dlaset dlarfx dlahqr dlabad ilaenv dlacpy)
    (disnan dlaisnan)
    (dlabad)
    (dlabrd dlarfg)
    (dlacpy)
    (dladiv)
    (dlae2)
    (dlaev2)
    (dlahqr dlamch dlarfg dlanhs dlabad dlanv2)
    (dlahrd dlarfg)
    (dlaisnan)
    (dlaln2 dladiv dlamch)
    (dlamch)
    (dlange dlassq)
    (dlanhs dlassq)
    (dlanst dlassq)
    (dlanv2 dlamch dlapy2)
    (dlapy2)
    (dlapy3)
    (dlarf)
    (dlarfb)
    (dlarfg dlamch dlapy2)
    (dlarft)
    (dlarfx)
    (dlartg dlamch)
    (dlas2)
    (dlascl disnan dlamch)
    (dlaset)
    (dlasq1 dlamch dlas2 dlasrt dlasq2)
    (dlasq2 dlamch ilaenv dlasrt dlasq3)
    (dlasq3 dlasq4 dlasq5 dlamch dlasq6)
    (dlasq4)
    (dlasq5)
    (dlasq6 dlamch)
    (dlasr)
    (dlasrt)
    (dlassq)
    (dlasv2 dlamch)
    (dlaswp)
    (dorg2r dlarf)
    (dorgbr dorgqr dorglq ilaenv)
    (dorghr ilaenv dorgqr)
    (dorgl2 dlarf)
    (dorglq dorgl2 ilaenv dlarfb dlarft)
    (dorgqr dlarfb ilaenv dorg2r dlarft)
    (dorm2r dlarf)
    (dormbr dormlq ilaenv dormqr)
    (dorml2 dlarf)
    (dormlq dorml2 ilaenv dlarfb dlarft)
    (dormqr dorm2r ilaenv dlarfb dlarft)
    (dsterf dlamch dlapy2 dlascl dlasrt dlanst dlae2)
    (dtrevc dlamch dlabad dlaln2)
    (ieeeck)
    (ilaenv ieeeck)
    (ilazlc)
    (ilazlr)
    (zbdsqr dlamch dlas2 dlasq1 zlasr dlasv2 dlartg)
    (zgebak)
    (zgebal disnan dlamch)
    (zgebd2 zlarfg zlarf zlacgv)
    (zgebrd zgebd2 zlabrd ilaenv)
    (zgeev zgebak dlamch zgebal dlabad zgehrd zhseqr zlange ztrevc zunghr ilaenv zlascl zlacpy)
    (zgehd2 zlarfg zlarf)
    (zgehrd zlarfb zgehd2 ilaenv zlahr2)
    (zgelq2 zlarfg zlarf zlacgv)
    (zgelqf zlarfb zlarft ilaenv zgelq2)
    (zgeqr2 zlarfg zlarf)
    (zgeqrf zlarfb zlarft ilaenv zgeqr2)
    (zgesvd zungbr zunmbr dlamch zbdsqr zgebrd dlascl zungqr zlange zunglq zlaset ilaenv zlascl zlacpy zgeqrf zgelqf)
    (zgetf2 dlamch)
    (zgetrf zgetf2 zlaswp ilaenv)
    (zheev dlamch ilaenv dsterf zhetrd zlascl zungtr zlanhe zsteqr)
    (zhetd2 zlarfg)
    (zhetrd zlatrd ilaenv zhetd2)
    (zhseqr zlahqr zlaset ilaenv zlaqr0 zlacpy)
    (zlabrd zlarfg zlacgv)
    (zlacgv)
    (zlacpy)
    (zladiv dladiv)
    (zlahqr dlamch zlarfg dlabad zladiv)
    (zlahr2 zlarfg zlacgv zlacpy)
    (zlange zlassq)
    (zlanhe zlassq)
    (zlaqr0 zlahqr zlaqr3 zlaqr5 ilaenv zlacpy zlaqr4)
    (zlaqr1)
    (zlaqr2 zunmhr dlamch ztrexc zlahqr zlarfg dlabad zlaset zlarf zlacpy zgehrd)
    (zlaqr3 zunmhr dlamch ztrexc zlahqr zlarfg dlabad zlaqr4 zlaset ilaenv zlarf zlacpy zgehrd)
    (zlaqr4 zlahqr zlaqr2 zlaqr5 ilaenv zlacpy)
    (zlaqr5 dlamch zlaqr1 zlarfg dlabad zlaset zlacpy)
    (zlarf ilazlr ilazlc)
    (zlarfb zlacgv ilazlr ilazlc)
    (zlarfg dlamch dlapy3 zladiv)
    (zlarft zlacgv)
    (zlartg dlamch dlapy2)
    (zlascl disnan dlamch)
    (zlaset)
    (zlasr)
    (zlassq)
    (zlaswp)
    (zlatrd zlarfg zlacgv)
    (zlatrs dlamch zladiv)
    (zrot)
    (zsteqr dlamch dlapy2 dlascl dlaev2 zlaset zlasr dlasrt dlartg dlanst dlae2)
    (ztrevc dlamch zlatrs)
    (ztrexc zlartg zrot)
    (zung2l zlarf)
    (zung2r zlarf)
    (zungbr zungqr zunglq ilaenv)
    (zunghr zungqr ilaenv)
    (zungl2 zlarf zlacgv)
    (zunglq zungl2 zlarfb zlarft ilaenv)
    (zungql zlarfb zlarft ilaenv zung2l)
    (zungqr zlarfb zlarft zung2r ilaenv)
    (zungtr zungqr zungql ilaenv)
    (zunm2r zlarf)
    (zunmbr zunmlq zunmqr ilaenv)
    (zunmhr ilaenv zunmqr)
    (zunml2 zlarf zlacgv)
    (zunmlq zlarfb zlarft zunml2 ilaenv)
    (zunmqr zunm2r zlarfb zlarft ilaenv))
  "Association of LAPACK routines to the list of LAPACK routines which they call.")

(defun build-lisp-sources ()
  "Build Lisp sources from Fortran sources."
  (uiop:delete-directory-tree *lisp-source-dir* :validate t :if-does-not-exist :ignore)
  (ensure-directories-exist *lisp-source-dir*)
  (loop :for routine :in (dependency-ordered-lapack-routines)
        :for input-file := (merge-pathnames (format nil "~(~A~).f" routine) *fortran-source-dir*)
        :for output-name := (concatenate 'string (pathname-name input-file) ".lisp")
        :for output-file := (merge-pathnames output-name *lisp-source-dir*)
        :do (f2cl:f2cl input-file :output-file output-file
                                  :package :magicl.lisp-lapack
                                  :common-as-array t ; per f2cl test suite
                                  :relaxed-array-decls nil ; per f2cl test suite
                                  )))

(defun print-system-definition ()
  "Print an ASDF system definition for Lisp LAPACK routines."
  (let ((*print-case* :downcase))
    (print
     `(asdf:defsystem #:magicl/lisp-lapack
        :description "Lisp LAPACK routines in MAGICL"
        :depends-on (#:f2cl #:magicl/lisp-blas)
        :serial t
        :pathname "lapack/"
        :components
        ((:file "package")
         (:file "fortran-intrinsics")
         ,@(loop :for routine :in (dependency-ordered-lapack-routines)
                 :collect (list :file (concatenate 'string
                                                   "lisp-src/"
                                                   (string-downcase (symbol-name routine))))))))
    nil))


(defun print-package-definition ()
  "Print a package definition for exported LAPACK routines."
  (let ((*print-case* :downcase))
    (print
     `(defpackage #:magicl.lisp-lapack
        (:use #:cl #:magicl.lisp-blas)
        (:export
         ,@(sort (mapcar (lambda (x)
                           (make-symbol (symbol-name (car x))))
                         *lapack-dependencies*)
                 #'string< :key #'symbol-name))))
    nil))

(defun whitelisted-lapack-routines (&key (in-f2cl nil))
  (loop :for (sym . rest) :in *lapack-dependencies*
        :collect (if in-f2cl
                     (find-symbol (symbol-name sym) 'f2cl)
                     (make-symbol (symbol-name sym)))))

(defun dependency-ordered-lapack-routines ()
  "Get a list of LAPACK routines, topologically ordered so that no routine depends on any after it."
  (let ((routines nil)
        (status (make-hash-table)))
    (labels ((visit (routine)
               (setf (gethash routine status) 'PROCESSING)
               (loop :for fn :in (cdr (assoc routine *lapack-dependencies*))
                     :do (ecase (gethash fn status)
                           ((NIL) (visit fn))
                           ((PROCESSING) (error "Cyclic dependency detected: ~A" fn))
                           ((PROCESSED EXPORTED) nil)))
               (setf (gethash routine status) 'PROCESSED)
               (push routine routines)))
      (loop :for (routine . _) :in *lapack-dependencies*
            :when (null (gethash routine status))
              :do (visit routine)
            :do (setf (gethash routine status) 'EXPORTED))
      (nreverse
       (loop :for routine :in routines
             :when (eq 'EXPORTED (gethash routine status))
               :collect (make-symbol (symbol-name routine)))))))

(defun uncalled-routines ()
  "Get a list of uncalled LAPACK routines. Morally there are two possibilities: an uncalled routine is a high-level entry point (e.g. ZGESVD) or it is dead code."
  ;; NOTE: This relies on F2CL's reporting, which is not always
  ;; correct. Don't believe its lies!
  (let ((who-calls (make-hash-table)))
    (dolist (input-file (uiop:directory-files *fortran-source-dir* "*.f"))
      (let* ((routine (find-symbol (string-upcase (pathname-name input-file))
                                   'f2cl))
             (info (gethash routine f2cl::*f2cl-function-info*))
             (callees (f2cl::f2cl-finfo-calls info)))
        (dolist (fn callees)
          (push routine (gethash fn who-calls)))
        (unless (gethash routine who-calls)
          (setf (gethash routine who-calls) nil))))
    (loop :for routine :being :the :hash-key :of who-calls
            :using (hash-value value)
          :when (null value)
            :collect routine)))
