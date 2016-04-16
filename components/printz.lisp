(in-package :components)

(def-class printz
    :slots ((statement nil)))

;(ces/entity:def-system :printz printz
;  ((scene ces/da:scene))
;  (print statement))

(ces/entity::def-system :printz
    printz scene
  (print (:statement printz)))

(defmethod initialize-instance :after ((printz printz) &key statement)
  (setf (:statement printz) statement))

;(export-all-symbols-except nil)
