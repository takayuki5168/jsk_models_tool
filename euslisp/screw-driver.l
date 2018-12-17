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

(defun make-screw-driver-short-body ()
  (let ((a (make-cube 5 5 160)))
    a))
(defun make-screw-driver-long-body ()
  (let ((a (make-cube 30 5 5 :pos (float-vector 15 0 80))))
    a))


(defclass screw-driver
  :super cascaded-link
  :slots (tool-length hold-length
		      ;;body
		      long-body middle-body short-body joint1 joint2
		      center-coords
		      loose-hold-coords loose-work-coords
		      tight-hold-coords tight-work-coords
		      tight-flag))
(defmethod screw-driver
  (:init (&key pos rot)
	 (let ()
	   (send-super :init)

	   ;;(setq tool-length 150)
	   ;;(setq hold-length 50)


	   ;; links
	   (setq b (make-cube 5 5 160))
	   (send b :locate (float-vector 0 0 80))
	   (send b :set-color :gray)
	   (setq long-body (instance bodyset-link :init (make-cascoords) :bodies (list b) :name 'long-body))
	   
	   (setq b (make-cube 0 0 0))
	   (send b :locate (float-vector 0 0 0))
	   (send b :set-color :gray)
	   (setq middle-body (instance bodyset-link :init (make-cascoords) :bodies (list b) :name 'middle-body))

	   (setq b (make-cube 30 5 5))
	   (send b :locate (float-vector 15 0 0))
	   (send b :set-color :gray)
	   (setq short-body (instance bodyset-link :init (make-cascoords) :bodies (list b) :name 'short-body))

	   (setq links (list long-body middle-body short-body))

	   ;; joint-list
	   (setq joint1 (instance rotational-joint :init :parent-link long-body :child-link middle-body :axis :z))
	   (setq joint2 (instance rotational-joint :init :parent-link middle-body :child-link short-body :axis :x))
	   (setq joint-list (list joint1 joint2))
	   
	   (send self :assoc long-body)
	   (send long-body :assoc middle-body)
	   (send middle-body :assoc short-body)

	   ;; TODO
	   (setq tight-flag t)

	   ;; center-coords
	   (setq center-coords (make-cascoords))
	   (send self :assoc center-coords)

	   ;; hold-coords
	   (setq loose-hold-coords (make-cascoords :pos (float-vector 0 0 80)))
	   (send loose-hold-coords :locate (float-vector 0 0 0))
	   (send loose-hold-coords :rotate (/ pi 2) :y)
	   (send self :assoc loose-hold-coords)
	   
	   (setq tight-hold-coords (make-cascoords :pos (float-vector 0 0 -80)))
	   (send tight-hold-coords :locate (float-vector 0 0 0))
	   ;;(send tight-hold-coords :rotate (/ pi -2) :y)
	   (send self :assoc tight-hold-coords)


	   ;; work-coords
	   (setq loose-work-coords (make-cascoords :pos (float-vector 0 0 -80)))
	   (send loose-work-coords :locate (float-vector 0 0 0))
	   (send loose-work-coords :rotate (/ pi -2) :y)
	   (send self :assoc loose-work-coords)
	   
	   (setq tight-work-coords (make-cascoords :pos (float-vector 30 0 80)))
	   (send tight-work-coords :locate (float-vector 0 0 0))
	   ;;(send tight-work-coords :rotate (/ pi 2) :y)
	   (send self :assoc tight-work-coords)
	   
	   ;; set position and rotation
	   (send self :locate pos)
	   (send self :rotate (elt rot 0) :x)
	   (send self :rotate (elt rot 1) :y)
	   (send self :rotate (elt rot 2) :z)
	   
	   (send self :init-ending)
	   self))

  (:short-body-coords (&optional (new-coords nil))
		      (if (eq new-coords nil)
			  short-body
			(progn
			  (print (send new-coords :worldcoords))
			  ;;(setq tmp-coords (send (send short-body :worldcoords) :inverse-transform-vector (send new-coords :worldcoords)))
			  ;;(send short-body :move-to tmp-coords)
			  (send short-body :move-to new-coords :world)
			  ;;(send short-body :locate new-coords :world)
			  )
			))

		      
  (:self-coords (&optional (new-self-coords nil))
		  (if (eq new-self-coords nil)
		      self-coords
		    (send self :move-to new-self-coords :world))
		  )
  
  (:set-tight-flag (flag)
		   (setq tight-flag flag))
  
  (:center-coords (&optional (new-center-coords nil))
		  (if (eq new-center-coords nil)
		      center-coords
		    (send center-coords :move-to new-center-coords))
		  )
  (:hold-coords (&optional (new-hold-coords nil))
		  (if (eq new-hold-coords nil)
		      (if (eq tight-flag t)
			  tight-hold-coords
			loose-hold-coords)
		    (if (eq tight-flag t)
			(send tight-hold-coords :move-to new-hold-coords)
			(send loose-hold-coords :move-to new-hold-coords))
		    ))
  (:work-coords (&optional (new-work-coords nil))
		  (if (eq new-work-coords nil)
		      (if (eq tight-flag t)
			  tight-work-coords
			loose-work-coords)
		    (if (eq tight-flag t)
			(send tight-work-coords :move-to new-work-coords)
			(send loose-work-coords :move-to new-work-coords))
		  ))
  )

#|
(setq *screw-driver* (make-screw-driver))
(objects (list *screw-driver* (send (send *screw-driver* :short-body-coords) :worldcoords)));; (send *screw-driver* :hold-coords) (send *screw-driver* :work-coords)))

(send *screw-driver* :angle-vector #f(45 45))
(send *screw-driver* :short-body-coords (make-cascoords :pos (float-vector 100 100 100))))
;;(send *screw-driver* :short-body-coords (make-cascoords))
|#

#|
(setq *screw-driver* (make-screw-driver :pos (float-vector 600 0 800)))
(load "package://pr2eus/pr2-interface.l")
(pr2-init)
(send *pr2* :rarm :inverse-kinematics (send *screw-driver* :hold-coords))
(send *pr2* :larm :inverse-kinematics (send *screw-driver* :work-coords))
(objects (list *screw-driver* (send *screw-driver* :center-coords) (send *screw-driver* :hold-coords) (send *screw-driver* :work-coords) *pr2*))
|#
