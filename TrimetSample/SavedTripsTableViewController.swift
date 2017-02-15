//
//  SavedTripsTableViewController.swift
//  TrimetSample
//
//  Created by Mathew Polzin on 2/8/17.
//  Copyright © 2017 Mathew Polzin. All rights reserved.
//

import Foundation
import UIKit

protocol SavedTripsTableViewControllerDelegate {
	
	/**
		The user has selected a row in the table view with the given start/end
		locations.
	
		- Parameters:
			- startLocation: Location where the search begins.
			- endLocation: Location where the search ends.
	*/
	func tripSelected(startLocation: String, endLocation: String)
}

/**
	A table view that shows the user's previous trip searches.
*/
class SavedTripsTableViewController : UITableViewController {
	
	static let tableViewCellId = "tripCell"
	
	private var tripStore: TripStore?
	
	var delegate: SavedTripsTableViewControllerDelegate?
	
	override func viewDidLoad() {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		tripStore = appDelegate.tripStore
		
		// add notification observer for TripStore insertions
		NotificationCenter.default.addObserver(forName: TripStore.newTripInsertionNotification, object: tripStore, queue: OperationQueue.main, using: newTripInserted)
	}
	
	deinit {
		// clear notification observations
		NotificationCenter.default.removeObserver(self)
	}
	
	//
	// MARK: UITableViewDelegate
	//
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let trip = tripStore?.storedTrips?[indexPath[1]] {
			delegate?.tripSelected(startLocation: (trip.startLocation?.shortName ?? ""), endLocation: (trip.endLocation?.shortName ?? ""))
		}
	}
	
	//
	// MARK: UITableViewDatasource
	//
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tripStore?.storedTrips?.count ?? 0
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: TripTableViewCell?
		
		// grab or create cell
		if let tmpCell = tableView.dequeueReusableCell(withIdentifier: SavedTripsTableViewController.tableViewCellId) as? TripTableViewCell {
			cell = tmpCell
		} else {
			cell = TripTableViewCell(style: .default, reuseIdentifier: SavedTripsTableViewController.tableViewCellId)
		}
		
		// get trip object
		let trip = tripStore?.storedTrips?[indexPath[1]] as Trip?
		
		// udpate cell text
		cell?.fromLocationName.text = trip?.startLocation?.shortName
		cell?.toLocationName.text = trip?.endLocation?.shortName
		
		return cell!
	}
	
	//
	// MARK: TripStore observer
	//
	
	func newTripInserted(notification: Notification) {
		tableView.insertRows(at: [IndexPath(indexes: [0,0])], with: .top)
	}
	
}
