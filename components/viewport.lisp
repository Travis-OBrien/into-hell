(in-package :components)

(def-class viewport
    :slots ((viewport (sdl::new-rect 0 0 128 128))
	    ;;sdl flip types:
	    ;;sdl-flip-none
	    ;;sdl-flip-horizontal
	    ;;sdl-flip-vertical
	    (flip-dir :sdl-flip-none)
	    (angle 0.0d0)
	    ;;pivot point is centerd at the character's feet by default.
	    ;;This is useful for scaling a character while keeping them grounded.
	    (pivot-point (sdl::new-point 64 128))
	    (offset-x 0)
	    (offset-y 0)))

(defmethod initialize-instance :after
    ((viewport viewport) &key (viewport-x 0) (viewport-y 0))
  (sdl::rect-set-x (:viewport viewport) viewport-x)
  (sdl::rect-set-y (:viewport viewport) viewport-y))

(defun get-pos
    (viewport)
  (list
   (sdl::rect-get-x (:viewport viewport))
   (sdl::rect-get-y (:viewport viewport))))

(defun get-dimension
    (viewport)
  (list
   (sdl::rect-get-w  (:viewport viewport))
   (sdl::rect-get-h (:viewport viewport))))

(defmethod :mem-management
    ((viewport viewport))
  (sdl::delete-rect (:viewport viewport))
  (sdl::delete-point (:pivot-point viewport)))
