(defpackage :coleslaw-shout-outs
  (:use :cl)
  (:export #:enable)
  (:import-from :coleslaw #:*config*
                          #:find-all
                          #:publish
                          #:theme-fn
                          #:render
                          #:write-document))

(in-package :coleslaw-shout-outs)

(defclass shout (content))

(defmethod render ((object shout) &key next prev)
  (declare (ignore next prev))
  (funcall (theme-fn 'shout) (list :config *config*
                                   :post object)))

(defmethod publish ((doc-type (eql (find-class 'shout))))
  (do-list (shout (find-all 'shout))
    (write-document shout)))

(defun enable ())
