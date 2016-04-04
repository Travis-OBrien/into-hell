;;;; into-hell.lisp

(in-package :into-hell)

;;; "into-hell" goes here. Hacks and glory await!

;;;;update
(defun update
    (scene)
  (ces/da:update scene))

;;;;render
(defun render
    (scene)
  (let*   ((renderer (:renderer scene))
	   ;testing viewport and clipping
	   ;the dest-rect (viewport) will scale any image to FIT itself.
	   ;the src-rect (clip) is a rect that specifies what part of the image to render.
	   ;when using this with sprite sheets,
	   ;   the viewport and clip must have the same dimensions to avoid
	   ;   any image warping. the viewport will then dictate where to
	   ;   draw the image onto the screen.
	   (viewport (new-rect 0 0 128 128)))
	   
    (render-clear renderer)
    ;testing viewports
    (sdl-rendersetviewport renderer viewport)
    ;first iteration grabs the render-order map and looks up an index wich returns an array.
    (loop
       for render-order across (:render-order scene) ;index from 1 to (length-of (:render-order scene))
       do
	 ;second iteration iterates across the array which will grab entities to render.
	 (loop
	    for entity across render-order;(gethash index (:render-order scene))
	    do
	      (sdl-rendercopy renderer
			      ;texture to sample from.
			      ;grab the animation's name from the entity object, then look up the animation
			      ;within the asset-manager to find the texture it uses.
			      (gethash
			       (:texture (gethash (:animation-name entity) (:animations (:asset-manager scene))))
			       (:images (:asset-manager scene)))
			    
			      ;entity's sprite coordinate
			      (:current-frame entity)
			      
			      viewport)))
    
    (render-present renderer)
    ))

;;;;start
(defun start
    ()
  (sdl:init)
  (let* ((scene (ces/da:scene)))
    (set-slots scene
	       :running? t
	       :window (sdl:create-window "age of conan ripoff" 640 480)
	       :update (lambda (scene) (update scene))
	       :render (lambda (scene) (render scene)))
    ;(print scene)
    ;create renderer : hardware-accelerated = 2, vsyn = 4

    ;(set-slots (:window game) :renderer (sdl:sdl-createrenderer (:address (:window game)) 1 (logior 2 4)))

    (set-slots scene :renderer (sdl:sdl-createrenderer (:address (:window scene)) 1 (logior 2 4)))
    
    ;set renderer draw color
    (sdl:set-render-draw-color (:renderer scene) 0 0 0 255)
    ;init image : TODO : this should include multiple flags for all types of images.
    (sdl:img-init 4);I think 4 represents png

    
    (set-slots scene :asset-manager
	       (game-utilities/asset-manager:asset-manager
		:all-images '("sprite_sheet")
		:all-audio  '()
		:renderer   (:renderer scene)
		:animations {:human-run-cycle => (game-utilities/asset-manager:animation :fps 8
								:texture :sprite_sheet
								:sprite-coordinates (make-vector 1
												 (new-rect 160 0 16 16)
												 (new-rect 176 0 16 16)
												 (new-rect 192 0 16 16)
												 (new-rect 208 0 16 16))),
		             :mushroom        => (game-utilities/asset-manager:animation :fps 4
								:texture :sprite_sheet
								:sprite-coordinates (make-vector 1
												 (new-rect 0   96 16 16)
												 (new-rect 16  96 16 16)
												 (new-rect 32  96 16 16)
												 (new-rect 48  96 16 16)
												 (new-rect 64  96 16 16)
												 (new-rect 80  96 16 16)
												 (new-rect 96  96 16 16)
												 (new-rect 112 96 16 16)))}))

    (ces/da:attach-systems scene :printz :animation)
    (let* ((player (entities:player :statement "infamous printz" :animation-name :human-run-cycle)))

      ;;;;TODO directly attaching an entity to scene
      ;;;;this should be handled automatically.
      (ces/da:attach-entities scene player)

      ;;;;TODO directly attaching an entity to :render-order
      ;;;;this should be handled automatically.

      ;(attach (gethash 1 (:render-order scene)) player)
      (attach (aref (:render-order scene) 0) player)

      (game-utilities/game-utilities:start scene))))

(start)

(export-all-symboles-except nil)
