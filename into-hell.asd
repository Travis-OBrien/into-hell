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
	       (:file "components/viewport")
	       (:file "components/fly-across-screen")
	       ;entities
	       (:file "entities/player")
	       (:file "entities/tile")
	       (:file "entities/bat")
	       (:file "entities/add-remove")
	       (:file "entities/camera")
	       
               (:file "into-hell")
	       ))

