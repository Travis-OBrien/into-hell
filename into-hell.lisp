;;;; into-hell.lisp

(in-package :into-hell)

;;; "into-hell" goes here. Hacks and glory await!

;;;;update
(defun update
    (scene)
  (if (game-utilities/event-manager::gui-quit?)
      (progn
	(setf (:running? scene) nil)
	(ces/da::quit scene))
      ;;else
      (progn
	;;(ces/component::build-quad-tree scene)
	(ces/da::update scene))))

;;;;render
(defun render
    (scene)
  (if (not (game-utilities/event-manager::gui-quit?))
      (ces/da::render scene)))

(var x1 600 y1 300)
;;;;debug
(defun debug-entity
    (scene)
  (if (not (game-utilities/event-manager::gui-quit?))
      (progn
	(ces/da::debug-entity scene)

	(test-fn scene)
	)))

;;this fn is purely for throwing around arbitrary code.
;;use this to implement new features, it is the very
;;last fn to be called per frame.
(defun test-fn
    (scene)
  (let* ((r1 (sdl::new-rect 80 80 30 200))
	 (r2 (sdl::new-rect 200 50 100 100))
	 (r3 (ces/component::AABB-expand r2 r1)))
    (sdl::set-render-draw-color (:renderer scene) 0 0 255 255)
    (sdl::sdl-renderdrawrect (:renderer scene) r1)
    (sdl::set-render-draw-color (:renderer scene) 255 0 0 255)
    (sdl::sdl-renderdrawrect (:renderer scene) r2)
    ;;(sdl::set-render-draw-color (:renderer scene) 255 0 255 255)
    ;;(sdl::sdl-renderdrawrect (:renderer scene) r3)
    (multiple-value-bind
	  (line1 line2 line3 line4)
	(ces/component::AABB-decompose-lines r3)
      (sdl::draw-lines-GUI scene
			      (list line1 line2 line3 line4)
			      (list '(255 255 255 255) '(255 0 0 255) '(0 255 255 255) '(0 255 0 255)))

      (loop for line in (list line1 line2 line3 line4)
	 do (multiple-value-bind
		  (n1 n2)
		(math::pretty-normal-of-line-GUI line 10)
	      (sdl::draw-lines-GUI scene
				   (list n1 n2)
				   (list '(0 0 255 255) '(150 0 150 255))))))



    (ces/component::rebuild-quadtree scene)
    (let* ((player (ces/da::find-entity scene :player))
	   (dir (ces/component::get-collider-direction player))
	   (qt-sorted (ces/component::sort-quadtree-segment (remove player
								    (:quadtree scene))
							    dir)))
      (print (to-string "DIR: " dir))
      (ces/component::resolve-dynamic scene
				      player
				      qt-sorted)

      ;;visual debug qt-sort
      (let* ((rects (loop for e across qt-sorted
		       collect (:collider-rect e)))
	     (colors (loop
			for c upto (- (length rects) 1)
			for x = 255 then (- x 20)
			collect (list x 0 0 255))))
	(sdl::draw-rects-INGAME scene (:rect (ces/da::direct-reference scene :camera)) rects colors :type :fill)
	))
    
    ;;(let* ((static-tiles (loop for entity across (:entities scene)
    ;;			    when (eq (:tag entity) :static-tile)
    ;;			    collect entity)))
    ;;
    ;;  (ces/component::resolve-dynamic scene (ces/da::find-entity scene :player) (map 'vector #'identity static-tiles)))
    
    ;;(ces/component::resolve-dynamic scene (ces/da::find-entity scene :player) (make-vector (ces/da::find-entity scene :static-tile)))
    ))

