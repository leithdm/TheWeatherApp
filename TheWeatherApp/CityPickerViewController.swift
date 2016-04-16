//
//  CityPickerViewController.swift
//  TheWeatherApp
//
//  Created by Darren Leith on 16/04/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import UIKit

protocol CityPickerViewControllerDelegate {
	func cityPicker(cityPicker: CityPickerViewController, didPickCity city: City?)
}

class CityPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	
	var cities = [City]()
	var delegate: CityPickerViewControllerDelegate?
	
	// The most recent data download task. We keep a reference to it so that it can be canceled every time the search text changes
	var searchTask: NSURLSessionDataTask?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(cancel))
		
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		self.searchBar.becomeFirstResponder()
	}
	
	
	@IBAction func cancel(sender: UIBarButtonItem) {
		self.delegate?.cityPicker(self, didPickCity: nil)
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	//MARK: search bar delegate
	
	// Each time the search text changes we want to cancel any current download and start a new one
	func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
		
		// Cancel the last task
		if let task = searchTask {
			task.cancel()
		}
		
		// If the text is empty we are done
		if searchText == "" {
			cities = [City]()
			tableView?.reloadData()
			objc_sync_exit(self)
			return
		}
		
		// Start a new download
		let parameters = ["q" : searchText]
		
		searchTask = APIWeatherOnline.sharedInstance().taskForResource(parameters) { [unowned self] jsonResult, error in
			
			// Handle the error case
			if let error = error {
				print("Error searching for cities: \(error.localizedDescription)")
				return
			}
			
			guard let data = jsonResult["data"] as? NSDictionary else {
				print("Cannot find key 'data' in \(jsonResult)")
				return
			}
			
			guard let request = data["request"] as? [[String:AnyObject]] else {
				print("Cannot find key 'request' in \(data)")
				return
			}
			
			for value in request {
				guard let query = value["query"] as? String else {
					print("Cannot find key 'query' in \(value)")
					return
				}
				
				let city = City(dictionary: ["name": query])
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
	
	
	// MARK: - Table View Delegate and Data Source
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let CellReuseId = "CitySearchCell"
		let city = cities[indexPath.row]
		let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseId)!
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
