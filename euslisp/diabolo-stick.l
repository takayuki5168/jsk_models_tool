(defun make-diabolo-stick
    (&key (pos #f(0 0 0)) (rot #f(0 0 0)))
  (let ((diabolo-stick (instance diabolo-stick :init :pos pos :rot rot)))
    diabolo-stick)
  )

(defun make-diabolo-stick-body ()
  (let ((a (make-cylinder 15 140))
	(b (make-cylinder 5 160 :pos (float-vector 0 0 -150))))
    (send a :set-color :white)
    (send b :set-color :gray)    
    (setq c (body+ a b))
    c))
(defclass diabolo-stick
  :super cascaded-link
  :slots (tool-length hold-length
		      body center-coords hold-coords work-coords))
(defmethod diabolo-stick
  (:init (&key pos rot)
	 (let ()
	   (send-super :init)

	   (setq tool-length (+ 140 160))
	   (setq hold-length 140)

	   (setq body (instance bodyset-link :init (make-cascoords) :bodies (list (make-diabolo-stick-body)) :locate (float-vector 0 0 0)))
	   (setq links (list body))
	   (setq joint-list (list))
	   (send self :assoc body)

	   (setq center-coords (make-cascoords))
	   (send self :assoc center-coords)

	   (setq hold-coords (make-cascoords :pos (float-vector 0 0 (/ tool-length 2))))
	   (send hold-coords :locate (float-vector 0 0 0))
	   (send hold-coords :rotate (/ pi 2) :y)
	   (send self :assoc hold-coords)

	   (setq work-coords (make-cascoords :pos (float-vector 0 0 (/ tool-length -2))))
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
(setq *diabolo-stick* (instance diabolo-stick :init :pos (float-vector 500 0 800) :rot (float-vector -1 0 0)))
(objects (list *diabolo-stick* (send *diabolo-stick* :center-coords) (send *diabolo-stick* :hold-coords) (send *diabolo-stick* :work-coords)))
#|

#|
(setq *diabolo-stick* (make-diabolo-stick))
(objects (list *diabolo-stick* (send *diabolo-stick* :center-coords) (send *diabolo-stick* :hold-coords) (send *diabolo-stick* :work-coords)))
#|
