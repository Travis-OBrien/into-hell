;;;; into-hell.lisp

(in-package :into-hell)

;;; "into-hell" goes here. Hacks and glory await!

;;;;update
(defun update
    (scene)
  (ces/da::update scene))

;;;;render
(defun render
    (scene)
  (let* ((renderer (:renderer scene)))
    (sdl::update-viewport (:window scene))
    (render-clear renderer)
    ;;only render the screen's dimensions.
    (sdl-rendersetviewport renderer (:viewport (:window scene)))
    ;;first iteration grabs the render-order map and looks up an index wich returns an array.
    (loop
       for render-order across (:render-order scene)
       do
       ;;second iteration iterates across the array which will grab entities to render.
	 (loop
	    for entity across render-order
	    do
	      (sdl-rendercopyex renderer
			      ;;texture to sample from.
			      ;;grab the animation's name from the entity object, then look up the animation
			      ;;within the asset-manager to find the texture it uses.
			      (gethash
			       (:texture (gethash (:animation-name entity) (:animations (:asset-manager scene))))
			       (:images (:asset-manager scene)))
			    
			      ;;entity's sprite coordinate
			      (:current-frame entity)
			      ;;control the scale
			      (:viewport entity)
			      
			      (:sprite-angle entity)
			      (:sprite-pivot-point entity)
			      (cffi:foreign-enum-value 'sdl-rendererflip (:sprite-flip-dir entity))
			      )))
    ;;finally, render everything to the screen.
    (render-present renderer)))

;;;;start
(defun start
    ()
  (sdl:init)
  ;(var scene (ces/da:scene))
  (let* ((scene (make-instance 'ces/da::scene
			       :running? t
			       :window (sdl:create-window "age of conan ripoff" 640 480)
			       :update (lambda (scene) (update scene))
			       :render (lambda (scene) (render scene))
			       :event-manager (make-instance 'game-utilities/event-manager::event-manager)
			       ))) ;;(ces/da:scene)
    
    ;;create renderer : hardware-accelerated = 2, vsyn = 4

    ;;(set-slots (:window game) :renderer (sdl:sdl-createrenderer (:address (:window game)) 1 (logior 2 4)))


    (setf (:renderer scene) (sdl:sdl-createrenderer (:address (:window scene)) 1 (logior 2 4)))
    
    ;;set renderer draw color

    (sdl:set-render-draw-color (:renderer scene) 0 0 0 255)
    ;;init image : TODO : this should include multiple flags for all types of images.

    (sdl:img-init 4);;I think 4 represents png


    
    (setf
     (:asset-manager scene)
     (make-instance 'game-utilities/asset-manager::asset-manager
      :all-images '("sprite_sheet")
      :all-audio  '()
      :renderer   (:renderer scene)
      :animations {
      :human-idle => (game-utilities/asset-manager::animation :fps 24
							      :texture :sprite_sheet
							      :sprite-coordinates (make-vector (new-rect 160 16 16 16)
											       (new-rect 176 16 16 16))),
      :human-run  => (game-utilities/asset-manager::animation :fps 8
							      :texture :sprite_sheet
							      :sprite-coordinates (make-vector (new-rect 160 0 16 16)
											       (new-rect 176 0 16 16)
											       (new-rect 192 0 16 16)
											       (new-rect 208 0 16 16))),
      :mushroom   => (game-utilities/asset-manager::animation :fps 4
							      :texture :sprite_sheet
							      :sprite-coordinates (make-vector (new-rect 0   96 16 16)
											       (new-rect 16  96 16 16)
											       (new-rect 32  96 16 16)
											       (new-rect 48  96 16 16)
											       (new-rect 64  96 16 16)
											       (new-rect 80  96 16 16)
											       (new-rect 96  96 16 16)
											       (new-rect 112 96 16 16))),
      :bat-fly   => (game-utilities/asset-manager::animation :fps 8
							     :texture :sprite_sheet
							     :sprite-coordinates (make-vector (new-rect 160 96 16 16)
											      (new-rect 176 96 16 16)))}))

    (ces/da::attach-systems scene :printz :animation :swap-animation :run :fly-across-screen)
    (let* ((player (make-instance 'entities::player
				  :statement "infamous printz"
				  :animation-name :human-idle
				  :x 100
				  :y 100))
	   (mushroom (make-instance 'entities::mushroom
				    :statement "MUSHROOM"
				    :animation-name :mushroom
				    :x 0
				    :y 0))
	   (bat (make-instance 'entities::bat
			       :animation-name :bat-fly
			       :x 100 :y 0))
	   
	   )

      ;;;;TODO directly attaching an entity to scene
      ;;;;this should be handled automatically.
      (ces/da::attach-entities scene player mushroom bat)

      ;;;;TODO directly attaching an entity to :render-order
      ;;;;this should be handled automatically.

      ;;(attach (gethash 1 (:render-order scene)) player)
      (attach (aref (:render-order scene) 0) player mushroom bat)

      (game-utilities/game-utilities:start scene))))

(start)

(export-all-symboles-except nil)
