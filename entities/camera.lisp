(in-package :entities)

(ces/entity::def-entity camera
    :slots ((rect nil))
    :with ())

(defmethod initialize-instance :after
    ((camera camera) &key camera-x camera-y camera-width camera-height)
  (setf (:rect camera) (new-rect camera-x camera-y camera-width camera-height)))

(ces/entity::def-system :camera-movement
    camera scene
    (let* ((player (ces/da::find-entity scene :player)))
      (if player
	  (let* ((camera (:rect camera))
		 (viewport-pos (components::get-pos player)))
	    ;;set camera to center around :player
	    (sdl::rect-set-x camera
			     (- (+ (/ (sdl::rect-get-w (:collider-rect player)) 2)
				   (sdl::rect-get-x (:collider-rect player)))
				(/ (sdl::rect-get-w camera) 2)))
	    (sdl::rect-set-y camera 
			     (- (+ (/ (sdl::rect-get-h (:collider-rect player)) 2)
				   (sdl::rect-get-y (:collider-rect player)))
				(/ (sdl::rect-get-h camera) 2)))
	    ))))

(defmethod :mem-management
    ((camera camera))
  (sdl::delete-rect (:rect camera)))
