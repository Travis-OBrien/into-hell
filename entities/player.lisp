(in-package :entities)

(ces/entity:def-entity player
    :constructor (lambda (statement animation-name))
    :extends (printz ces/component:animation))

(export-all-symbols-except nil)
