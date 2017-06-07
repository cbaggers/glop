;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10; indent-tabs-mode: nil -*-

(defpackage :glop
  (:use #:cl)
  (:export
   #:load-libraries
   ;; video modes
   #:list-video-modes #:set-video-mode #:current-video-mode
   ;; GL
   #:create-gl-context #:destroy-gl-context #:attach-gl-context #:detach-gl-context
   #:gl-get-proc-address
   ;; window
   #:window #:open-window #:close-window
   #:create-window #:destroy-window
   #:show-window #:hide-window #:set-window-title
   #:swap-buffers
   #:window-x #:window-y #:window-width #:window-height #:window-gl-context #:set-fullscreen
   #:set-geometry #:set-aspect-ratio #:toggle-fullscreen
   #:show-cursor #:hide-cursor
   ;; state
   #:key-pressed #:*ignore-auto-repeat*
   ;; events
   #:on-event #:next-event #:push-event #:push-close-event
   #:event #:key-event #:key-press-event #:key-release-event
   #:button-event #:button-press-event #:button-release-event
   #:mouse-motion-event #:expose-event #:resize-event
   #:map-event #:map-in-event #:map-out-event #:close-event
   #:visibility-event #:visibility-obscured-event #:visibility-unobscured-event #:visible
   #:focus-event #:focus-in-event #:focus-out-event #:focused
   #:pressed #:mapped #:width #:height #:keycode #:keysym #:text #:button
   #:repeat #:x #:y #:dx #:dy
   ;; events methods
   #:dispatch-events
   #:on-key #:on-button #:on-mouse-motion #:on-resize #:on-draw #:on-close
   ;; helper macros
   #:with-window #:with-idle-forms
   ;; multiple windows
   #:set-gl-window
   ;; platform-specific export for external event loop
   #+(and unix (not darwin))#:x11-window-id
   #+(and unix (not darwin))#:x11-window-display
   #+(or win32 windows)#:win32-window-id
   #:maximize-window
   #:restore-window
   #:remove-window-decorations
   #:restore-window-decorations
   #:swap-interval))


