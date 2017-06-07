;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10; indent-tabs-mode: nil -*-

(in-package #:glop)

(defdfun gl-get-proc-address (proc-name)
  "Get foreign pointer to the GL extension designed by PROC-NAME."
  (declare (ignore proc-name))
  (error 'not-implemented))

;;; Display management
(defgeneric list-video-modes ()
  (:documentation
   "Returns a list of all available video modes as a list video-mode structs."))

(defgeneric set-video-mode (mode)
  (:documentation
   "Attempts to set the provided video mode."))

(defgeneric current-video-mode ()
  (:documentation
   "Returns the current video mode."))

;; XXX: stupid distance match is maybe not the best option here...
(defun closest-video-mode (current-mode modes-list dwidth dheight &optional ddepth drate)
  "Try to find the closest video mode matching desired parameters within modes-list.
Returns NIL if no match is found."
  (unless drate
    (setf drate (video-mode-rate current-mode)))
  (unless ddepth
    (setf ddepth (video-mode-depth current-mode)))
  (loop with best-match = nil
        with best-dist = most-positive-fixnum
        for mode in (remove-if (lambda (it)
                                 (or (/= (video-mode-rate it) drate)
                                     (/= (video-mode-depth it) ddepth)))
                               modes-list)
        for current-dist = (+ (* (- dwidth (video-mode-width mode))
                                 (- dwidth (video-mode-width mode)))
                              (* (- dheight (video-mode-height mode))
                                 (- dheight (video-mode-height mode))))
        when (< current-dist best-dist)
        do (setf best-dist current-dist
                 best-match mode)
        finally (return best-match)))

;;; Context management
(defgeneric create-gl-context (window &key make-current major minor
                                           forward-compat debug
                                           profile)
  (:documentation
   "Creates a new OpenGL context of the specified version for the provided window
   and optionally make it current (default). If major and minor are NIL old style context creation
   is used. Otherwise a context compatible with minimum major.minor version is created.
   If you request a specific context version, you may use the additional arguments to setup
   context options.
   The foward-compat argument specify whether to disallow legacy functionalities (only for
   GL version >= 3.0). The debug argument specify whether a debug context should be created.
   You may request a specific context profile by specifiying either
   :core or :compat as the profile argument value."))

(defgeneric destroy-gl-context (ctx)
  (:documentation
   "Detach and release the provided OpenGL context."))

(defgeneric attach-gl-context (window ctx)
  (:documentation
   "Makes CTX the current OpenGL context and attach it to WINDOW."))

(defgeneric detach-gl-context (ctx)
  (:documentation
   "Make the provided OpenGL context no longer current."))

;;; Window management
(defgeneric open-window (window title width height &key x y
                                                   rgba
                                                   double-buffer
                                                   stereo
                                                   red-size
                                                   green-size
                                                   blue-size
                                                   alpha-size
                                                   depth-size
                                                   accum-buffer
                                                   accum-red-size
                                                   accum-green-size
                                                   accum-blue-size
                                                   stencil-buffer
                                                   stencil-size)
  (:documentation
   "Creates a new window *without* any GL context."))

(defgeneric close-window (window)
  (:documentation
   "Closes the provided window *without* releasing any attached GL context."))

(defgeneric %init-swap-interval (window)
  (:method (w)
    (setf (swap-interval-function w) :unsupported)))

(defun create-window (title width height &key (x 0) (y 0) major minor fullscreen
                                              (win-class 'window)
                                              (double-buffer t)
                                              stereo
                                              (red-size 4)
                                              (green-size 4)
                                              (blue-size 4)
                                              (alpha-size 4)
                                              (depth-size 16)
                                              accum-buffer
                                              (accum-red-size 0)
                                              (accum-green-size 0)
                                              (accum-blue-size 0)
                                              stencil-buffer
                                              (stencil-size 0)
                                           profile
                                           (gl t))
  "Creates a new window with an attached GL context using the provided
   visual attributes.

   Major and minor arguments specify the context version to use. When
   NIL (default value) old style gl context creation is used. Some
   combinations of platforms and drivers may require :PROFILE :CORE to
   use versions newer than 2.1, while others will use newest version
   even if version is not specified.

   The created window will be of the WINDOW class, you can override this by
   specifying your own class using :WIN-CLASS."
  (let ((win (make-instance win-class)))
    (open-window win title width height
                 :x x :y y
                 :double-buffer double-buffer
                 :stereo stereo
                 :red-size red-size
                 :green-size green-size
                 :blue-size blue-size
                 :alpha-size alpha-size
                 :depth-size depth-size
                 :accum-buffer accum-buffer
                 :accum-red-size accum-red-size
                 :accum-green-size accum-green-size
                 :accum-blue-size accum-blue-size
                 :stencil-buffer stencil-buffer
                 :stencil-size stencil-size)
    (if gl
        (create-gl-context win :major major :minor minor
                               :make-current t
                               :profile profile)
        (setf (window-gl-context win) nil))
    (show-window win)
    (set-fullscreen win fullscreen)
    win))

(defun destroy-window (window)
   "Destroy the provided window and any attached GL context."
   (set-fullscreen window nil)
   (when (window-gl-context window)
     (destroy-gl-context (window-gl-context window)))
   (close-window window))

(defgeneric set-fullscreen (window &optional state)
  (:documentation
   "Set window to fullscreen state."))

;; (defmethod set-fullscreen :around (window &optional state)
;;   (unless (eq state (window-fullscreen window))
;;     (call-next-method)
;;     (setf (window-fullscreen window) state)))

(defun toggle-fullscreen (window)
  "Attempt to change display mode to the mode closest to geometry and
set window fullscreen state."
  (cond
    ((and (window-previous-video-mode window) (window-fullscreen window))
     (progn (set-fullscreen window nil)
            (set-video-mode (window-previous-video-mode window))
            (setf (window-previous-video-mode window) nil)))
    ((not (window-fullscreen window))
     (progn (setf (window-previous-video-mode window) (current-video-mode))
             (set-video-mode (closest-video-mode (current-video-mode)
                                                 (list-video-modes)
                                                 (window-width window)
                                                 (window-height window)))
             (set-fullscreen window t)))))

(defgeneric set-geometry (window x y width height)
  (:documentation
   "Configure window geometry."))

(defmethod (setf window-x) (x (win window))
  (set-geometry win x (window-y win) (window-width win) (window-height win)))

(defmethod (setf window-y) (y (win window))
  (set-geometry win (window-x win) y (window-width win) (window-height win)))

(defmethod (setf window-width) (width (win window))
  (set-geometry win (window-x win) (window-y win) width (window-height win)))

(defmethod (setf window-height) (height (win window))
  (set-geometry win (window-x win) (window-y win) (window-width win) height))

(defgeneric show-window (window)
  (:documentation
   "Make WINDOW visible. (may need to be called twice when window is
   shown for the first time on Windows.)"))

(defgeneric hide-window (window)
  (:documentation
   "Make WINDOW not visible."))

(defgeneric set-window-title (window title)
  (:documentation
   "Set WINDOW title to TITLE."))

(defgeneric swap-buffers (window)
  (:documentation
   "Swaps GL buffers."))

(defgeneric swap-interval (window interval)
  (:documentation
   "Specify number of vsync intervals to wait before swap-buffers takes effect.

Use 0 for no vsync, 1 for normal vsync, 2 for 1/2 monitor refresh rate, etc.

If INTERVAL is negativem the absolute value is used, and when
supported swap won't wait for vsync if specified interval has already
elapsed.

May be ignored or only partially supported depending on platform and
user settings.")
  ;; windows: only supports 0/1 when dwm is enabled (always on win8+ i think?)
  ;; (possibly could support > 1 with dwm, but hard to detect if some vsync
  ;;  already passed so would always wait N frames. Possibly could combine
  ;;  a normal SwapInterval call with N-1 and a dwmFlush?)
  ;; linux: todo (depends on GLX_EXT_swap_control, GLX_EXT_swap_control_tear
  ;; osx: todo
  ;; todo: some way to query supported options
  (:method (w i)
    ;; just do nothing by default for now
    (declare (ignore w i))))

(defgeneric show-cursor (window)
  (:documentation
   "Enable cursor display for WINDOW"))

(defgeneric hide-cursor (window)
  (:documentation
   "Disable cursor display for WINDOW"))

;; slightly lower-level API for things related to fullscreen
(defgeneric maximize-window (window)
  (:documentation
   "'Maximize' a window to fill screen, without changing screen mode
   or window decoractions."))

(defgeneric restore-window (window)
  (:documentation
   "Undo the effects of MAXIMIZE-WINDOW"))

(defgeneric remove-window-decorations (window)
  (:documentation
   "Remove window border, title, etc. if possible."))

(defgeneric restore-window-decorations (window)
  (:documentation
   "Restore window border, title, etc."))

;;; Events handling
(defmacro define-simple-print-object (type &rest attribs)
  `(defmethod print-object ((event ,type) stream)
     (with-slots ,attribs event
       (format stream
               ,(format nil "#<~~s~{ ~s ~~s~}>" attribs)
               (type-of event) ,@attribs))))

(defclass event () ()
  (:documentation "Common ancestor for all events."))

(defclass key-event (event)
  ((keycode :initarg :keycode :reader keycode)
   (keysym :initarg :keysym :reader keysym)
   (text :initarg :text :reader text)
   (pressed :initarg :pressed :reader pressed))
  (:documentation "Keyboard key press or release."))
(define-simple-print-object key-event keycode keysym text pressed)

(defclass key-press-event (key-event)
  ()
  (:default-initargs :pressed t)
  (:documentation "Keyboard key press."))

(defclass key-release-event (key-event)
  ()
  (:default-initargs :pressed nil)
  (:documentation "Keyboard key release."))

(defclass button-event (event)
  ((button :initarg :button :reader button)
   (pressed :initarg :pressed :reader pressed))
  (:documentation "Mouse button press or release."))
(define-simple-print-object button-event button pressed)

(defclass button-press-event (button-event)
  ()
  (:default-initargs :pressed t)
  (:documentation "Mouse button press."))

(defclass button-release-event (button-event)
  ()
  (:default-initargs :pressed nil)
  (:documentation "Mouse button release."))

(defclass mouse-motion-event (event)
  ((x :initarg :x :reader x)
   (y :initarg :y :reader y)
   (dx :initarg :dx :reader dx)
   (dy :initarg :dy :reader dy))
  (:documentation "Mouse motion."))
(define-simple-print-object mouse-motion-event x y dx dy)

(defclass expose-event (event)
  ((width :initarg :width :reader width)
   (height :initarg :height :reader height))
  (:documentation "Window expose."))
(define-simple-print-object expose-event width height)

(defclass resize-event (event)
  ((width :initarg :width :reader width)
   (height :initarg :height :reader height))
  (:documentation "Window resized."))
(define-simple-print-object resize-event width height)

(defclass close-event (event) ()
  (:documentation "Window closed."))

(defclass visibility-event (event)
  ((visible :initarg :visible :reader visible))
  (:documentation "Window visibility changed."))
(define-simple-print-object visibility-event visible)

(defclass visibility-obscured-event (visibility-event)
  ()
  (:default-initargs :visible nil)
  (:documentation "Window was fully obscured."))

(defclass visibility-unobscured-event (visibility-event)
  ()
  (:default-initargs :visible t)
  (:documentation "Window was unobscured."))

(defclass focus-event (event)
  ((focused :initarg :focused :reader focused))
  (:documentation "Window focus state changed."))
(define-simple-print-object focus-event focused)

(defclass focus-in-event (focus-event)
  ()
  (:default-initargs :focused t)
  (:documentation "Window received focus."))

(defclass focus-out-event (focus-event)
  ()
  (:default-initargs :focused nil)
  (:documentation "Window lost focus."))

(defclass child-event (event)
  ;; 'child' is platform specific id of child window for now.
  ;; might be nicer to wrap it in some class, but then we would have
  ;; to maintain a mapping of IDs to instances, and would probably
  ;; want some way for applications to specify which class as well
  ((child :initarg :child :reader child))
  (:documentation "Status of child window changed."))

(defclass child-created-event (child-event)
  ;; 'parent' is a platform specific ID, for similar reasons to
  ;; 'child' above...
  ((parent :initarg :parent :reader parent)
   (x :initarg :x :reader x)
   (y :initarg :y :reader y)
   (width :initarg :width :reader width)
   (height :initarg :height :reader height)))
(define-simple-print-object child-created-event x y width height)

(defclass child-destroyed-event (child-event)
  ;; 'parent' is a platform specific ID, for similar reasons to
  ;; 'child' above...
  ((parent :initarg :parent :reader parent)))
(define-simple-print-object child-destroyed-event parent child)

(defclass child-reparent-event (child-event)
  ;; 'parent' is a platform specific ID, for similar reasons to
  ;; 'child' above...
  ((parent :initarg :parent :reader parent)
   (x :initarg :x :reader x)
   (y :initarg :y :reader y)))
(define-simple-print-object child-reparent-event x y)

(defclass child-visibility-event (child-event)
  ((visible :initarg :visible :reader visible))
  (:documentation "Child window visibility changed."))
(define-simple-print-object child-visibility-event visible)

(defclass child-visibility-obscured-event (child-visibility-event)
  ()
  (:default-initargs :visible nil)
  (:documentation "Child window was fully obscured."))

(defclass child-visibility-unobscured-event (child-visibility-event)
  ()
  (:default-initargs :visible t)
  (:documentation "Child window was unobscured."))

(defclass child-resize-event (child-event)
  ;; possibly should store position too unless we figure out how to map
  ;; child IDs to actual window instances?
  ((width :initarg :width :reader width)
   (height :initarg :height :reader height))
  (:documentation "Child window resized."))
(define-simple-print-object child-resize-event width height)

(defun push-event (window evt)
  "Push an artificial event into the event processing system.
Note that this has no effect on the underlying window system."
  (setf (window-pushed-event window) evt))

(defun push-close-event (window)
  "Push an artificial :close event into the event processing system."
  (push-event window (make-instance 'close-event)))

(defgeneric next-event (window &key blocking)
  (:documentation
   "Returns next available event for manual processing.
   If :blocking is true, wait for an event."))

(defmethod next-event ((win window) &key blocking)
  (let ((pushed-evt (window-pushed-event win)))
    (if pushed-evt
        (progn (setf (window-pushed-event win) nil)
               pushed-evt)
        (%next-event win :blocking blocking))))

(defdfun %next-event (window &key blocking)
  "Real next-event implementation."
  (declare (ignore window blocking))
  (error 'not-implemented))

;; method based event handling
(defmacro dispatch-events (window &key blocking (on-foo t))
  "Process all pending system events and call corresponding methods.
When :blocking is non-nil calls event handling func that will block
until an event occurs.
Returns NIL on :CLOSE event, T otherwise."
  (let ((evt (gensym)))
  `(block dispatch-events
     (loop for ,evt = (next-event ,window :blocking ,blocking)
      while ,evt
      do ,(if on-foo
              `(typecase ,evt
                 (key-press-event (on-key ,window t (keycode ,evt) (keysym ,evt) (text ,evt)))
                 (key-release-event (on-key ,window nil (keycode ,evt) (keysym ,evt) (text ,evt)))
                 (button-press-event (on-button ,window t (button ,evt)))
                 (button-release-event (on-button ,window nil (button ,evt)))
                 (mouse-motion-event (on-mouse-motion ,window (x ,evt) (y ,evt)
                                                      (dx ,evt) (dy ,evt)))
                 (resize-event (on-resize ,window (width ,evt) (height ,evt)))
                 (expose-event (on-resize ,window (width ,evt) (height ,evt))
                               (on-draw ,window))
                 (visibility-event (on-visibility ,window (visible ,evt)))
                 (focus-event (on-focus ,window (focused ,evt)))
                 (close-event (on-close ,window)
                              (return-from dispatch-events nil))
                 (t (format t "Unhandled event type: ~S~%" (type-of ,evt))))
              `(progn (on-event ,window ,evt)
                      (when (eql (type-of ,evt) 'close-event)
                        (return-from dispatch-events nil))))
      finally (return t)))))


;; implement this genfun when calling dispatch-events with :on-foo NIL
(defgeneric on-event (window event))

(defmethod on-event (window event)
  (declare (ignore window))
  (format t "Unhandled event: ~S~%" event))

;; implement those when calling dispatch-events with :on-foo T
(defgeneric on-key (window pressed keycode keysym string))
(defgeneric on-button (window pressed button))
(defgeneric on-mouse-motion (window x y dx dy))
(defgeneric on-resize (window w h))
(defgeneric on-draw (window))
(defgeneric on-close (window))

;; these are here for completeness but default methods are provided
(defgeneric on-visibility (window visible))
(defgeneric on-focus (window focused))

(defmethod on-visibility (window visible)
  (declare (ignore window visible)))
(defmethod on-focus (window focused-p)
  (declare (ignore window focused-p)))

;; main loop anyone?
(defmacro with-idle-forms (window &body idle-forms)
  (let ((blocking (unless idle-forms t))
        (res (gensym)))
    `(loop with ,res = (dispatch-events ,window :blocking ,blocking)
        while ,res
        do ,(if idle-forms
                  `(progn ,@idle-forms)
                  t))))

(defmacro with-window ((win-sym title width height &rest attribs) &body body)
  "Creates a window and binds it to WIN-SYM.  The window is detroyed when body exits."
  `(let ((,win-sym (create-window ,title ,width ,height
                                  ,@attribs)))
     (when ,win-sym
       (unwind-protect (progn ,@body)
         (destroy-window ,win-sym)))))

;; multiple windows management
(defun set-gl-window (window)
  "Make WINDOW current for GL rendering."
  (attach-gl-context window (window-gl-context window)))
