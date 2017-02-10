//
//  SavedTripsTableViewController.swift
//  TrimetSample
//
//  Created by Mathew Polzin on 2/8/17.
//  Copyright © 2017 Mathew Polzin. All rights reserved.
//

import Foundation
import UIKit

/**
	A table view that shows the user's previous trip searches.
*/
class SavedTripsTableViewController : UITableViewController {
	
	static let tableViewCellId = "savedTripsTableViewCell"
	
	var tripStore: TripStore?
	
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
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell?
		
		if let tmpCell = tableView.dequeueReusableCell(withIdentifier: SavedTripsTableViewController.tableViewCellId) {
			cell = tmpCell
		} else {
			cell = UITableViewCell(style: .default, reuseIdentifier: SavedTripsTableViewController.tableViewCellId)
		}
		
		let trip = tripStore?.storedTrips?[indexPath[1]] as Trip?
		
		cell?.textLabel?.text = "\(trip?.startLocation?.shortName ?? "")     ->     \(trip?.endLocation?.shortName ?? "")"
		
		return cell!
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
	
	//
	// MARK: TripStore observer
	//
	
	func newTripInserted(notification: Notification) {
		tableView.insertRows(at: [IndexPath(indexes: [0,0])], with: .top)
	}
	
}
