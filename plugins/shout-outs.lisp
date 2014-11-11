(defpackage :coleslaw-shout-outs
  (:use :cl)
  (:export #:enable)
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

(in-package :coleslaw-shout-outs)

(defun enable ())

(defclass shout-out (content)
  ())

(defmethod discover ((doc-type (eql (find-class 'shout-out))))
  (let* ((content-type (class-name doc-type))
         (dirname (format nil "~(~As~)" content-type)))
    (loop
      for file in (directory-files (merge-pathnames dirname (repo-dir *config*)))
      do (add-document (construct content-type (read-content file))))))

(defmethod publish ((doc-type (eql (find-class 'shout-out))))
  (loop for shout-out in (find-all 'event)
        do (write-document shout-out nil)))

(defmethod render ((obj shout-out) &key &allow-other-keys)
  (funcall (theme-fn 'shout-out)
           :config *config*
           :shout-out obj))
