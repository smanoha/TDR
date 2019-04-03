(define (f r ez) (- (+ (vector3-x r) ez) (vector3-x r)))
(define-param eps 4.3)
(define-param w 6)
(define-param w1 1)  
(define-param w2 2)                                       
(define-param h 0.5)                                                             
(define-param sx 10)
(define (op1) (print "V1: "(integrate-field-function (list Ez) f (volume (size 0 0 h) (center -3.5 0 (/ h 2)))) "\n"))
(set! geometry-lattice (make lattice (size sx 8 5)))
(set! geometry (append;
(list 
(make block (center 0 0 (/ h 2)) (size infinity w h) (material (make dielectric (epsilon eps))))
(make block (center 0 0 0) (size infinity w 0) (material (make perfect-metal)))
(make block (center 0 0 h) (size 4 w2 0) (material (make perfect-metal)))
(make block (center 0 0 h) (size infinity w1 0) (material (make perfect-metal))))))
(set! resolution 16)
(set! pml-layers (list (make pml (thickness 1.0))))
(set! sources (list
               (make source
                 ;define a gaussian shaped (in time) current density at z=0
                 (src (make continuous-src (frequency 0.01)))
                 (component Ez)
                 (center -4 0 (/ h 2))
                 (size 0 0 h))))
(run-until 1000 (at-beginning output-epsilon) (at-every 0.25 op1))
