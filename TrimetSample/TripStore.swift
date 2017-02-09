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
	
	let managedContext: NSManagedObjectContext
	
	init(_ context: NSManagedObjectContext) {
		managedContext = context
	}
	
	
}
