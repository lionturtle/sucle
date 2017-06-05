(defpackage #:window
  (:use #:cl #:fuktard)
  (:nicknames #:E) ;;capital e is the egyptian glyph for "window" 
  (:export
   #:*keypress-hash*
   #:*mousepress-hash*
   #:*scroll-x*
   #:*scroll-y*
   #:*chars*)
  (:export
   #:key-p
   #:key-r-or-p
   #:key-j-p
   #:key-r
   #:key-j-r
   #:mice-p
   #:mice-r-or-p
   #:mice-j-p
   #:mice-r
   #:mice-j-r)
  (:export
   #:get-proc-address
   #:init
   #:poll
   #:wrapper
   #:update-display
   #:set-vsync
   #:push-dimensions  
   #:set-caption)  
  (:export
   #:get-mouse-out
   #:get-mouse-position
   #:mice-locked-p
   #:mice-free-p
   #:toggle-mouse-capture)
  (:export
   #:*width*
   #:*height*
   #:*status*)
  (:export
   #:*resize-hook*))
