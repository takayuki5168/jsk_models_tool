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
		      body center-coords
		      loose-hold-coords loose-work-coords
		      tight-hold-coords tight-work-coords
		      tight-flag))
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
(objects (list *screw-driver* (send *screw-driver* :center-coords) (send *screw-driver* :hold-coords) (send *screw-driver* :work-coords)))
|#

;;#|
(setq *screw-driver* (make-screw-driver :pos (float-vector 600 0 800)))
(load "package://pr2eus/pr2-interface.l")
(pr2-init)
(send *pr2* :rarm :inverse-kinematics (send *screw-driver* :hold-coords))
(send *pr2* :larm :inverse-kinematics (send *screw-driver* :work-coords))
(objects (list *screw-driver* (send *screw-driver* :center-coords) (send *screw-driver* :hold-coords) (send *screw-driver* :work-coords) *pr2*))
;;|#
