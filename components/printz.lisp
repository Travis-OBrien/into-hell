(in-package :components)

(def-class printz
    :slots ((statement nil));(statement "")
    :constructor (lambda (statement)
		   (set-slots printz :statement statement)))

(ces/entity:def-system :printz printz
  ((scene ces/da:scene))
  (print statement))

;(export-all-symbols-except nil)
