;; TODO: Not implement a custom homepage as a plugin :D
(defpackage :coleslaw-homepage
  (:use :cl)
  (:export #:enable)
  (:import-from :coleslaw #:*config*
                          #:content
                          #:by-date
                          #:discover
                          #:find-all
                          #:publish
                          #:theme-fn
                          #:render
                          #:write-document)
  (:import-from :coleslaw-events #:event))

(in-package :coleslaw-homepage)


(defclass home (content)
  ())

;; Redifining discover according to https://github.com/redline6561/coleslaw/pull/57#issuecomment-54978013
(defmethod discover ((doc-type (eql (find-class 'home))))
  (let* ((content-type (class-name doc-type)))
    (let ((obj (make-instance 'home content-type (read-content file))))
      (add-document obj))))


(defmethod publish ((doc-type (eql (find-class 'home))))
  (write-document (first (find-all 'home)) ;; There should only be one anyway
                  (theme-fn 'home)
                  :event (first (by-date 
                                 (find-all (find-class 'event))))))

(defmethod render ((object home) &key &allow-other-keys)
  (funcall (theme-fn 'home)
           :event (first (by-date 
                          (find-all (find-class 'event))))))

(defun enable ())
