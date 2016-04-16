(in-package :entities)

;;(ces/entity:def-entity player
;;    :with (printz ces/component::animation))

(ces/entity::def-entity player
    :with (components::printz ces/component::animation components::viewport))

(defmethod initialize-instance :after
    ((player player)
     &key statement animation-name)
  t)

(ces/entity::def-system :swap-animation
    player scene
  (cond ((or (game-utilities/event-manager::key-down? :a (:event-manager scene))
	     (game-utilities/event-manager::key-down? :d (:event-manager scene)))
	 (setf (:animation-name player) :human-run))

	;;all movement type keys have been released, reset all timers on animations.
	((or (game-utilities/event-manager::key-released? :a (:event-manager scene))
	     (game-utilities/event-manager::key-released? :d (:event-manager scene)))
	 (progn
	   ;;(print "reset animation")
	   (setf (:animation-name player) :human-idle)
	   (ces/component::reset player scene :human-idle :human-run)))
	
	;;no key is being held or pressed, the player is idle
	(:default
	 (setf (:animation-name player) :human-idle))))

(ces/entity::def-system :run
    player scene
  (let* ((run-speed 6)
	 (rect (:viewport player)))
    (if (game-utilities/event-manager::key-down? :d (:event-manager scene))
	(sdl::rect-set-x rect (+ (* 1 run-speed) (sdl::rect-get-x rect))))
    (if (game-utilities/event-manager::key-down? :a (:event-manager scene))
	(sdl::rect-set-x rect (+ (* -1 run-speed) (sdl::rect-get-x rect))))
    (if (game-utilities/event-manager::key-down? :w (:event-manager scene))
	(sdl::rect-set-y rect (+ (* -1 run-speed) (sdl::rect-get-y rect))))
    (if (game-utilities/event-manager::key-down? :s (:event-manager scene))
	(sdl::rect-set-y rect (+ (* 1 run-speed) (sdl::rect-get-y rect))))))
