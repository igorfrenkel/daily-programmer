(ns ray-casting.core
  (:gen-class))

(def obstacles (ref '([0 0] [0 1] [0 2])))

(defn point-on-obstacle? [[target-x target-y]]
	(= true 
		(some 
			(fn [[obstacle-x obstacle-y]] 
				(and 
					(>= target-x obstacle-x) (< target-x (+ obstacle-x 1)) 
					(>= target-y obstacle-y) (< target-y (+ obstacle-y 1)))) 
			@obstacles)))

(defn dumb-format-decimal [n]
	(/ (int (* 1000 n)) 1000.0)
)

(defn plot-point [point angle]
	(map dumb-format-decimal 
		[	(+ (first point) (* (Math/cos angle) 0.1)) 
			(+ (second point) (* (Math/sin angle) 0.1))])
)

(defn out-of-bounds? [point]
	(let [x (first point) y (last point)]
		(not (and (>= x 0) (>= y 0) (<= x 10) (<= y 10)))
	)
)

(defn cast-ray [ray-of-points angle]
	(loop [ray-of-points ray-of-points angle angle]
		(if (or 
					(out-of-bounds? (last ray-of-points)) 
					(point-on-obstacle? (last ray-of-points)))
			ray-of-points
			(recur (conj ray-of-points (plot-point (last ray-of-points) angle)) angle)
		)))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (println "Hello, World!"))
