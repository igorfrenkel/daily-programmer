(ns ray-casting.core-test
  (:require [clojure.test :refer :all]
            [ray-casting.core :refer :all]))

(deftest test-intersect
  (testing "whether point is directly on obstacle"
    (is (= true (point-on-obstacle? [0 0])))
    (is (= true (point-on-obstacle? [0 1])))
    (is (= true (point-on-obstacle? [0 2])))
    (is (= false (point-on-obstacle? [0 3])))
  )
  (testing "whether point is in or near an obstacle"
		(dosync (ref-set obstacles '((0 0) (1 1) (9 5))))
    (is (= true (point-on-obstacle? [0.5 0])))
    (is (= true (point-on-obstacle? [1 1])))
    (is (= false (point-on-obstacle? [0 2])))
    (is (= false (point-on-obstacle? [0 3])))
		(is (= true (point-on-obstacle? '(9.554 5.584))))
  )
)

(deftest test-transpose
	(testing "transpose-point"
		(is (= [6.507 6.599] (plot-point [6.5 6.5] 1.5)))
		(is (= [6.514 6.698] (plot-point [6.507 6.599] 1.5)))
		(is (= [6.576 6.527] (plot-point [6.507 6.599] -0.8)))
	)
)

(deftest test-out-of-bounds
	(testing "checking when point is out of bounds"
		(is (= false (out-of-bounds? '(6.5 6.5))))
		(is (= false (out-of-bounds? '(0 0))))
		(is (= false (out-of-bounds? '(0 0))))
		(is (= false (out-of-bounds? '(10 10))))
		(is (= false (out-of-bounds? '(10 10))))
		(is (= true (out-of-bounds? '(6.5 10.1))))
		(is (= true (out-of-bounds? '(10.1 6.5))))
		(is (= true (out-of-bounds? '(-1 6.5))))
	)
)

(deftest test-cast-ray
	(testing "ray casting functionality without an obstacle stops at walls of the world"
		(dosync (ref-set obstacles '((0 0) (0 1) (0 2))))
		(is (out-of-bounds? (last (cast-ray [[6.5 6.5]] 1.5))))
		(is (out-of-bounds? (last (cast-ray [[9.5 1.5]] 1))))
		(is (= 
					'((9.5 1.5) (9.554 1.584) (9.608 1.668) (9.662 1.752) (9.716 1.836) (9.77 1.92) (9.824 2.004) (9.878 2.088) (9.932 2.172) (9.986 2.256) (10.04 2.34))
					(cast-ray [[9.5 1.5]] 1)))
		(is (= 
					'([8.1 5] (8.198 5.019) (8.296 5.038) (8.394 5.057) (8.492 5.076) (8.59 5.095) (8.688 5.114) (8.786 5.133) (8.884 5.152) (8.982 5.171) (9.08 5.19) (9.178 5.209) (9.276 5.228) (9.374 5.247) (9.472 5.266) (9.57 5.285) (9.668 5.304) (9.766 5.323) (9.864 5.342) (9.962 5.361) (10.06 5.38))
					(cast-ray [[8.1 5]] 0.2)))
	)

	(testing "collision with obstacle"
		(dosync (ref-set obstacles '((9.554 1.584))))
		(is (= true (point-on-obstacle? [9.554 1.584])))
		(is (= [9.554 1.584] (last (cast-ray [[9.5 1.5]] 1))))
	)

	(testing "collision approximately around obstacle"
		(dosync (ref-set obstacles '((9 5))))
		(is (= true (point-on-obstacle? '(9.08 5.19))))
		(is (= [9.08 5.19] (last (cast-ray [[8.1 5]] 0.2))))
	)
)