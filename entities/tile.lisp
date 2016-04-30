(in-package :entities)

(ces/entity::def-entity static-animated-tile
    :with (ces/component::animation components::viewport ces/component::collider-rect))

(ces/entity::def-entity static-tile
    :with (ces/component::sprite components::viewport ces/component::collider-rect))

(defmethod initialize-instance :after
    ((static-tile static-tile) &key)
  t)

