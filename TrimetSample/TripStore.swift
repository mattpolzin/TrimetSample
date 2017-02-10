//
//  TripStore.swift
//  TrimetSample
//
//  Created by Mathew Polzin on 2/8/17.
//  Copyright © 2017 Mathew Polzin. All rights reserved.
//

import Foundation
import CoreData

/**
	A singleton that manages all previous trip searches.
*/
class TripStore {
	
	static let newTripInsertionNotification = NSNotification.Name("newTripNotification")
	
	let managedContext: NSManagedObjectContext
	
	var storedTrips: [Trip]?
	
	init(_ context: NSManagedObjectContext) {
		managedContext = context
		
		loadStoredTrips()
	}
	
	/**
		Load trips that have been searched before. This is called when the TripStore
		is initialized and there should not be a need to call it again after that.
	*/
	func loadStoredTrips() {
		let tripsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Trip")
		
		do {
			storedTrips = try managedContext.fetch(tripsFetch) as? [Trip]
		} catch {
			print("Failed to fetch trips: \(error)")
		}
	}
	
	/**
		Add a trip to the store with the given start and end locations.
	
		- Parameters:
			- startLocation: The location where the trip will start.
			- endLocation: The location where the trip will end.
	*/
	func addTrip(startLocation loc1: String, endLocation loc2: String) {
		
		//TODO: reuse locations that are the same as previously created locations.
		//TODO: do not insert duplicate trips
		
		let startLocation = Location(context: managedContext)
		let endLocation = Location(context: managedContext)
		
		startLocation.shortName = loc1
		endLocation.shortName = loc2
		
		let newTrip = Trip(context: managedContext)
		newTrip.startLocation = startLocation
		newTrip.endLocation = endLocation
		
		storedTrips?.insert(newTrip, at: 0)
		
		// let anyone who is listening know about the insertion
		let notification = Notification(name: TripStore.newTripInsertionNotification, object: self, userInfo: ["pos": 0])
		NotificationCenter.default.post(notification)
		
		do {
			try managedContext.save()
		} catch {
			print("Failed to save trips: \(error)")
		}
	}
	
//	func clearTrips() {
//		
//	}
}
