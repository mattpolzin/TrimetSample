//
//  TripViewController.swift
//  TrimetSample
//
//  Created by Mathew Polzin on 2/8/17.
//  Copyright © 2017 Mathew Polzin. All rights reserved.
//

import Foundation
import UIKit

/**
	A detail view that gives the user info on the trip they are planning.
*/
class TripViewController : UIViewController {
	
	let routeCostPrefix = "$"
	let routeDurationPostfix = "minutes"
	let routesAvailablePostfix = "TriMet routes available"
	
	@IBOutlet weak var routesAvailableText: UILabel!
	
	@IBOutlet weak var routeDurationText: UILabel!
	
	@IBOutlet weak var routeCostText: UILabel!
	
	private var _routeOptions: [RouteOption]?
	var routeOptions: [RouteOption]? {
		set {
			_routeOptions = newValue
			refreshTripView()
		}
		get {
			return _routeOptions
		}
	}
	
	override func viewDidLoad() {
		refreshTripView()
	}
	
	/**
		This gets called when the trip information (i.e. route options) has
		has changed.
	*/
	private func refreshTripView() {
		
		if routeOptions?.count ?? 0 > 0 {
			// sort by shortest duration
			_routeOptions?.sort(by: { (route1 : RouteOption, route2: RouteOption) in
				return route1.duration <= route2.duration
			})
			
			// and update the labels
			routesAvailableText?.text = "\(routeOptions?.count ?? 0) \(routesAvailablePostfix)"
			routeDurationText?.text = "\(routeOptions?[0].duration ?? 0) \(routeDurationPostfix)"
			routeCostText?.text = "\(routeCostPrefix)\(routeOptions?[0].cost ?? 0)"
		}
		
		// let the user know their route was not found.
		routesAvailableText?.text = "No routes were found."
		routeDurationText?.text = ""
		routeCostText?.text = ""
	}
	
}
