(defun make-diabolo-stick
    (&key (pos #f(0 0 0)) (rot #f(0 0 0)))
  (let ((diabolo-stick (instance diabolo-stick :init :pos pos :rot rot)))
    diabolo-stick)
  )

(defun make-diabolo-stick-body ()
  (let ((a (make-cylinder 10 140))
	(b (make-cylinder 10 160 :pos (float-vector 0 0 -160))))
    (send a :set-color :white)
    (send b :set-color :gray)
    (setq c (body+ a b))
    c))

(defun make-diabolo-stick-body1 ()
  (let ((a (make-cylinder 10 140)))
    (send a :set-color :blue)
    a))

(defun make-diabolo-stick-body2 ()
  (let ((a (make-cylinder 10 160 :pos (float-vector 0 0 -160))))
    (send a :set-color :red)
    a))

(defclass diabolo-stick
  :super cascaded-link
  :slots (tool-length hold-length
		      body1 body2
		      center-coords hold-coords work-coords
		      com-coords))
(defmethod diabolo-stick
  (:init (&key pos rot)
	 (let ()
	   (send-super :init)

	   (setq tool-length (+ 140 160))
	   (setq hold-length 140)

	   (setq body1 (instance bodyset-link :init (make-cascoords) :bodies (list (make-diabolo-stick-body1)) :locate (float-vector 0 0 0)))
	   (setq body2 (instance bodyset-link :init (make-cascoords) :bodies (list (make-diabolo-stick-body2)) :locate (float-vector 0 0 0)))	   
	   (setq links (list body1 body2))
	   (setq joint-list (list))
	   (send self :assoc body1)
	   (send self :assoc body2)	   

	   (setq center-coords (make-cascoords :pos (float-vector 0 0 -10)))
	   (send self :assoc center-coords)

	   (setq hold-coords (make-cascoords :pos (float-vector 0 0 140)))
	   (send hold-coords :locate (float-vector 0 0 -70))
	   (send self :assoc hold-coords)

	   (setq work-coords (make-cascoords :pos (float-vector 0 0 -160)))
	   (send work-coords :locate (float-vector 0 0 0))
	   (send work-coords :rotate (/ pi -2) :y)
	   (send self :assoc work-coords)

	   (setq com-coords (make-cascoords :pos (float-vector 0 0 30)))
	   (send self :assoc com-coords)


	   (send self :locate pos)
	   (send self :rotate (elt rot 0) :x)
	   (send self :rotate (elt rot 1) :y)
	   (send self :rotate (elt rot 2) :z)
	   
	   (send self :init-ending)
	   self))
  
  (:self (&optional (new-self nil) (world :world))
		  (if (eq new-self nil)
		      self
		    (send self :move-to new-self world))
		  )
  (:center-coords () center-coords)
  (:hold-coords () hold-coords)
  (:work-coords () work-coords)
  (:com-coords () com-coords)
  )

(defmethod diabolo-stick
  (:tool-length () tool-length)
  
  (:random-locate (px py pz rx ry rz)   ;; [m] and [rad]
		  (let ()
		    (send self :self (make-cascoords :pos (float-vector px py pz)) :world)
		    (send self :self (make-cascoords :angle rx :axis :x) :local)
		    (send self :self (make-cascoords :angle ry :axis :y) :local)		    
		    (send self :self (make-cascoords :angle rz :axis :z) :local)  
		    ))
  (:random-hold-coords
   (length-rate theta-rate)   ;; [rate]
   (let ((tmp-hold-coords (send self :copy-worldcoords))
	 (min-length (+ 0 20))
	 (max-length (- 140 20))
	 (min-theta -30)
	 (max-theta 30)
	 )
     (send tmp-hold-coords :locate
	   (float-vector 0 0 (+ (* length-rate (- max-length min-length)) min-length)))
     (send tmp-hold-coords :rotate
	   (deg2rad (+ (* theta-rate (- max-theta min-theta)) min-theta)) :y)

     #|
     (objects (list self
		    tmp-hold-coords
		    ))
     |#     
     (send tmp-hold-coords :worldcoords))
   )
  )

#|
;;(setq *diabolo-stick* (make-diabolo-stick))
(setq *diabolo-stick* (make-diabolo-stick :pos (float-vector 700 0 710) :rot (float-vector 0 (/ pi 2) 0)))
(objects (list *diabolo-stick* (send *diabolo-stick* :center-coords) (send *diabolo-stick* :hold-coords) (send *diabolo-stick* :work-coords)))




(load "models/room73b2-foldable-desk-object.l")
(setq *environment* (room73b2-foldable-desk))
(send *environment* :move-to (make-cascoords :pos (float-vector 700 0 0)))

(defun execute ()
  (setq xx-max 5) ;; 20
  (setq yy-max 5) ;; 20
  (setq thetatheta-max 5) ;; 20
  (setq phaiphai-max 5) ;; 36
  
  (dotimes (xx xx-max)
    (dotimes (yy yy-max)
      (dotimes (thetatheta thetatheta-max)
	(dotimes (phaiphai phaiphai-max)
	  (let ((x (* xx 50)) (y (* (- yy (/ (- yy-max 1) 2)) 50)) (theta (* (- thetatheta (/ (- thetatheta-max 1) 2)) 5)) (phai (* phaiphai (/ 360 phaiphai-max))))
	    (send *diabolo-stick* :random-locate x y (deg2rad theta) (deg2rad phai))
	    (do-until-key)
	    (send *irtviewer* :draw-objects)
	    )
	  )
	)
      )
    )
  
  (send *diabolo-stick* :random-locate 0 0 0 0)
  )

(send *diabolo-stick* :random-locate 0 0 0 0)
(objects (list *diabolo-stick* (send *diabolo-stick* :center-coords) (send *diabolo-stick* :hold-coords) (send *diabolo-stick* :work-coords) *environment*))
#|
