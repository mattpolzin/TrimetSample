//
//  TripViewController.swift
//  TrimetSample
//
//  Created by Mathew Polzin on 2/8/17.
//  Copyright © 2017 Mathew Polzin. All rights reserved.
//

import Foundation
import UIKit

class TripViewController : UIViewController {
	
	var routeOptions: [RouteOption]? {
		didSet {
			refreshTripView()
		}
	}
	
	/**
		This gets called when the trip information (i.e. route options) has
		has changed.
	*/
	private func refreshTripView() {
		
	}
	
}
