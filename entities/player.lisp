(in-package :entities)

;;(ces/entity:def-entity player
;;    :with (printz ces/component::animation))

(ces/entity::def-entity player
    :with (ces/component::animation components::viewport ces/component::collider-rect ces/component::physics))

(defmethod initialize-instance :after
    ((player player)
     &key)
  t)

(ces/entity::def-system :swap-animation
    player scene
  (cond ((or (key-down? :a)
	     (key-down? :d))
	 (setf (:animation-name player) :human-run))

	;;all movement type keys have been released, reset all timers on animations.
	((or (key-released? :a)
	     (key-released? :d))
	 (progn
	   ;;(print "reset animation")
	   (setf (:animation-name player) :human-idle)
	   (ces/component::reset player scene :human-idle :human-run)))
	
	;;no key is being held or pressed, the player is idle
	(:default
	 (setf (:animation-name player) :human-idle))))

(ces/entity::def-system :run
    player scene
    (let* ((h-run-speed 6)
	   (v-run-speed 6)
	   (rect (:collider-rect player)))
      (if (key-down? :d)
	  (sdl::rect-set-x rect (+ (* 1 h-run-speed) (sdl::rect-get-x rect))))
      (if (key-down? :a)
	  (sdl::rect-set-x rect (+ (* -1 h-run-speed) (sdl::rect-get-x rect))))
      (if (key-down? :w)
	  (sdl::rect-set-y rect (+ (* -1 v-run-speed) (sdl::rect-get-y rect))))
      (if (key-down? :s)
	  (sdl::rect-set-y rect (+ (* 1 v-run-speed) (sdl::rect-get-y rect))))))

(ces/entity::def-system :follow-mouse
    player scene
    (let* ((rect (:collider-rect player))
	   (mx (nth 0 (mouse-coordinate)))
	   (my (nth 1 (mouse-coordinate))))
      (sdl::rect-set-position rect mx my)))
