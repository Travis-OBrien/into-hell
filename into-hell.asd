;;;; into-hell.asd
(asdf:defsystem #:into-hell
  :description "Describe into-hell here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (:utilities
               #:cffi
	       :sdl-game
	       :ces
	       )
  :serial t
  :components ((:file "package")
	       ;components
	       (:file "components/printz")
	       (:file "components/spritesheet-animation")
	       (:file "components/position")
	       (:file "components/fly-across-screen")
	       ;entities
	       (:file "entities/player")
	       (:file "entities/mushroom")
	       (:file "entities/bat")
	       
               (:file "into-hell")
	       ))

