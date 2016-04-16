(in-package :entities)

(ces/entity::def-entity mushroom
    :with (components::printz ces/component::animation components::viewport))

(defmethod initialize-instance :after
    ((mushroom mushroom)
     &key statement animation-name)
  t)
