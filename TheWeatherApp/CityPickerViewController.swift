//
//  CityPickerViewController.swift
//  TheWeatherApp
//
//  Created by Darren Leith on 16/04/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import UIKit
import CoreData

protocol CityPickerViewControllerDelegate {
	func cityPicker(cityPicker: CityPickerViewController, didPickCity city: City?)
}

class CityPickerViewController: UIViewController, UISearchBarDelegate {
	
	//MARK: properties
	
	var cities = [City]()
	var delegate: CityPickerViewControllerDelegate?
	var searchTask: NSURLSessionDataTask? 	// The most recent data download task
	
	//MARK: outlets
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	
	//MARK: lifecycle methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(cancel))
		
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		self.searchBar.becomeFirstResponder()
	}

	lazy var sharedContext: NSManagedObjectContext = {
		return CoreDataStackManager.sharedInstance.managedObjectContext
	}()
	
	
	//MARK: search bar delegate
	
	// Each time the search text changes we want to cancel any current download and start a new one
	func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
		
		//cancel the last task
		if let task = searchTask {
			task.cancel()
		}
		
		//if the text is empty then we are done
		if searchText == "" {
			cities = [City]()
			tableView?.reloadData()
			objc_sync_exit(self)
			return
		}
		
		//start a new download
		let parameters = [JSONParameters.QueryParameter : searchText]
		
		searchTask = APIWeatherOnline.sharedInstance().taskForResource(parameters) { [unowned self] jsonResult, error in
			
			//handle the error case
			guard error == nil else {
				print("Error searching for cities: \(error!.localizedDescription)")
				return
			}
			
			guard let data = jsonResult[JSONParameters.Data] as? NSDictionary else {
				print("Cannot find key 'data' in \(jsonResult)")
				return
			}
			
			guard let request = data[JSONParameters.Request] as? [[String:AnyObject]] else {
				print("Cannot find key 'request' in \(data)")
				return
			}
			
			for value in request {
				guard let query = value[JSONParameters.Query] as? String else {
					print("Cannot find key 'query' in \(value)")
					return
				}
				
				let city = City(dictionary: ["name": query], context: self.sharedContext)
				self.cities.insert(city, atIndex: 0)
				
				dispatch_async(dispatch_get_main_queue()) {
					self.tableView!.reloadData()
				}
			}
		}
	}
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
	
	//MARK: click cancel button
	
	@IBAction func cancel(sender: UIBarButtonItem) {
		self.delegate?.cityPicker(self, didPickCity: nil)
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
}

// MARK: - Table View Delegate and Data Source

extension CityPickerViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let city = cities[indexPath.row]
		let cell = tableView.dequeueReusableCellWithIdentifier(Constants.ReusableTableViewCell)!
		cell.textLabel!.text = city.name
		return cell
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cities.count
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let city = cities[indexPath.row]
		// Alert the delegate
		delegate?.cityPicker(self, didPickCity: city)
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
}