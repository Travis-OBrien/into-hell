(in-package :components)

(def-class viewport
    :slots ((viewport (sdl::new-rect 0 0 128 128))
	    ;;sdl flip types
	    ;;sdl-flip-none
	    ;;sdl-flip-horizontal
	    ;;sdl-flip-vertical
	    (sprite-flip-dir :sdl-flip-none)
	    (sprite-angle 0.0d0)
	    ;;pivot point is centerd at the character's feet by default.
	    ;;This is useful for scaling a character while keeping them grounded.
	    (sprite-pivot-point (sdl::new-point 64 128))))

(defmethod initialize-instance :after
    ((viewport viewport) &key x y)
  (sdl::rect-set-x (:viewport viewport) x)
  (sdl::rect-set-y (:viewport viewport) y))
