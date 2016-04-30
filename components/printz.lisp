(in-package :components)

(def-class printz
    :slots ((statement "printz default")))

(ces/entity::def-system :printz
    printz scene
    (print (:statement printz)))

(defmethod initialize-instance :after ((printz printz) &key statement)
  (setf (:statement printz) statement))
