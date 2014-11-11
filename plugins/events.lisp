(defpackage :coleslaw-events
  (:use :cl)
  (:export #:enable
           #:event)
  (:import-from :coleslaw #:*config*
                          #:add-document
                          #:content
                          #:construct
                          #:discover
                          #:find-all
                          #:publish
                          #:read-content
                          #:render
                          #:repo-dir
                          #:theme-fn
                          #:write-document)
  (:import-from :uiop/filesystem #:directory-files))

(in-package :coleslaw-events)

(defun enable ())

(defclass event (content)
  ())

;; Redifining discover according to https://github.com/redline6561/coleslaw/pull/57#issuecomment-54978013
(defmethod discover ((doc-type (eql (find-class 'event))))
  (let* ((content-type (class-name doc-type))
         (dirname (format nil "~(~As~)" content-type)))
    (loop
      for file in (directory-files (merge-pathnames dirname (repo-dir *config*)))
      do (add-document (construct content-type (read-content file))))))

;; TODO: Figure if I need to pass extra args
(defmethod publish ((doc-type (eql (find-class 'event))))
  (loop
    for event in (find-all 'event)
    do (write-document event nil)))

(defmethod render ((obj event) &key &allow-other-keys)
  (funcall (theme-fn 'event)
           :config *config*
           :event obj))
