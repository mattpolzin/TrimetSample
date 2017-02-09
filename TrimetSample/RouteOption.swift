//
//  RouteOption.swift
//  TrimetSample
//
//  Created by Mathew Polzin on 2/8/17.
//  Copyright © 2017 Mathew Polzin. All rights reserved.
//

import Foundation
import SWXMLHash

struct RouteOption: XMLIndexerDeserializable {
	
	// Cost of the route in dollars
	let cost: Float
	
	// duration of the route in full minutes
	let duration: Int
	
	init(cost newCost: Float?, duration newDuration: Int?) {
		cost = newCost ?? 0
		duration = newDuration ?? 0
	}
	
	/**
		Create a new route option object by parsing an "itinerary" result from
		TriMet.
	
		- Parameter xml: A valid TriMet route result that has been parsed.
	*/
	static func deserialize(_ xml: XMLIndexer) throws -> RouteOption {
		return try RouteOption(cost: xml["fare"]["regular"].value(),
		                       duration: xml["time-distance"]["duration"].value())
	}
}
