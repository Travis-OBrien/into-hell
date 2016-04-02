(in-package :components)

(def-class spritesheet-animation
    :slots ((animation-name nil))
    :constructor (lambda (animation-name)
		   (set-slots spritesheet-animation :animation-name animation-name)))

(ces/entity:def-system :spritesheet-animation spritesheet-animation
  ((scene ces/da:scene))
  (gethash (:animation-name spritesheet-animation) (:animations (:asset-manager scene))))

;(export-all-symbols-except nil)
