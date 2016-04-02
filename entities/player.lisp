(in-package :entities)

(ces/entity:def-entity player
    :constructor (lambda (statement animation-name))
    :extends (printz spritesheet-animation))

(export-all-symbols-except nil)