;;;;start
(defun start
    ()
  (sdl::init)
  (let* ((screen-width  640)
	 (screen-height 480))
    (var scene (make-instance 'ces/da::scene
			       :running? t
			       :window (sdl:create-window "age of conan ripoff" screen-width screen-height)
			       :update       (lambda (scene) (update       scene))
			       :render       (lambda (scene) (render       scene))
			       :debug-entity (lambda (scene) (debug-entity scene))
			       ))
    
    ;;create renderer : hardware-accelerated = 2, vsyn = 4
    (setf (:renderer scene) (sdl::sdl-createrenderer (:address (:window scene)) 1 (logior 2 4)))
    
    ;;set renderer draw color
    (sdl::set-render-draw-color (:renderer scene) 0 0 0 255)

    ;;TODO refactor this to be within sdl::init fn
    ;;init image : TODO : this should include multiple flags for all types of images.
    (sdl::img-init 4);;I think 4 represents png
    (if (< (sdl::mix-openaudio 44100 32784 2 2048) 0)
	(print (to-string "audio failed to init: " (sdl::sdl-geterror))))

    ;;init the asset manager ;;this is a mutable operation
    (game-utilities/asset-manager::init-asset-manager
     :all-images '("sprite_sheet")
     :all-audio-bites '("magic_spell")
     :all-audio-music '("forming")
     :renderer   (:renderer scene)
     :animations (make-map-simple
		  :human-idle (game-utilities/asset-manager::animation :fps 24
								       :texture :sprite_sheet
								       :sprite-coordinates (make-vector (new-rect 160 16 16 16)
													(new-rect 176 16 16 16)))
		  :human-run  (game-utilities/asset-manager::animation :fps 8
								       :texture :sprite_sheet
								       :sprite-coordinates (make-vector (new-rect 160 0 16 16)
													(new-rect 176 0 16 16)
													(new-rect 192 0 16 16)
													(new-rect 208 0 16 16)))
		  :mushroom   (game-utilities/asset-manager::animation :fps 4
								       :texture :sprite_sheet
								       :sprite-coordinates (make-vector (new-rect 0   96 16 16)
													(new-rect 16  96 16 16)
													(new-rect 32  96 16 16)
													(new-rect 48  96 16 16)
													(new-rect 64  96 16 16)
													(new-rect 80  96 16 16)
													(new-rect 96  96 16 16)
													(new-rect 112 96 16 16)))
		  :bat-fly    (game-utilities/asset-manager::animation :fps 8
								       :texture :sprite_sheet
								       :sprite-coordinates (make-vector (new-rect 160 96 16 16)
													(new-rect 176 96 16 16)))

		  )
     :sprites (make-map-simple
	       :grass-stand-alone (game-utilities/asset-manager::sprite :texture :sprite_sheet
									:sprite-coordinate (new-rect 48 32 16 16))))
     
    
    (ces/da::attach-systems scene
			    :collider-previous-position
			    ;;:gravity
			    
			    :add-remove :printz :sprite :animation
			    :swap-animation :run :fly-across-screen ;;:follow-mouse
			    
			    ;;:resolve-collision-phase1
			    ;;:resolve-collision-phase2
			    
			    :camera-movement
			    :collider-sync-viewport
			    )
    (ces/da::attach-systems-debug scene
				  :debug-collider-rect)
    (let* ((player (make-instance 'entities::player
				  :animation-name :human-idle
				  ;;:x 0 :y 0
				  :offset-x -32
				  :render-order 0
				  :tag :player
				  ;;:collider (sdl::new-rect 0 -100 64 128)
				  :collider (sdl::new-rect 0 100 64 128)
				  :collider-type :dynamic
				  ))
	   (static-tile1 (make-instance 'entities::static-tile
					:sprite-name :grass-stand-alone
					:viewport-x 0 :viewport-y 0
					:render-order 1
					:tag :static-tile
					:collider (sdl::new-rect 300 250 128 128)))
	   (static-tile2 (make-instance 'entities::static-tile
					:sprite-name :grass-stand-alone
					:viewport-x 0 :viewport-y 0
					:render-order 1
					:tag :static-tile
					:collider (sdl::new-rect 428 250 128 128)))
	   (static-tile3 (make-instance 'entities::static-tile
					:sprite-name :grass-stand-alone
					:viewport-x 0 :viewport-y 0
					:render-order 1
					:tag :static-tile
					:collider (sdl::new-rect 556 250 128 128)))
	   (static-tile4 (make-instance 'entities::static-tile
					:sprite-name :grass-stand-alone
					:viewport-x 0 :viewport-y 0
					:render-order 1
					:tag :static-tile
					:collider (sdl::new-rect 684 250 128 128)))
	   (static-tile5 (make-instance 'entities::static-tile
					:sprite-name :grass-stand-alone
					:viewport-x 0 :viewport-y 0
					:render-order 1
					:tag :static-tile
					:collider (sdl::new-rect 812 250 128 128)))
	   (static-tile6 (make-instance 'entities::static-tile
					:sprite-name :grass-stand-alone
					:viewport-x 0 :viewport-y 0
					:render-order 1
					:tag :static-tile
					:collider (sdl::new-rect 684 122 128 128)))
	   (static-tile7 (make-instance 'entities::static-tile
					:sprite-name :grass-stand-alone
					:viewport-x 0 :viewport-y 0
					:render-order 1
					:tag :static-tile
					:collider (sdl::new-rect 684 -6 128 128)))
	   (static-tile8 (make-instance 'entities::static-tile
					:sprite-name :grass-stand-alone
					:viewport-x 0 :viewport-y 0
					:render-order 1
					:tag :static-tile
					:collider (sdl::new-rect 684 -138 128 128)))
	   (static-tile9 (make-instance 'entities::static-tile
					:sprite-name :grass-stand-alone
					:viewport-x 0 :viewport-y 0
					:render-order 1
					:tag :static-tile
					:collider (sdl::new-rect 684 -262 128 128)))
	   (static-tile10 (make-instance 'entities::static-tile
					:sprite-name :grass-stand-alone
					:viewport-x 0 :viewport-y 0
					:render-order 1
					:tag :static-tile
					:collider (sdl::new-rect 684 -390 128 128)))
	   (static-tile11 (make-instance 'entities::static-tile
					:sprite-name :grass-stand-alone
					:viewport-x 0 :viewport-y 0
					:render-order 1
					:tag :static-tile
					:collider (sdl::new-rect 684 378 128 128)))
	   (bat (make-instance 'entities::bat
			       :animation-name :bat-fly
			       :viewport-x 100 :viewport-y 0
			       :render-order 1
			       :tag :bat))
	   (camera (make-instance 'entities::camera
				  :camera-x 0 :camera-y 0
				  :camera-width 640 :camera-height 480))
	   )

      ;;;;TODO directly attaching an entity to scene
      ;;;;this should be handled automatically. (Or should it???)
      (ces/da::attach-entities scene camera player
			       static-tile1 static-tile2 static-tile3 static-tile4 static-tile5
			       static-tile6 static-tile7 static-tile8 static-tile9 static-tile10 static-tile11
			       bat (make-instance 'entities::add-remove))

      ;;attach camera object to scene's direct-reference map.
      (ces/da::new-direct-reference scene camera :camera)
      ;;attach a rect which will be recycled used for various mutations.
      (ces/da::new-direct-reference scene (sdl::new-rect 0 0 0 0) :recycle-rect)

      ;;TESTING MUSIC
      ;;(play-music :forming)
      ;;TESTING BITE
      ;;(play-bite :magic_spell)
      
      (game-utilities/game-utilities::start scene))))

(start)
