(defun make-screw-driver
    (&key (pos #f(0 0 0)) (rot #f(0 0 0)))  
  (let ((screw-driver (instance screw-driver :init :pos pos :rot rot)))
    screw-driver)
  )

(defun make-screw-driver-body ()
  (let ((a (make-cube 5 5 160))
	(b (make-cube 30 5 5 :pos (float-vector 15 0 80))))
    (setq a (body+ a b))
    a))
(defclass screw-driver
  :super cascaded-link
  :slots (tool-length hold-length
		      body center-coords hold-coords work-coords))
(defmethod screw-driver
  (:init (&key pos rot)
	 (let ()
	   (send-super :init)

	   ;;(setq tool-length 150)
	   ;;(setq hold-length 50)

	   (setq body (instance bodyset-link :init (make-cascoords) :bodies (list (make-screw-driver-body)) :locate (float-vector 0 0 0)))
	   (setq links (list body))
	   (setq joint-list (list))
	   (send self :assoc body)

	   (setq center-coords (make-cascoords))
	   (send self :assoc center-coords)

	   (setq hold-coords (make-cascoords :pos (float-vector 0 0 80)))
	   (send hold-coords :locate (float-vector 0 0 0))
	   (send hold-coords :rotate (/ pi 2) :y)
	   (send self :assoc hold-coords)

	   (setq work-coords (make-cascoords :pos (float-vector 0 0 -80)))
	   (send work-coords :locate (float-vector 0 0 0))
	   (send work-coords :rotate (/ pi -2) :y)
	   (send self :assoc work-coords)

	   (send self :locate pos)
	   (send self :rotate (elt rot 0) :x)
	   (send self :rotate (elt rot 1) :y)
	   (send self :rotate (elt rot 2) :z)	   	   
	   
	   (send self :init-ending)
	   self))
  
  (:center-coords () center-coords)
  (:hold-coords () hold-coords)
  (:work-coords () work-coords)    
  )

#|
(setq *screw-driver* (make-screw-driver))
(objects (list *screw-driver* (send *screw-driver* :center-coords) (send *screw-driver* :hold-coords) (send *screw-driver* :work-coords)))
#|
