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
	   (viewport (new-rect 0 0 128 128))
	   (clip (new-rect 160 0 16 16)))
	   
    (render-clear renderer)
    ;testing viewports
    (sdl-rendersetviewport renderer viewport)
    ;first iteration grabs the render-order map and looks up an index wich returns an array.
    (loop
       for index from 1 to 5;(length-of (:render-order scene))
       do
	 ;second iteration iterates across the array which will grab entities to render.
	 (progn
	   (loop
	      for entity across (gethash index (:render-order scene))
	      do (progn
		   
		   (print "printing texture start...")
		   (print (gethash :sprite_sheet (:images (:asset-manager scene))))
		   (print "printing texture end...")
		   (sdl-rendercopy renderer
				   (gethash :sprite_sheet (:images (:asset-manager scene)))
				   
				   clip
					;entity goes here
					;()
				   
				   viewport)))))
    
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
		:animation-maps (list {
				  :name => :human-run-cycle,
				  :fps => 4,
				  :sprite-coordinates => '((160 0 16 16)
							   (176 0 16 16)
							   (192 0 16 16)
							   (208 0 16 16)),
				  :texture => "sprite_sheet"})))

    (ces/da:attach-systems scene :printz :spritesheet-animation)
    (let* ((player (entities:player :statement "hello!" :animation-name :human-run-cycle)))
      (ces/da:attach-entities scene player)

      ;;;TODO
      ;;;somehow all of the vectors from scene->render-order are being converted to simple
      ;;;vectors which cannot be extended. below is a hack to debug this sht.
      (let* ((arr (make-array 1 :adjustable t :fill-pointer 0)))
	(setf (gethash 1 (:render-order scene)) arr)
	(setf arr (attach (gethash 1 (:render-order scene)) player)))

      (print "GET HASH 1 PRINT")
      (print (gethash 1 (:render-order scene) player))
	
      (game-utilities/game-utilities:start scene))))

(start)

(export-all-symboles-except nil)
