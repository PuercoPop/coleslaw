(defpackage :coleslaw-static-pages
  (:use :cl)
  (:export #:enable)
  (:import-from :alexandria #:symbolicate)
  (:import-from :coleslaw #:*config*
                          #:content
                          #:content-text
                          #:page-url
                          #:find-all
                          #:render
                          #:publish
                          #:theme-fn
                          #:render-text
                          #:write-document))

(in-package :coleslaw-static-pages)

(defclass page (content)
  ((title :initarg :title :reader title-of)
   (url :initarg :url :reader page-url)
   (theme :initarg :theme :initform nil :accessor theme)))

(defmethod initialize-instance :after ((object page) &key)
  ;; Expect all static-pages to be written in Markdown for now.
  (with-accessors ((text content-text)
                   (theme theme)) object
    (setf text (render-text text :md))
    (when theme
      (setf theme (symbolicate (string-upcase theme))))))

(defmethod render ((object page) &key next prev)
  ;; For the time being, we'll re-use the normal post theme.
  (declare (ignore next prev))
  (if (equal #P"home.html" (page-url object))
      (funcall (theme-fn (theme object))
               (list :config *config*
                     :event (first (find-all 'coleslaw-events:event)))) 
      (funcall (or (and (theme object) (theme-fn (theme object)))
                   (theme-fn 'post))
               (list :config *config*
                     :post object))))

(defmethod publish ((doc-type (eql (find-class 'page))))
  (dolist (page (find-all 'page))
    (write-document page)))

(defun enable ())
