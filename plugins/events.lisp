(defpackage :coleslaw-events
  (:use :cl)
  (:export #:enable
           #:event
)
  (:import-from :coleslaw #:*config*
                          #:add-document
                          #:content
                          #:content-slug
                          #:content-text
                          #:discover
                          #:index
                          #:find-all
                          #:publish
                          #:theme-fn
                          #:render
                          #:render-text
                          #:slug
                          #:slugify
                          #:write-document))

(in-package :coleslaw-events)

(defclass event (content)
  ((title :initarg :title :reader title-of)))

(defmethod initialize-instance :after ((obj event) &key)
  (with-accessors ((title title-of)
                   (text content-text)
                   (slug content-slug)) obj
    (setf slug (slugify title))
    (setf text (render-text text :md) )))

(defmethod render ((object event) &key next prev)
  (declare (ignore next prev))
  (funcall (theme-fn 'event) (list :config *config*
                                   :event object)))

(defmethod publish ((doc-type (eql (find-class 'event))))
  (dolist (event (find-all 'event))
    (write-document event)))

;; Index it

(defclass event-index (index)
  ())

(defmethod discover ((doc-type (eql (find-class 'event-index))))
  (let ((content (coleslaw::by-date (find-all 'event)))) ;; TODO bydate
    (dolist (event (find-all 'event)) ;; TODO all-events
      (add-document (index-by-event event content))))) ;; TODO index-by-event

(defun index-by-event (event content)
  (make-instance 'event-index
                 :slug (slugify (title-of event)))) ;; I O U

(defmethod publish ((doc-type (eql (find-class 'event-index))))
  ;; TODO: I'm pretty sure there is only one event index, fix this it reflects that.
  (dolist (index (find-all 'event-index))
    (write-document index)))

(defun enable ())
