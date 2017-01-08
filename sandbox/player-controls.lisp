(in-package :sandbox)

;;;;150 ms delay for sprinting
;;;;player eye height is 1.5, subtract 1/8 for sneaking

;;gravity is (* -0.08 (expt tickscale 2)) 0 0
;;falling friction is 0.98
;;0.6 * 0.91 is walking friction

;;fov::
;;70 is normal
;;110 is quake pro


(defparameter *yaw* nil)
(defparameter *pitch* nil)
(defparameter *xpos* nil)
(defparameter *ypos* nil)
(defparameter *zpos* nil)
(defparameter defaultfov 70)

(setf *xpos* 0
      *ypos* 0
      *zpos* 0
      *yaw* 0
      *pitch* 0)
(defun controls ()
  (when (in:key-p :w)
    (incf *xpos*))
  (when (in:key-p :a)
    (decf *zpos*))
  (when (in:key-p :s)
    (decf *xpos*))
  (when (in:key-p :d)
    (incf *zpos*))
  (when (in:key-p :space)
    (incf *ypos*))
  (when (in:key-p :left-shift)
    (decf *ypos*)))

(defun mouse-looking ()
  (let* ((change (in:delta))
	 (x (* 1.25 1/360 (aref change 0)))
	 (y (* 1.25 1/360 (aref change 1))))
    (setf *yaw*
	  (mod (+ *yaw* x) (* 2 pi)))
    (setf *pitch*
	  (clamp (+ y *pitch*)
		 (* 0.99 (/ pi -2))
		 (* 0.99 (/ pi 2))))))

(defun set-render-cam ()
  (setf (camera-xpos *camera*) *xpos*
	(camera-ypos *camera*) *ypos*
	(camera-zpos *camera*) *zpos*
	(camera-pitch *camera*) *pitch*
	(camera-yaw *camera*) *yaw*))

(defparameter daytime 1.0)
(defparameter ticks/sec nil)
(defparameter tickscale nil)

(defun physinnit ()
  (setf ticks/sec 60.0)
  (setf tickscale (/ 20.0 ticks/sec))
  (setf tick-delay (/ 1000000.0 ticks/sec))

  ;;escape to quit
  (in:p+1 :ESCAPE (lambda () (setq alivep nil)))
  
    ;;e to escape mouse
  (in:p+1 :E (function window:toggle-mouse-capture)))

(defun physics ()
  (if (in:ismousecaptured)
      (controls))
  (set-render-cam))

(defun look-around ()
  (mouse-looking))

(defun block-aabb ()
  (aabbcc::make-aabb
   :minx 0.0
   :miny 0.0
   :minz 0.0
   :maxx 1.0
   :maxy 1.0
   :maxz 1.0))

(defun player-aabb ()
  (aabbcc::make-aabb
   :minx 0.3
   :miny 0.0
   :minz 0.3
   :maxx 0.3
   :maxy 1.62
   :maxz 0.3))


(defparameter block-aabb (block-aabb))
(defparameter player-aabb (player-aabb))

(defun myafunc (px py pz vx vy vz)
  (let ((ourblocks (get-blocks-around-player px py pz)))
    (multiple-value-bind (minimum blocktouches) (blocktocontact ourblocks px py pz vx vy vz)
      (multiple-value-bind (xclamp yclamp zclamp)
	  (aabbcc::collapse-types blocktouches vx vy vz)
	(values minimum xclamp yclamp zclamp)))))

(defun blocktocontact (blocklist px py pz vx vy vz)
  "for a list of blocks, a position, and velocity, 
collect all the nearest collisions with the player"
  (let ((tot-min 1)
	(actual-contacts nil))
    (dolist (ablock blocklist)
      (multiple-value-bind (minimum type)
	  (aabbcc::aabb-collide
	   player-aabb
	   px py pz
	   block-aabb
	   (elt ablock 0)
	   (elt ablock 1)
	   (elt ablock 2)
	   vx vy vz)
	(if (= minimum tot-min)
	    (push type actual-contacts)
	    (if (< minimum tot-min)
		(progn
		  (setq tot-min minimum)
		  (setq actual-contacts (list type)))))))
    (values
     tot-min
     actual-contacts)))

(defun block-touches (blocklist px py pz)
  "return a list of which sides are touching a block"
  (let ((x+ nil)
	(x- nil)
	(y+ nil)
	(y- nil)
	(z+ nil)
	(z- nil))
    (dolist (theplace blocklist)
      (multiple-value-bind (bx sx by sy bz sz) ;;b = big =positive s = small = negative
	  (aabbcc::aabb-contact px py pz
				player-aabb
				(elt theplace 0)
				(elt theplace 1)
				(elt theplace 2)
				block-aabb)
	(if bx (setq x+ t))
	(if sx (setq x- t))
	(if by (setq y+ t))
	(if sy (setq y- t))
	(if bz (setq z+ t))
	(if sz (setq z- t))))
    (values x+ x- y+ y- z+ z-)))

(defun get-blocks-around-player (px py pz)
  "get the blocks around player"
  (let ((places nil))
    (dotimes (x 10)
      (dotimes (y 10)
	(dotimes (z 10)
 	  (let ((blockx (floor (- (+ x px) 4)))
		(blocky (floor (- (+ y py) 4)))
		(blockz (floor (- (+ z pz) 4))))
	    (let ((blockid (world:getblock blockx blocky blockz)))
	      (if (eq t (aref mc-blocks::iscollidable blockid))
		  (push (vector blockx blocky blockz) places)))))))
    places))

;;dirty chunks is a list of modified chunks
;;we do not want anyone to see a raw list!
(defparameter dirtychunks nil)
(defun clean-dirty ()
  (setf dirtychunks (q::make-uniq-q)))
(defun dirty-pop ()
  (q::uniq-pop dirtychunks))
(defun dirty-push (item)
  (q::uniq-push item dirtychunks))
(defun block-dirtify (i j k)
  (dirty-push (world:chop (world:chunkhashfunc i k j))))

(defun setblock-with-update (i j k blockid new-light-value)
  (let ((old-blockid (world:getblock i j k)))
    (if (/= blockid old-blockid)
	(let ((old-light-value (world:getlight i j k)))
	  (when (setf (world:getblock i j k) blockid)
	    (when (< new-light-value old-light-value)  
	      (de-light-node i j k))
	    (setf (world:getlight i j k) new-light-value)
	    (sky-de-light-node i j k)
	    (unless (zerop new-light-value)
	      (light-node i j k))
	    (flet ((check (a b c)
		     (light-node (+ i a) (+ j b) (+ k c))
		     (sky-light-node (+ i a) (+ j b) (+ k c))))
	      (check -1 0 0)
	      (check 1 0 0)
	      (check 0 -1 0)
	      (check 0 1 0)
	      (check 0 0 -1)
	      (check 0 0 1))
	    (block-dirtify i j k))))))
