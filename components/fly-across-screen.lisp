(in-package :components)

(def-class fly-across-screen
    :slots ((fly-speed 8)))

(ces/entity::def-system :fly-across-screen
    fly-across-screen scene
    (let* ((fly-speed (:fly-speed fly-across-screen))
	   (rect (:viewport fly-across-screen)))
      (sdl::rect-set-x rect (+ (* 1 fly-speed) (sdl::rect-get-x rect)))
      (if (> (sdl::rect-get-x rect) 640)
	  (sdl::rect-set-x rect -128))))
