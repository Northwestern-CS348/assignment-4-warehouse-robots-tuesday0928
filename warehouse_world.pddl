(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (started ?s) (not (complete ?s)) (ships ?s ?o) (packing-location ?l) (not (available ?l)) (packing-at ?s ?l))
      :effect (and (complete ?s) (not (started ?s)) (available ?l) (not (packing-at ?s ?l)))
   )
   
   (:action robotMove
      :parameters (?l1 - location ?l2 - location ?r - robot)
      :precondition (and (connected ?l1 ?l2) (no-robot ?l2) (at ?r ?l1))
      :effect (and (not (no-robot ?l2)) (at ?r ?l2) (not (at ?r ?l1)) (no-robot ?l1))
   )
   
   (:action robotMoveWithPallette
      :parameters (?l1 - location ?l2 - location ?r - robot ?p - pallette)
      :precondition (and (connected ?l1 ?l2) (at ?r ?l1) (at ?p ?l1) (no-robot ?l2) (no-pallette ?l2))
      :effect (and (no-robot ?l1) (not (no-robot ?l2)) (no-pallette ?l1) (not (no-pallette ?l2)) (not (at ?r ?l1)) (not (at ?p ?l1)) (at ?r ?l2) (at ?p ?l2) (has ?r ?p) (not (free ?r))) 
   )
   
   (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
      :precondition (and (contains ?p ?si) (orders ?o ?si) (ships ?s ?o) (at ?p ?l) (packing-location ?l) (available ?l))
      :effect (and (not (contains ?p ?si)) (includes ?s ?si))
   )
)
