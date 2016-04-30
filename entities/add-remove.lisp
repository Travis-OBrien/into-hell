(in-package :entities)

(ces/entity::def-entity add-remove)

(ces/entity::def-system :add-remove
    add-remove scene
    (let* ((player (ces/da::find-entity scene :player)))
      (cond ((key-down? :q) (if player (setf (:valid? player) nil)))
	    ((key-down? :e) (progn
				 (let* ((p (make-instance 'entities::player
									 :animation-name :human-idle
									 :x 100 :y 100
									 :render-order 0
									 :tag :player)))
				   (ces/da::attach-entities scene p)))))))
