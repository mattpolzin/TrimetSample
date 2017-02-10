//
//  SearchView.swift
//  TrimetSample
//
//  Created by Mathew Polzin on 2/8/17.
//  Copyright © 2017 Mathew Polzin. All rights reserved.
//

import Foundation
import UIKit

protocol SearchViewControllerDelegate {
	
	/**
		The text in the filter text view has changed and the results in the
		table view should be updated.
	
		- Parameter text: The new text of the filter text view.
	*/
	func filterTextChanged(_ text: String)
	
	/**
		The user has searched for a route.

		- Parameters:
			- startLocation: The location where the trip will begin.
			- endLocation: The location where the trip will end.
	*/
	func search(startLocation: String, endLocation: String)
	
	/**
		The search view needs more or less space. It also might be preferable to
		"lightbox" the search view to give it extra emphasis when it needs more
		space.

		- Parameter height: The height requested for the search view. This will
							be based on how much content needs to  be shown in
							the search view.
	*/
	func requestNewHeight(_ height: Int)
}

/**
	Control the view the user can interact with on the root page of the app to
	filter past trip searches or create a new trip from start and end destinations.
*/
class SearchViewController : UIViewController {
	
	var delegate: SearchViewControllerDelegate?
	
	// Text field used for the start location of a new route AND for filtering
	// existing saved trips, depending on the mode of the search view.
	@IBOutlet weak var startLocation: UITextField!
	
	// Text field used for the end location of a new route.
	@IBOutlet weak var endLocation: UITextField!
	
	// Button that swaps the start and end locations.
	@IBOutlet weak var swapButton: UIButton!
	
	// Button that initiates a new trip search
	@IBOutlet weak var searchButton: UIButton!
	
	// Button that switches from filtering existing trips to adding a new trip.
	@IBOutlet weak var addButton: UIButton!
	
	// We use this height constraint to calculate the total requested height for
	// this search view. When we show the end location field, we will request
	// twice the height.
	let viewHeight: Int = 44
	
	// If true, the view is currently filtering the list of existing saved trips.
	// If false, the view is currently accepting a start and end location for a
	// new trip.
	private var isFiltering: Bool = true
	
	override func viewDidLoad() {
		// we want to initially be in filter mode
		shrinkForFiltering()
	}
	
	// swap the start and end locations
	@IBAction func swapButtonPressed(_ sender: Any) {
		if let tmpText = startLocation.text {
			
			startLocation.text = endLocation.text
			endLocation.text = tmpText
		}
	}
	
	// expand so the user can add a new trip
	@IBAction func addButtonPressed(_ sender: Any) {
		expandForNewTrip()
	}
	
	// search for routes
	@IBAction func searchButtonPressed(_ sender: Any) {
		shrinkForFiltering()
		
		//TODO: check that start and end location are non-empty.
		
		// tell the delegate to perform a search
		delegate?.search(startLocation: startLocation.text!, endLocation: endLocation.text!)
	}
	
	@IBAction func startLocationChanged(_ sender: Any) {
		// if we are filtering, the start location is actually filter text
		if isFiltering {
			delegate?.filterTextChanged(startLocation.text!)
		}
	}
	
	/**
		Allow the user to input a start and end location and search for routes
		to take between them.
	*/
	func expandForNewTrip() {
		isFiltering = false
		
		endLocation.isHidden = false
		swapButton.isHidden = false
		searchButton.isHidden = false
		addButton.isHidden = true
		
		delegate?.requestNewHeight(viewHeight*2)
	}
	
	/**
		Hide the end location box and allow the user to filter existing saved
		trips.
	*/
	func shrinkForFiltering() {
		isFiltering = true
		
		endLocation.isHidden = true
		swapButton.isHidden = true
		searchButton.isHidden = true
		addButton.isHidden = false
		
		delegate?.requestNewHeight(viewHeight)
	}
}
