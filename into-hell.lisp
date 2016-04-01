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
	   (viewport (new-struct rect ((x 0) (y 0) (w 128) (h 128))))
	   (clip (new-struct rect ((x 160) (y 16) (w 16) (h 16)))))
	   
    (render-clear renderer)
    ;testing viewports
    (sdl-rendersetviewport renderer viewport)
    ;global sample texture for testing
    (sdl-rendercopy renderer
		    (:texture scene)
		    ;updating the animation needs be done within the update loop.
		    ;the fn 'update-method' probly needs to be refactored now.
		    (game-utilities/animation:update-animation (:ani-obj scene)) 
		    ;clip
		    viewport)
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

    (set-slots scene
	       :texture (sdl:load-img "C:/sprite_sheet.png" (:renderer scene))
	       :ani-obj (game-utilities/animation:animation
			 
			 :fps 4
			 :sprite-coordinates '(((x 160) (y 0) (w 16) (h 16))
					       ((x 176) (y 0) (w 16) (h 16))
					       ((x 192) (y 0) (w 16) (h 16))
					       ((x 208) (y 0) (w 16) (h 16)))
			 :texture (:texture scene)))

    (print "animation created")
    
    ;;;;

    (set-slots scene :asset-manager
	       (game-utilities/asset-manager:asset-manager
		:all-images '("sprite_sheet")
		:all-audio  '()
		:renderer   (:renderer scene)
		:animation-maps (list {
				  :name => :human-run-cycle,
				  :fps => 4,
				  :sprite-coordinates => '(((x 160) (y 0) (w 16) (h 16))
							   ((x 176) (y 0) (w 16) (h 16))
							   ((x 192) (y 0) (w 16) (h 16))
							   ((x 208) (y 0) (w 16) (h 16))),
				  :texture => "sprite_sheet"})))
    
    (ces/da:attach-systems scene :printz)
    (ces/da:attach-entities scene (entities:player :statement "hello!"))
    ;(ces/da:attach-entities scene (entities:player :statement "kek!"))

    (game-utilities/game-utilities:start scene)))

(start)
