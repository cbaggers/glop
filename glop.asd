;;;; -*- Mode: Lisp; indent-tabs-mode: nil -*-

(defsystem glop
  :depends-on (cffi cl-opengl cl-glu)
  :serial t
  :components
  ((:file "package")
   #+unix(:file "x11")
   #+win32(:file "win32")
   (:file "glop")))

