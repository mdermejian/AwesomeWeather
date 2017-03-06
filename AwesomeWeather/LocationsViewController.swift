//
//  LocationsViewController.swift
//  AwesomeWeather
//
//  Created by Marc Dermejian on 02/03/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class LocationsViewController: UIViewController {

	// MARK: - stored properties

	private let storageManager = StorageManager()
	private let locationManager = LocationAPIManager()
	private let forecastManager = ForecastManager()
	
	fileprivate let searchController = UISearchController(searchResultsController: nil)

	//List of locations for the table view
	fileprivate var locations: [Location] = [] {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	fileprivate var searchResults = [Location]() {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}

	//MARK: - Computed properties
	
	var searchControllerIsActive: Bool {
		return searchController.isActive && searchController.searchBar.text != ""
	}
	
	
	// MARK: - IBOutlets

	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.tableFooterView = UIView()
		}
	}
	
	// MARK: - Constants
	
	//Keep constants' scope as small as possible
	fileprivate struct Constants {
		static let CellReuseId = "LocationCell"
		
		static let MinSearchCharacters = 2
		
		static let ForecastSegueIdentifier = "ShowForecast"
		
		static let Network_Error_Message_Title = NSLocalizedString("Network_Error_Message_Title", comment: "The title of the network error message")
		static let Network_Error_Message_Body = NSLocalizedString("Network_Error_Message_Body", comment: "The body of the network error message")
		static let OK_Action = NSLocalizedString("OK_Action", comment: "Okay button title")
		static let NoLocations = NSLocalizedString("No_Locations", comment: "No locations available")
	}

	// MARK: - UIViewController lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadLocations()
		
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		definesPresentationContext = true
		tableView.tableHeaderView = searchController.searchBar

	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if let indexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: indexPath, animated: true)
		}
		
	}
	
	// MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
		if let destinationViewController = segue.destination as? ForecastViewController,
			let location = sender as? Location {
			destinationViewController.forecastManager = forecastManager
			destinationViewController.location = location
		}
	}

	// MARK: - Location

	private func loadLocations() {
		locations = storageManager.restoreLocations()
	}
	
	private func save(locations: [Location]) {
		storageManager.save(locations: locations)
	}
	
	fileprivate func delete(locationAtIndexPath indexPath: IndexPath) {
		
		// Delete the row from the data source
		locations.remove(at: indexPath.row)
		
		tableView.beginUpdates()
		tableView.deleteRows(at: [indexPath], with: .automatic)
		tableView.endUpdates()
		

		//update our storage
		save(locations: locations)
	}
	
	fileprivate func insert(location: Location) {
		
		// Delete the row from the data source
		locations.insert(location, at: locations.endIndex)
		
		tableView.beginUpdates()
		tableView.insertRows(at: [IndexPath(row: locations.count-1, section: 0)], with: .automatic)
		tableView.endUpdates()
		
		//update our storage
		save(locations: locations)
	}

	fileprivate func get(locationAtIndexPath indexPath: IndexPath) -> Location {
		if searchControllerIsActive {
			return searchResults[indexPath.row]
		}
		return locations[indexPath.row]
	}

	fileprivate func searchForLocations(named name: String) {
		locationManager.getLocations(named: name) { (success, _locations) in
			
			guard success == true, let _locations = _locations else {
				
				//present alert controller with error message
				let alertController = UIAlertController(title: Constants.Network_Error_Message_Title, message: Constants.Network_Error_Message_Body, preferredStyle: .alert)
				let okAction = UIAlertAction(title: Constants.OK_Action, style: .default)
				alertController.addAction(okAction)
				self.present(alertController, animated: true)
				
				return
			}
			
			self.searchResults = _locations
			
		}
	}
	
	// MARK: - Search Results
	
	fileprivate func resetSearchResults() {
		searchResults.removeAll()
	}

	
}



extension LocationsViewController: UITableViewDelegate, UITableViewDataSource {
	
	// MARK: - Table view data source
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchControllerIsActive {
			return searchResults.count
		}
		return locations.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellReuseId, for: indexPath)
		
		let location = get(locationAtIndexPath: indexPath)
		
		cell.textLabel?.text = "\(location.areaName!), \(location.region!), \(location.country!)"
		return cell
	}
	
	// MARK: Inserting or Deleting Table Rows
	
	// Override to support conditional editing of the table view.
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		if searchControllerIsActive {
			return false
		}
		return true
	}
	
	// Override to support editing the table view.
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			delete(locationAtIndexPath: indexPath)
		}
	}
	
	// MARK: - Table view delegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let location = get(locationAtIndexPath: indexPath)
		
		if searchControllerIsActive {
			searchController.searchBar.text = ""
			resetSearchResults()
			searchController.dismiss(animated: true, completion: { 
				self.insert(location: location)
			})
		}else {
			//TODO: push forecast view controller for selected location
			performSegue(withIdentifier: Constants.ForecastSegueIdentifier, sender: location)
		}
	}

}


// MARK: - UISearchResultsUpdating

extension LocationsViewController: UISearchResultsUpdating {
	
	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text,
		text != "",
		text.characters.count > Constants.MinSearchCharacters else {
			resetSearchResults()
			return
		}
		
		searchForLocations(named: searchController.searchBar.text!)
	}
}



// MARK: - DZNEmptyDataSetSource implementation

extension LocationsViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
	
	func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
		return UIImage(named: Images.EmptyDataSetImageName)
	}
	
	func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
		
		let attributes = [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17)];
		let text = NSAttributedString(string: Constants.NoLocations, attributes: attributes)
		return text
		
	}
	
	func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
		return UIColor.white
	}
	
	func offset(forEmptyDataSet scrollView: UIScrollView!) -> CGPoint {
		return CGPoint.zero
	}
	
	func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
		return 0
	}
	
	func imageTintColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
		return UIColor.lightGray
	}
	
	// MARK: - DZNEmptyDataSetDelegate implementation
	
	func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
		if searchControllerIsActive {
			return false
		}
		return true
	}
	
	func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
		return false
	}
	
}
