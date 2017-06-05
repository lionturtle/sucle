(defpackage #:cl-glfw
  (:nicknames #:glfw)
  (:use #:cl #:cffi #:cl-glfw-types)
  (:shadowing-import-from #:cl-glfw-types #:boolean #:byte #:float #:char #:string)
  (:shadow #:sleep #:+red-bits+ #:+green-bits+ #:+blue-bits+
	   #:+alpha-bits+ #:+stencil-bits+ #:+depth-bits+
	   #:+accum-red-bits+ #:+accum-green-bits+ #:+accum-blue-bits+
	   #:+accum-alpha-bits+ #:+aux-buffers+ #:+stereo+
	   #:cond
	   #:enable #:disable)
  (:export *mouse-wheel-cumulative* *terminate-hooks* *init-hooks* #:+accelerated+ #:+accum-alpha-bits+ #:+accum-blue-bits+ #:+accum-green-bits+ #:+accum-red-bits+ #:+active+ #:+alpha-bits+ #:+alpha-map-bit+ #:+auto-poll-events+ #:+aux-buffers+ #:+axes+ #:+blue-bits+ #:+build-mipmaps-bit+ #:+buttons+ #:+depth-bits+ #:+false+ #:+fsaa-samples+ #:+opengl-version-major+ #:+opengl-version-minor+ #:+opengl-forward-compat+ #:+opengl-debug-context+ #:+opengl-profile+ #:+fullscreen+ #:+green-bits+ #:+iconified+ #:+infinity+ #:+joystick-1+ #:+joystick-10+ #:+joystick-11+ #:+joystick-12+ #:+joystick-13+ #:+joystick-14+ #:+joystick-15+ #:+joystick-16+ #:+joystick-2+ #:+joystick-3+ #:+joystick-4+ #:+joystick-5+ #:+joystick-6+ #:+joystick-7+ #:+joystick-8+ #:+joystick-9+ #:+joystick-last+ #:+key-backspace+ #:+key-del+ #:+key-down+ #:+key-end+ #:+key-enter+ #:+key-esc+ #:+key-f1+ #:+key-f10+ #:+key-f11+ #:+key-f12+ #:+key-f13+ #:+key-f14+ #:+key-f15+ #:+key-f16+ #:+key-f17+ #:+key-f18+ #:+key-f19+ #:+key-f2+ #:+key-f20+ #:+key-f21+ #:+key-f22+ #:+key-f23+ #:+key-f24+ #:+key-f25+ #:+key-f3+ #:+key-f4+ #:+key-f5+ #:+key-f6+ #:+key-f7+ #:+key-f8+ #:+key-f9+ #:+key-home+ #:+key-insert+ #:+key-kp-0+ #:+key-kp-1+ #:+key-kp-2+ #:+key-kp-3+ #:+key-kp-4+ #:+key-kp-5+ #:+key-kp-6+ #:+key-kp-7+ #:+key-kp-8+ #:+key-kp-9+ #:+key-kp-add+ #:+key-kp-decimal+ #:+key-kp-divide+ #:+key-kp-enter+ #:+key-kp-equal+ #:+key-kp-multiply+ #:+key-kp-subtract+ #:+key-lalt+ #:+key-last+ #:+key-lctrl+ #:+key-left+ #:+key-lshift+ #:+key-pagedown+ #:+key-pageup+ #:+key-ralt+ #:+key-rctrl+ #:+key-repeat+ #:+key-right+ #:+key-rshift+ #:+key-space+ #:+key-special+ #:+key-tab+ #:+key-unknown+ #:+key-up+ #:+key-kp-num-lock+ #:+key-caps-lock+ #:+key-scroll-lock+ #:+key-pause+ #:+key-lsuper+ #:+key-rsuper+ #:+key-menu+ #:lispify-key #:lispify-mouse-button #:+mouse-button-1+ #:+mouse-button-2+ #:+mouse-button-3+ #:+mouse-button-4+ #:+mouse-button-5+ #:+mouse-button-6+ #:+mouse-button-7+ #:+mouse-button-8+ #:+mouse-button-last+ #:+mouse-button-left+ #:+mouse-button-middle+ #:+mouse-button-right+ #:+mouse-cursor+ #:+no-rescale-bit+ #:+nowait+ #:+opened+ #:+origin-ul-bit+ #:+present+ #:+press+ #:+red-bits+ #:+refresh-rate+ #:+release+ #:+stencil-bits+ #:+stereo+ #:+sticky-keys+ #:+sticky-mouse-buttons+ #:+system-keys+ #:+true+ #:+wait+ #:+window+ #:+window-no-resize+ #:boolean #:broadcast-cond #:close-window #:create-cond #:create-mutex #:create-thread #:defcfun+doc #:defcfun+out+doc #:destroy-cond #:destroy-mutex #:destroy-thread #:disable #:do-window #:enable #:extension-supported #:free-image #:get-desktop-mode #:get-gl-version #:get-joystick-buttons #:get-joystick-param #:get-joystick-pos #:get-key #:get-mouse-button #:get-mouse-pos #:get-mouse-wheel #:get-number-of-processors #:get-proc-address #:get-thread-id #:get-time #:get-version #:get-video-modes #:get-window-param #:get-window-size #:iconify-window #:init #:load-memory-texture-2d #:load-texture-2d #:load-texture-image-2d #:lock-mutex #:open-window #:open-window-hint #:poll-events #:read-image #:read-memory-image #:restore-window #:set-char-callback #:set-key-callback #:set-mouse-button-callback #:set-mouse-pos #:set-mouse-pos-callback #:set-mouse-wheel #:set-mouse-wheel-callback #:set-time #:set-window-close-callback #:set-window-pos #:set-window-refresh-callback #:set-window-size #:set-window-size-callback #:set-window-title #:signal-cond #:sleep #:swap-buffers #:swap-interval #:terminate #:unlock-mutex #:wait-cond #:wait-events #:wait-thread #:with-init #:with-init-window #:with-lock-mutex #:with-open-window))

#| exports generated by this, after the package is loaded:
(format t "~{#:~a~^ ~}" 
	(sort (mapcar #'(lambda (s) (string-downcase (format nil "~a" s)))
		      (remove-if-not #'(lambda (s)
					 (and (eql (symbol-package s) (find-package '#:glfw))
					      (or (constantp s) (fboundp s) (macro-function s))))
				     (loop for s being each symbol in '#:glfw collecting s)))
	      #'string<))
|#
