;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10; indent-tabs-mode: nil -*-

;;; Xlib bindings
(in-package #:glop-xlib)

(defctype xid :unsigned-long)
(defctype window xid)
(defctype font xid)
(defctype drawable xid)
(defctype colormap xid)
(defctype pixmap xid)
(defctype cursor xid)
(defctype gcontext xid)

(defcstruct _xdisplay)
(defctype display (:struct _xdisplay))

(defctype visualid :unsigned-long)

(defctype watch-proc :pointer)

(defcstruct xcolor
  (pixel :ulong)
  (red :ushort) (green :ushort) (blue :ushort)
  (flags :char) (pad :char))

(defcstruct visual
  (ext-data :pointer)
  (visual-id visualid)
  (class :int)
  (red-mask :unsigned-long)
  (green-mask :unsigned-long)
  (blue-mask :unsigned-long)
  (bits-per-rgb :int)
  (map-entries :int))

(defcstruct visual-info
  (visual (:pointer (:struct visual)))
  (visual-id visualid) (screen :int)
  (depth :int) (class :int)
  (red-mask :ulong) (green-mask :ulong) (blue-mask :ulong)
  (colormap-size :int) (bpp :int))

(defcstruct set-window-attributes
  (bg-pixmap pixmap) (bg-pixel :unsigned-long)
  (border-pixmap pixmap) (border-pixel :unsigned-long)
  (bit-gravity :int) (win-gravity :int) (backing-store :int)
  (backing-planes :unsigned-long) (backing-pixel :unsigned-long)
  (save-under :boolean) (event-mask :long) (do-not-propagate-mask :long)
  (override-redirect :boolean) (cmap colormap) (curs cursor))

(defcenum (x-alloc :int)
  (:alloc-none)
  (:alloc-all))

(defcenum (x-window-class :int)
  (:copy-from-parent 0)
  (:input-output 1)
  (:input-only 2))

(defbitfield x-window-attributes-flags
  (:cw-back-pixmap       #x0001)
  :cw-back-pixel
  :cw-border-pixmap
  :cw-border-pixel
  :cw-bit-gravity
  :cw-win-gravity
  :cw-backing-store
  :cw-backing-planes
  :cw-backing-pixel
  :cw-override-redirect
  :cw-save-under
  :cw-event-mask
  :cw-dont-propagate
  :cw-colormap
  :cw-cursor)

(defbitfield x-event-mask-flags
  (:no-event-mask       #x0000)
  (:key-press-mask      #x0001)
  :key-release-mask
  :button-press-mask
  :button-release-mask
  :enter-window-mask
  :leave-window-mask
  :pointer-motion-mask
  :pointer-motion-hint-mask
  :button1-motion-mask
  :button2-motion-mask
  :button3-motion-mask
  :button4-motion-mask
  :button5-motion-mask
  :button-motion-mask
  :keymap-state-mask
  :exposure-mask
  :visibility-change-mask
  :structure-notify-mask
  :resize-redirect-mask
  :substructure-notify-mask
  :substructure-redirect-mask
  :focus-change-mask
  :property-change-mask
  :colormap-change-mask
  :owner-grab-buttons-mask)

(defcenum x-event-name
  (:key-press 2)
  :key-release
  :button-press
  :button-release
  :motion-notify
  :enter-notify
  :leave-notify
  :focus-in
  :focus-out
  :keymap-notify
  :expose
  :graphics-expose
  :no-expose
  :visibility-notify
  :create-notify
  :destroy-notify
  :unmap-notify
  :map-notify
  :map-request
  :reparent-notify
  :configure-notify
  :configure-request
  :gravity-notify
  :resize-request
  :circulate-notify
  :circulate-request
  :property-notify
  :selection-clear
  :selection-request
  :selection-notify
  :colormap-notify
  :client-message
  :mapping-notify
  :generic-event
  (:last-event 36))

(defctype x-time :unsigned-long)

(defcstruct x-key-event
  (type :int)
  (serial :unsigned-long)
  (send-event :boolean)
  (display-ptr :pointer)
  (win window)
  (root window)
  (subwin window)
  (time x-time)
  (x :int) (y :int)
  (x-root :int) (y-root :int)
  (state :unsigned-int)
  (keycode :unsigned-int)
  (same-screen :boolean))

(defctype x-key-pressed-event (:struct x-key-event))
(defctype x-key-released-event (:struct x-key-event))

(defcstruct x-button-event
  (type :int)
  (serial :unsigned-long)
  (send-event :boolean)
  (display-ptr :pointer)
  (win window)
  (root window)
  (subwin window)
  (time x-time)
  (x :int) (y :int)
  (x-root :int) (y-root :int)
  (state :unsigned-int)
  (button :unsigned-int)
  (same-screen :boolean))

(defctype x-button-pressed-event (:struct x-button-event))
(defctype x-button-released-event (:struct x-button-event))

(defcstruct x-motion-event
  (type :int)
  (serial :unsigned-long)
  (send-event :boolean)
  (display-ptr :pointer)
  (win window)
  (root window)
  (subwin window)
  (time x-time)
  (x :int) (y :int)
  (x-root :int) (y-root :int)
  (state :unsigned-int)
  (is-hint :char)
  (same-screen :boolean))

(defctype x-pointer-moved-event (:struct x-motion-event))

(defctype x-atom :unsigned-long)

(defcunion x-client-message-event-data
  (b :char :count 20)
  (s :short :count 10)
  (l :long :count 5))

(defcstruct x-client-message-event
  (type :int)
  (serial :unsigned-long)
  (send-event :boolean)
  (display-ptr :pointer)
  (win window)
  (message-type x-atom)
  (format :int)
  (data (:union x-client-message-event-data)))

(defcstruct x-expose-event
  (type :int)
  (serial :unsigned-long)
  (send-event :boolean)
  (display-ptr :pointer)
  (win window)
  (x :int) (y :int)
  (width :int) (height :int)
  (count :int))

(defcstruct x-configure-event
  (type :int)
  (serial :unsigned-long)
  (send-event :boolean)
  (display-ptr :pointer)
  (event window)
  (win window)
  (x :int) (y :int)
  (width :int) (height :int)
  (border-width :int)
  (above window)
  (override-reirect :boolean))

(defcstruct x-map-event
  (type :int)
  (serial :unsigned-long)
  (send-event :boolean)
  (display-ptr :pointer)
  (event window)
  (win window)
  (override-redirect :boolean))

(defcstruct x-unmap-event
  (type :int)
  (serial :unsigned-long)
  (send-event :boolean)
  (display-ptr :pointer)
  (event window)
  (win window)
  (from-configure :boolean))

(defcenum visibility-state
  (:unobscured 0)
  (:partially-obscured 1)
  (:fully-obscured 2))

(defcstruct x-visibility-event
  (type :int)
  (serial :unsigned-long)
  (send-event :boolean)
  (display-ptr :pointer)
  (window window)
  (state visibility-state))

(defcstruct x-focus-change-event
  (type :int)
  (serial :unsigned-long)
  (send-event :boolean)
  (display-ptr :pointer)
  (window window)
  (mode :int)
  (detail :int))

(defcstruct x-create-window-event
  (type :int)
  (serial :unsigned-long)
  (send-event :boolean)
  (display-ptr :pointer)
  (parent window)
  (window window)
  (x :int)
  (y :int)
  (width :int)
  (height :int)
  (border-width :int)
  (override-redirect :boolean))

(defcstruct x-destroy-window-event
  (type :int)
  (serial :unsigned-long)
  (send-event :boolean)
  (display-ptr :pointer)
  (event window)
  (window window))

(defcstruct x-reparent-event
  (type :int)
  (serial :unsigned-long)
  (send-event :boolean)
  (display-ptr :pointer)
  (event window)
  (window window)
  (parent window)
  (x :int)
  (y :int)
  (override-redirect :boolean))



(defcstruct x-generic-event-cookie
  (type :int)
  (serial :unsigned-long)
  (send-event :boolean)
  (display-ptr :pointer)
  (extension :int)
  (evtype :int)
  (cookie :unsigned-int)
  (data :pointer))

(defcunion x-event
  (type :int)
  (pad :long :count 24))

(defcstruct x-compose-status
    (compose-ptr :pointer) (chars-matched :int))

(defctype x-status :int)

(defctype x-queued-mode :int)

(defcstruct x-window-attributes
  ;; fixme: figure out better types for fields that are enums/bits
  (x :int)
  (y :int)
  (width :int)
  (height :int)
  (depth :int)
  (visual (:pointer (:struct visual)))
  (root window)
  (class :int)
  (bit-gravity :int)
  (win-gravity :int)
  (backing-store :int)
  (backing-planes :unsigned-long)
  (backing-pixel :unsigned-long)
  (save-under :boolean)
  (colormap colormap)
  (map-installed :boolean)
  (map-state :int)
  (all-event-masks :long)
  (your-event-mask :long)
  (override-redirect :boolean)
  (screen :pointer))

;; X11 bindings
(define-foreign-library xlib
  (t (:default "libX11")))
(use-foreign-library xlib)

(defcfun ("XDisplayWidth" display-width) :int
  (display-ptr :pointer)
  (screen :int))

(defcfun ("XDisplayHeight" display-height) :int
  (display-ptr :pointer)
  (screen :int))

(defcfun ("XDefaultDepth" default-depth) :int
  (display-ptr :pointer)
  (screen :int))

(defcfun ("XDefaultScreen" default-screen) :int
  (display-ptr :pointer))

(defcfun ("XRootWindow" root-window) :int
  (display-ptr :pointer)
  (screen :int))

(defcfun ("XSendEvent" x-send-event) :int
  (display-ptr :pointer)
  (win window)
  (propogate :boolean)
  (event-mask :long)
  (event-send :pointer))

(defcfun ("XInternAtom" x-intern-atom) x-atom
  (display-ptr :pointer)
  (atom-name :string)
  (only-if-exists :boolean))

(defcfun ("XGetVisualInfo" get-visual-info) :pointer
  (display-ptr :pointer)
  (vinfo-mask :int)
  (vinfo-template :pointer)
  (nitems-returned :pointer))

(defcfun ("XOpenDisplay" %x-open-display) :pointer
  (display-name :string))

(defcfun ("XCloseDisplay" %x-close-display) :pointer
  (display-ptr :pointer))

(defcfun ("XDefaultRootWindow" x-default-root-window) window
  (display-ptr :pointer))

(defcfun ("XCreateColormap" x-create-color-map) colormap
  (display-ptr :pointer) (win window) (visual-ptr :pointer) (alloc x-alloc))

(defcfun ("XGetAtomName" %x-get-atom-name) :pointer
  (display-ptr :pointer) (atm x-atom))

(defun x-get-atom-name (display-ptr atom)
  (let ((p (%x-get-atom-name display-ptr atom)))
    (prog1 (foreign-string-to-lisp p)
      (x-free p))))

(defcfun ("XFree" x-free) :int
  (data :pointer))

(defcfun ("XFlush" x-flush) :int
  (display-ptr :pointer))

(defcfun ("XCreateWindow" %x-create-window) window
  (display-ptr :pointer) (parent window) (x :int) (y :int) (width :int) (height :int)
  (border-width :int) (depth :int) (win-class x-window-class) (visual :pointer)
  (value-mask x-window-attributes-flags) (attributes (:pointer (:struct set-window-attributes))))

(defcfun ("XCreateSimpleWindow" x-create-simple-window) window
  (display-ptr :pointer)
  (parent window)
  (x :int)
  (y :int)
  (width :int)
  (height :int)
  (border-width :int)
  (background :int))

(defcfun ("XDefaultVisual" default-visual) (:pointer (:struct visual))
  (display-ptr :pointer)
  (screen :int))

(defcfun ("XSetInputFocus" x-set-input-focus) :void
  (display-ptr :pointer)
  (focus window)
  (revert-to :int)
  (time x-time))

(defcfun ("XGetInputFocus" x-get-input-focus) :void
  (display :pointer)
  (window (:pointer window))
  (revert-to (:pointer :int)))

(defcfun ("XSelectInput" x-select-input) :void
  (display :pointer)
  (window window)
  (event-mask x-event-mask-flags))

(defcfun ("XQueryTree" x-query-tree) x-status
  (display :pointer)
  (window window)
  (root (:pointer window))
  (parent (:pointer window))
  (children (:pointer (:pointer window)))
  (nchildren (:pointer :unsigned-int)))


(defun %set-fullscreen (window dpy be-fullscreen)
  (let ((wm-state (x-intern-atom dpy "_NET_WM_STATE" nil))
        (fullscreen (x-intern-atom dpy "_NET_WM_STATE_FULLSCREEN" nil)))
    (with-foreign-object (msg '(:union x-event))
      (with-foreign-slots ((type) msg (:union x-event))
        (setf type (foreign-enum-value 'x-event-name :client-message))
        (with-foreign-slots ((win message-type format data) msg (:struct x-client-message-event))
          (setf win window)
          (setf message-type wm-state)
          (setf format 32)
          (with-foreign-slots ((l) data (:union x-client-message-event-data))
            (setf (mem-aref l :long 0) (if be-fullscreen 1 0))
            (setf (mem-aref l :long 1) fullscreen)
            (setf (mem-aref l :long 2) 0))))
      (x-send-event dpy (x-default-root-window dpy) nil (foreign-bitfield-value 'x-event-mask-flags '(:structure-notify-mask)) msg))))

;;; XGenericEvent events dispatch on a per-display 'opcode', so we
;;; store a map from display-ptr to an opcode->extension map for
;;; all known open display connections
;;; -- indexed by integer value of display-ptr since we can't portably use
;;;    cffi pointers as keys in a hash table (SBCL in particular can't use
;;;    any of the standard hash table tests on SAPs)

;; fixme: put this somewhere better?
(defparameter *display-extensions* (make-hash-table :test 'eql))
(defun get-display-extension-data (display opcode)
  (gethash opcode (gethash (pointer-address display) *display-extensions*)))

(defun (setf get-display-extension-data) (value display opcode)
  (format t "setf get-display-extension-data ~s ~s ~s~%" value display opcode)
  (setf (gethash opcode (gethash (pointer-address display) *display-extensions*))
        value)
  (format t "-> ~s~%" (get-display-extension-data display opcode))
  value)

(defclass extension-data ()
  ((name :initarg name :reader name)
   (opcode  :initarg opcode :reader opcode)
   (event-base :initarg event-base :reader event-base)
   (error-base :initarg error-base :reader error-base)))

(defcstruct x-error-event
  (type :int)
  (display-ptr :pointer)
  (resource-id xid)
  (serial :unsigned-long)
  (error-code :unsigned-char)
  (request-code :unsigned-char)
  (minor-code :unsigned-char))

(defcfun ("XGetErrorText" x-get-error-text) :int
  (display-ptr :pointer)
  (code :int)
  (buffer :pointer)
  (length :int))

(defcallback x-error-handler :int ((display :pointer)
                                   (event (:pointer (:struct x-error-event))))
  (declare (ignorable display))
  (restart-case
      (with-foreign-slots ((type display-ptr serial error-code
                                 request-code minor-code resource-id)
                           event (:struct x-error-event))
        (let ((message (with-foreign-pointer-as-string (m 256)
                         (x-get-error-text display-ptr error-code m 256))))
         (format t "~&x error ~s: ~a, opcode ~s . ~s, resource id ~s, serial ~s~%"
                 error-code message request-code minor-code resource-id serial)
         (error "x error ~s: ~a, opcode ~s . ~s, resource id ~s, serial ~s"
                error-code message request-code minor-code resource-id serial)))
    (continue () :report "Continue"))
  0)

(defcfun ("XSetErrorHandler" x-set-error-handler) :int
  (handler :pointer))

(defun x-open-display (&optional (display-name (null-pointer)))
  ;; fixme: only do this once (but at least once per image load, so not at toplevel)
  (x-set-error-handler (callback x-error-handler))
  (let ((display (%x-open-display display-name)))
    (when (null-pointer-p display)
      (error "Unable to open display"))
    (when (gethash (pointer-address display) *display-extensions*)
      ;; can this happen? if so, need ref counts or something
      ;; so we don't remove it until all are closed...
      (warn "duplicate display in x-open-display? need to add reference couting..."))
    (setf (gethash (pointer-address display) *display-extensions*)
          (make-hash-table :test 'eql))
    display))

(defun x-close-display (display)
  (remhash (pointer-address display) *display-extensions*)
  (%x-close-display display))

(defmacro with-current-display (dpy-sym &body body)
  `(let ((,dpy-sym (x-open-display)))
     (unwind-protect
          (progn ,@body)
       (x-close-display ,dpy-sym))))

(defun x-create-window (dpy parent x y width height visual-infos)
  (let ((root-win (x-default-root-window dpy)))
    (with-foreign-slots ((visual-id visual depth) visual-infos (:struct visual-info))
      (let ((colormap (x-create-color-map dpy root-win visual :alloc-none)))
        (with-foreign-object (win-attrs '(:struct set-window-attributes))
          (with-foreign-slots ((cmap event-mask border-pixel) win-attrs (:struct set-window-attributes))
            (setf cmap colormap
                  event-mask (foreign-bitfield-value 'x-event-mask-flags
                                '(:exposure-mask
                                  :key-press-mask :key-release-mask
                                  :button-press-mask :button-release-mask
                                  :structure-notify-mask
                                  :visibility-change-mask
                                  :pointer-motion-mask))
                  border-pixel 0)
            (%x-create-window dpy parent x y  width height 0
                              depth :input-output visual
                              '(:cw-colormap :cw-event-mask)
                              win-attrs)))))))

(defcfun ("XDestroyWindow" x-destroy-window) :int
  (display-ptr :pointer) (win window))

(defcfun ("XMapWindow" x-map-window) :int
  (display-ptr :pointer) (win window))

(defcfun ("XMapRaised" x-map-raised) :int
  (display-ptr :pointer) (win window))

(defcfun ("XUnmapWindow" x-unmap-window) :int
  (display-ptr :pointer) (win window))

(defcfun ("XReparentWindow" x-reparent-window) :void
  (display :pointer)
  (window window)
  (parent window)
  (x :int)
  (y :int))

(defcfun ("XStoreName" x-store-name) :int
  (display-ptr :pointer) (win window) (name :string))

(defcfun ("XSync" x-sync) :int
  (display-ptr :pointer) (discard :boolean))

(defcfun ("XNextEvent" %x-next-event) :int
  (display-ptr :pointer) (evt (:pointer (:union x-event))))

(defcfun ("XEventsQueued" %x-events-queued) :int
  (display-ptr :pointer) (mode x-queued-mode))

(defcfun ("XPeekEvent" %x-peek-event) :int
  (display-ptr :pointer) (evt (:pointer (:union x-event))))

(defcfun ("XPending" %x-pending) :int
  (display-ptr :pointer))

(defcfun ("XSetWMProtocols" x-set-wm-protocols) :int
  (display-ptr :pointer) (win window) (atoms :pointer) (count :int))

(defun x-pending-p (display-ptr)
  (not (zerop (%x-pending display-ptr))))

(defun x-next-event (win dpy &optional blocking)
  (x-sync dpy nil)
  (with-foreign-object (evt '(:union x-event))
    (loop for processed-event = (if blocking
                                    (progn (%x-next-event dpy evt)
                                           (process-event win dpy evt))
                                    (progn (when (x-pending-p dpy)
                                             (%x-next-event dpy evt)
                                             (process-event win dpy evt))))
          while (and processed-event (eq processed-event :unknown-event))
          finally (return processed-event))))

(let ((last-x 0)
      (last-y 0))
  (defun process-event (win dpy evt)
    "Process an X11 event into a GLOP event."
    (with-foreign-slots ((type) evt (:union x-event))
      (case (foreign-enum-keyword 'x-event-name type :errorp nil)
        (:key-press
         (with-foreign-slots ((keycode) evt (:struct x-key-event))
           (when (and glop:*ignore-auto-repeat* (glop:key-pressed keycode))
             (return-from process-event))
           (setf (glop:key-pressed keycode) t)
           (multiple-value-bind (text keysym) (x-lookup-string evt)
             (make-instance 'glop:key-press-event
                            :keycode keycode
                            :keysym keysym
                            :text text))))
        (:key-release
         (with-foreign-slots ((keycode win time) evt (:struct x-key-event))
           ;; ignore key release for key repeats
           ;; if a key is repeated we now get the same behavior as win32
           ;; i.e. multiple :key-press events without corresponding key release
           ;; the following is translated from glfw:x11_window.c:612
           (when (and (x-pending-p dpy) (%x-events-queued dpy 1)) ;; 1 is QueuedAfterReading
             (with-foreign-object (next-evt '(:union x-event))
               (%x-peek-event dpy next-evt)
               (when (and (eq :key-press
                              (foreign-enum-keyword 'x-event-name
                                   (foreign-slot-value next-evt
                                                       '(:struct x-key-event)
                                                       'type)
                                   :errorp nil))
                          (eq win (foreign-slot-value next-evt
                                                      '(:struct x-key-event)
                                                      'win))
                          (eq time (foreign-slot-value next-evt
                                                       '(:struct x-key-event)
                                                       'time)))
                 (return-from process-event))))
           (setf (glop:key-pressed keycode) nil)
           (multiple-value-bind (text keysym) (x-lookup-string evt)
             (make-instance 'glop:key-release-event
                            :keycode keycode
                            :keysym keysym
                            :text text))))
        (:button-press
         (with-foreign-slots ((button) evt x-button-pressed-event)
           (make-instance 'glop:button-press-event
                          :button button)))
        (:button-release
         (with-foreign-slots ((button) evt x-button-released-event)
           (make-instance 'glop:button-release-event
                          :button button)))
        (:motion-notify
         (with-foreign-slots ((x y) evt (:struct x-motion-event))
           (let ((glop-evt (make-instance 'glop:mouse-motion-event
                                          :x x :y y
                                          :dx (- x last-x)
                                          :dy (- y last-y))))
             (setf last-x x last-y y)
             glop-evt)))
        (:expose
         (with-foreign-slots ((display-ptr win) evt (:struct x-expose-event))
           (destructuring-bind (&key width height &allow-other-keys)
               (x-get-geometry display-ptr win)
             (make-instance 'glop:expose-event
                            :width width :height height))))
        (:configure-notify
         (with-foreign-slots ((x y width height event) evt (:struct x-configure-event))
           (cond
             ((= event (cffi:foreign-slot-value evt '(:struct x-configure-event) 'win))
              (glop::%update-geometry win x y width height)
              (make-instance 'glop:resize-event
                             :width width :height height))
             (t
              (make-instance 'glop::child-resize-event
                             :child  (cffi:foreign-slot-value evt '(:struct x-configure-event) 'win)
                             :width width :height height)))))
        (:map-notify
         (with-foreign-slots ((event win) evt (:struct x-map-event))
           (if (= event win)
               (make-instance 'glop:visibility-unobscured-event)
               (make-instance 'glop::child-visibility-unobscured-event
                              :child win))))
        (:unmap-notify
         (with-foreign-slots ((event win) evt (:struct x-unmap-event))
           (if (= event win)
               (make-instance 'glop:visibility-obscured-event)
               (make-instance 'glop::child-visibility-obscured-event
                              :child win)))
)
        (:client-message
         (with-foreign-slots ((display-ptr message-type data) evt
                              (:struct x-client-message-event))
           ;; fixme: look up WM_PROTOCOLS, WM_DELETE_WINDOW atoms once and cache them, then compare those instead of doing string compares
           (let ((message-type-str (x-get-atom-name display-ptr message-type)))
             (cond
               ((string= message-type-str "WM_PROTOCOLS")
                (with-foreign-slots ((l) data
                                     (:union x-client-message-event-data))
                  (let ((atom-name (x-get-atom-name display-ptr
                                                    (mem-ref l :long))))
                   (when (string= atom-name "WM_DELETE_WINDOW")
                     (make-instance 'glop:close-event)))))
               (t
                ;(format t "got client message type ~s~%" message-type-str)
                nil)))))
        (:visibility-notify
         (with-foreign-slots ((state) evt (:struct x-visibility-event))
           (case state
             (:unobscured
              (make-instance 'glop:visibility-unobscured-event))
             (:partially-obscured
              (make-instance 'glop:visibility-unobscured-event :visible :partial))
             (:fully-obscured
              (make-instance 'glop:visibility-obscured-event)))))
        (:create-notify
         (with-foreign-slots ((parent window x y width height) evt
                              (:struct x-create-window-event))
           ;; should this verify 'parent' matches current window?
           ;; (or that 'window' doesn't?)
           (make-instance 'glop::child-created-event
                          :parent parent
                          :child window
                          :x x :y y
                          :width width :height height)))
        (:destroy-notify
         (with-foreign-slots ((event window) evt
                              (:struct x-destroy-window-event))
           (cond
             ((= event window)
              ;; window itself was destroyed, ignoring for now...
              )
             (t
              ;; child window was destroyed
              (make-instance 'glop::child-destroyed-event
                             :child window
                             :parent event)))))
        (:reparent-notify
         (with-foreign-slots ((parent window event x y) evt
                              (:struct x-reparent-event))
           (when (/= event window) ;; make sure it was child not main window
             (make-instance 'glop::child-reparent-event
                           :parent parent
                           :child window
                           :x x :y y))))

        (:focus-in
         (make-instance 'glop:focus-in-event))
        (:focus-out
         (make-instance 'glop:focus-out-event))
        (:generic-event
         (process-generic-event evt))
        ;; unhandled event
        ;; can't return NIL, since DISPATCH-EVENTS interprets that as
        ;; no more events
        (t :unknown-event)))))

;; dispatcher for extension events, extensions should eql specialize on
;; extension name and opcode, data cffi pointer to event structure, which
;; is freed after dispatcher returns
(defgeneric %generic-event-dispatch (extension-name event data display-ptr))
(defmethod %generic-event-dispatch (extension-name event data display-ptr)
  (format t "unknown generic-event: extension=~s, event=~s, data=#x~8,'0x~%" extension-name event (pointer-address data)))

(defun process-generic-event (event)
  (restart-case
      (with-foreign-slots ((display-ptr extension evtype cookie data) event
                           (:struct x-generic-event-cookie))
        (format t "")
        (let ((ext (get-display-extension-data display-ptr extension)))
          (if ext
              (unwind-protect
                   (progn
                     (x-get-event-data display-ptr event)
                     (%generic-event-dispatch (name ext) evtype data display-ptr))
                (unless (null-pointer-p data)
                  (x-free-event-data display-ptr event)))
              (format t "Unhandled X11 generic-event: ~S, opcode ~s, display ~s~%" evtype extension display-ptr))))
    (continue () :report "Skip event")))

(defcfun ("XLookupString" %x-lookup-string) :int
  (evt (:pointer (:struct x-key-event)))
  (buffer-return :pointer) (bytes-buffer :int)
  (keysym-return :pointer) (status-in-out :pointer))

(defun x-lookup-string (key-event)
  "Returns the input string corresponding to a keypress."
  (with-foreign-objects ((buffer :char 32) (keysym 'x-keysym-value))
    #+ccl(loop for i below 32 do (setf (mem-aref buffer :char i) 0)) ;; buffer is not zeroed in cll
    (%x-lookup-string key-event buffer 32 keysym (null-pointer))
    ;; fixme: handle decoding error properly (or use babel so we can
    ;; pass no-error flag?)
    (let ((string (or (ignore-errors (foreign-string-to-lisp buffer))
                      (format nil "decoding error?~s"
                              (foreign-string-to-lisp buffer :encoding :latin1))))
          (value (mem-ref keysym :uint32)))
      (values (if (zerop (length string)) nil string)
              (or (cffi:foreign-enum-keyword 'x-keysym-value value :errorp nil)
                  value)))))

(defcfun ("XGetGeometry" %x-get-geometry) x-status
  (display-ptr :pointer) (d drawable) (root-return :pointer)
  (x-return :pointer) (y-return :pointer) (width-return :pointer)
  (height-return :pointer) (border-width-return :pointer)
  (depth-return :pointer))

(defun x-get-geometry (dpy win)
  (with-foreign-objects ((root 'window) (x :int) (y :int)
                         (width :unsigned-int) (height :unsigned-int)
                         (border-width :unsigned-int) (depth :unsigned-int))
    (%x-get-geometry dpy win root x y width height border-width depth)
    (list :root (mem-ref root 'window)
          :x (mem-ref x :int) :y (mem-ref y :int)
          :width (mem-ref width :unsigned-int)
          :height (mem-ref height :unsigned-int)
          :border-width (mem-ref border-width :unsigned-int)
          :depth (mem-ref depth :unsigned-int))))

(defbitfield x-window-configure-flags
  :cw-x
  :cw-y
  :cw-width
  :cw-height
  :cw-border-width
  :cw-sibling
  :cw-stack-mode)

(defcstruct x-window-changes
  (x :int) (y :int)
  (width :int) (height :int)
  (border-width :int)
  (sibling window)
  (stack-mode :int))

(defcfun ("XConfigureWindow" %x-configure-window) :int
  (display-ptr :pointer) (win window) (value-mask x-window-configure-flags)
  (values (:pointer (:struct x-window-changes))))

(defun x-set-geometry (dpy win x y width height)
  (with-foreign-object (changes '(:struct x-window-changes))
    (setf (foreign-slot-value changes '(:struct x-window-changes) 'x) x
          (foreign-slot-value changes '(:struct x-window-changes) 'y) y
          (foreign-slot-value changes '(:struct x-window-changes) 'width) width
          (foreign-slot-value changes '(:struct x-window-changes) 'height) height)
    (%x-configure-window dpy win (foreign-bitfield-value 'x-window-configure-flags
                                                         '(:cw-x :cw-y :cw-width :cw-height))
                         changes)))

(defcfun ("XCreatePixmapCursor" %x-create-pixmap-cursor) cursor
  (display-ptr :pointer) (src pixmap) (mask pixmap)
  (foreground-color (:pointer (:struct xcolor)))
  (background-color (:pointer (:struct xcolor)))
  (x :uint) (y :uint))

(defcfun ("XCreatePixmap" %x-create-pixmap) pixmap
  (display-ptr :pointer) (d drawable)
  (width :uint) (height :uint)
  (depth :uint))

(defcenum xgcvalues-function
  (:GXclear #x0)
  :GXand
  :GXandReverse
  :GXcopy
  :GXandInverted
  :GXnoop
  :GXxor
  :GXor
  :GXnor
  :GXequiv
  :GXinvert
  :GXorReverse
  :GXcopyInverted
  :GXorInverted
  :GXnand
  :GXset)

(defcstruct xgcvalues
  (function xgcvalues-function)
  (plane-mask :ulong) (foreground :ulong) (background :ulong)
  (line-width :int) (line-style :int)
  (cap-style :int) (join-style :int) (fill-style :int)
  (fill-rule :int) (arc-mode :int)
  (tile pixmap) (stipple pixmap)
  (ts-x-origin :int) (ts-y-origin :int)
  (font font) (subwindow-mode :int)
  (graphics-exposures :boolean)
  (clip-x-origin :int) (clip-y-origin :int)
  (clip-mask pixmap)
  (dash-offset :int) (dashes :char))

(defbitfield xgcvalues-flags
  (:gcv-function #x0001))

(defcfun ("XCreateGC" %x-create-gc) gcontext
  (display-ptr :pointer) (d drawable)
  (value-mask xgcvalues-flags)
  (xgc-values-ptr :pointer))

(defcfun ("XFillRectangle" %x-fill-rectangle) :int
  (display-ptr :pointer) (d drawable) (gc gcontext)
  (x :int) (y :int) (width :uint) (height :uint))

(defun x-create-null-cursor (dpy win)
  (with-foreign-objects ((xgc '(:struct xgcvalues)) (col '(:struct xcolor)))
    (setf (foreign-slot-value xgc '(:struct xgcvalues) 'function)
          (foreign-enum-value 'xgcvalues-function :GXclear)
          (foreign-slot-value col '(:struct xcolor) 'pixel)
          0
          (foreign-slot-value col '(:struct xcolor) 'red)
          0
          (foreign-slot-value col '(:struct xcolor) 'flags)
          4)
    (let* ((cursor-mask (%x-create-pixmap dpy win 1 1 1))
           (gc (%x-create-gc dpy cursor-mask '(:gcv-function) xgc)))
      (%x-fill-rectangle dpy cursor-mask gc 0 0 1 1)
      (let ((cursor (%x-create-pixmap-cursor dpy cursor-mask cursor-mask
                                             col col 0 0)))
        (x-free-pixmap dpy cursor-mask)
        (x-free-gc dpy gc)
        cursor))))

(defcfun ("XFreePixmap" x-free-pixmap) :int
  (display-ptr :pointer) (p pixmap))

(defcfun ("XFreeGC" x-free-gc) :int
  (display-ptr :pointer) (gc gcontext))

(defcfun ("XFreeCursor" x-free-cursor) :int
  (display-ptr :pointer) (cursor cursor))

(defcfun ("XDefineCursor" x-define-cursor) :int
  (display-ptr :pointer) (win window)
  (cursor cursor))

(defcfun ("XUndefineCursor" x-undefine-cursor) :int
  (display-ptr :pointer) (win window))

(defcfun ("XAddConnectionWatch" add-connection-watch) x-status
  (display :pointer)
  (procedure watch-proc)
  (client-data :pointer))

(defcfun ("XRemoveConnectionWatch" remove-connection-watch) x-status
  (display :pointer)
  (procedure watch-proc)
  (client-data :pointer))

(defcfun ("XProcessInternalConnection" process-internal-connection) :void
  (display :pointer)
  (fd :int))

(defcfun ("XGetEventData" x-get-event-data) :boolean
  (display-ptr :pointer)
  (cookie (:pointer (:struct x-generic-event-cookie))))

(defcfun ("XFreeEventData" x-free-event-data) :void
  (display-ptr :pointer)
  (cookie (:pointer (:struct x-generic-event-cookie))))


(defcfun ("XQueryExtension" %x-query-extension) :boolean
  (display-ptr :pointer)
  (name :string)
  (major-opcode-return (:pointer :int))
  (first-event-return (:pointer :int))
  (first-error-return (:pointer :int)))
(defun x-query-extension (display name)
  (with-foreign-objects ((opcode :int) (event :int) (error :int))
    (if (%x-query-extension display name opcode event error)
        (values t (mem-ref opcode :int) (mem-ref event :int) (mem-ref error :int))
        (values nil 0 0 0))))

(defcfun ("XGetWindowAttributes" %x-get-window-attributes) x-status
  (display :pointer)
  (window window)
  (window-attributes-return (:pointer (:struct x-window-attributes))))

(defun x-get-window-attributes (display win)
  (with-foreign-object (attr '(:struct x-window-attributes))
    (%x-get-window-attributes display win attr)
    (mem-aref attr '(:struct x-window-attributes))))

(defcstruct x-size-hints
  (flags :long)
  (x :int)
  (y :int)
  (width :int)
  (height :int)
  (min-width :int)
  (min-height :int)
  (max-width :int)
  (max-height :int)
  (width-inc :int)
  (height-inc :int)
  (min-aspect-numerator :int)
  (min-aspect-denominator :int)
  (max-aspect-numerator :int)
  (max-aspect-denominator :int)
  (base-width :int)
  (base-height :int)
  ;; fixme: define an enum for gravity
  (win-gravity :int))

(defbitfield x-size-hints-mask :long
  (:us-position 1)
  :us-size
  :p-position
  :p-size
  :p-min-size
  :p-max-size
  :p-resize-inc
  :p-aspect
  :p-base-size
  :p-win-gravity)

(defcfun ("XGetWMNormalHints" %x-get-wm-normal-hints) x-status
  (display :pointer)
  (window window)
  (hints (:pointer (:struct x-size-hints)))
  (supplied (:pointer :long)))

(defun x-get-wm-normal-hints (display window)
  (with-foreign-objects ((hints '(:struct x-size-hints))
                         (%mask 'x-size-hints-mask))
    (%x-get-wm-normal-hints display window hints %mask)
    (let ((r nil)
          (mask (cffi:mem-aref %mask 'x-size-hints-mask)))
      (macrolet ((s (k s)
                   `(setf r (list* ,k
                                   (foreign-slot-value hints
                                                       '(:struct x-size-hints)
                                                       ',s)
                                   r))))
        (when (member :p-min-size mask)
          (s :min-width min-width)
          (s :min-height min-height))
        (when (member :p-max-size mask)
          (s :max-width max-width)
          (s :max-height max-height))
        (when (member :p-resize-inc mask)
          (s :width-inc width-inc)
          (s :height-inc height-inc))
        (when (member :p-base-size mask)
          (s :base-width base-width)
          (s :base-height base-height))
        (when (member :p-aspect mask)
          (setf r
                (list* :min-aspect
                       (list (foreign-slot-value hints '(:struct x-size-hints)
                                              'min-aspect-numerator)
                          (foreign-slot-value hints '(:struct x-size-hints)
                                              'min-aspect-denominator))
                       :max-aspect
                       (list (foreign-slot-value hints '(:struct x-size-hints)
                                              'max-aspect-numerator)
                          (foreign-slot-value hints '(:struct x-size-hints)
                                              'max-aspect-denominator))
                       r)))
        r))))

(defconstant +status-success+ 0)
(defconstant +status-bad-request+ 1)
(defconstant +status-bad-value+ 2)
(defconstant +status-bad-window+ 3)
;; bad-pixmap bad-atom bad-cursor bad-font bad-match bad-drawable bad-access bad-alloc bad-color bad-gc bad-id-choice bad-name bad-length bad-implementation=17


(defcenum (grab-mode :int)
  (:grab-mode-sync 0)
  (:grab-mode-async 1)
  (:sync  0)
  (:async 1))

(defcenum (grab-status :int)
  (:grab-success       0)
  (:already-grabbed    1)
  (:grab-invalid-time  2)
  (:grab-not-viewable  3)
  (:grab-frozen        4))
