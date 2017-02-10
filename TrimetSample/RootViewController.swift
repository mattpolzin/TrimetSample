//
//  ViewController.swift
//  TrimetSample
//
//  Created by Mathew Polzin on 2/8/17.
//  Copyright © 2017 Mathew Polzin. All rights reserved.
//

import UIKit

/**
	The root view controller shows the user a search view and a list of their
	previous searches. The user can filter the previous searches or add new
	searches.
*/
class RootViewController: UIViewController, SearchViewControllerDelegate {

	weak var searchController: SearchViewController?
	weak var tripsController: SavedTripsTableViewController?
	
	// the height of the search view will get changed depending on whether we
	// need space for two text fields (entering a start and end location) or just
	// one (filtering existing trips).
	@IBOutlet weak var searchHeightConstraint: NSLayoutConstraint!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "SearchEmbedSegue") {
			
			// we are grabbing a reference to the search view controller and
			// becoming its delegate:
			searchController = (segue.destination as! SearchViewController)
			searchController?.delegate = self
			
		} else if (segue.identifier == "SavedTripsEmbedSegue") {
			
			// we are grabbing a reference to the saved trips table view controller:
			tripsController = (segue.destination as! SavedTripsTableViewController)
			
		}
	}
	
	//
	// MARK: SearchViewControllerDelegate
	//
	
	func filterTextChanged(_ text: String) {
		//TODO: filter the table view rows
	}
	
	func search(startLocation: String, endLocation: String) {
		
		// before searching, let's save the trip so it can be searched more easily
		// in the future
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		appDelegate.tripStore?.addTrip(startLocation: startLocation, endLocation: endLocation)
		
		TrimetSearchController.findRoutes(fromStart: startLocation, toEnd: endLocation) {(routeResults: TrimetSearchResults) in
			
			// we could use the defined TripResults segue here, but instead we will
			// grab a reference to the trip view controller and show it manually
			// because we have access to the array of route options here and there
			// is no reason to save that just to pass it to the new view controller
			// in prepare(for segue:, sender:)
			
			if routeResults.success {
				let tripViewController = UIStoryboard(name: "TripResults", bundle: nil).instantiateViewController(withIdentifier: "tripViewController") as! TripViewController
				
				tripViewController.routeOptions = routeResults.routes
				
				print("\(routeResults.routes)")
				
				self.navigationController!.pushViewController(tripViewController, animated: true)
			} else {
				//TODO: show error dialog
				print("There was a problem retrieving results from TriMet! msg: \(routeResults.message)")
			}
		}
	}
	
	// we will let the search view determine its own height based on its content.
	func requestNewHeight(_ height: Int) {
		self.searchHeightConstraint.constant = CGFloat(height)
		UIView.animate(withDuration: 0.2, animations: {()
			self.view.layoutIfNeeded()
		})
	}
}

