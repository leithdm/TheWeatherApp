//
//  CityListViewController.swift
//  TheWeatherApp
//
//  Created by Darren Leith on 16/04/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import UIKit
import CoreData

class CityListViewController: UITableViewController {
	
	//MARK: properties
	
	var cities = [City]()
	
	
	//MARK: lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.navigationItem.leftBarButtonItem = self.editButtonItem()
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(addCity))
		
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()

		cities = fetchAllCities()
	}

	//MARK: core data

	lazy var sharedContext: NSManagedObjectContext = {
		return CoreDataStackManager.sharedInstance.managedObjectContext
	}()

	func fetchAllCities() -> [City] {
		let fetchRequest = NSFetchRequest(entityName: "City")
		do {
		 return try sharedContext.executeFetchRequest(fetchRequest) as! [City]
		} catch {
			return [City]()
		}
	}

	
	//MARK: table view
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cities.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let city = cities[indexPath.row]
		let cell = tableView.dequeueReusableCellWithIdentifier(Constants.ReusableTableViewCell)! as UITableViewCell
		
		cell.textLabel!.text = city.name
		cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
		
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let controller = storyboard!.instantiateViewControllerWithIdentifier(Constants.CityWeatherViewController) as! CityWeatherViewController
		
		controller.city = cities[indexPath.row]
		
		self.navigationController!.pushViewController(controller, animated: true)
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		
		switch (editingStyle) {
		case .Delete:
			let _ = cities[indexPath.row]
			
			// Remove the city from the array
			cities.removeAtIndex(indexPath.row)
			
			// Remove the row from the table
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)

		default:
			break
		}
	}
	
//	//MARK: saving the array
//	
//	var cityArrayURL: NSURL {
//		let filename = "CityListArray"
//		let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
//		
//		return documentsDirectoryURL.URLByAppendingPathComponent(filename)
//	}
	
	//MARK: add a new city
	
	func addCity() {
		let controller = self.storyboard!.instantiateViewControllerWithIdentifier(Constants.CityPickerViewController) as! CityPickerViewController
		controller.delegate = self
		self.presentViewController(controller, animated: true, completion: nil)
	}
}

//MARK: city picker delegate

extension CityListViewController: CityPickerViewControllerDelegate {

	func cityPicker(cityPicker: CityPickerViewController, didPickCity city: City?) {
		if let newCity = city {
			
			// Check to see if we already have this city. If so, return.
			for c in cities {
				if c.name == newCity.name {
					return
				}
			}
			
			let dictionary: [String : AnyObject] = [
				City.Keys.Name : newCity.name
			]
			
			let cityToBeAdded = City(dictionary: dictionary, context: sharedContext)
			self.cities.append(cityToBeAdded)
			CoreDataStackManager.sharedInstance.saveContext()
		}
	}
}
