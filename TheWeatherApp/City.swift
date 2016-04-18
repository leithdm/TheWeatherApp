//
//  City.swift
//  TheWeatherApp
//
//  Created by Darren Leith on 16/04/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class City: NSManagedObject {
	
	struct Constants {
		static let Name			= "name"
		static let CityEntity	= "City"
	}
	
	@NSManaged var name: String
	var forecast = [Day]()
	
	override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
		super.init(entity: entity, insertIntoManagedObjectContext: context)
	}
	
	init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
		let entity = NSEntityDescription.entityForName(Constants.CityEntity, inManagedObjectContext: context)!
		super.init(entity: entity, insertIntoManagedObjectContext: context)
		name = dictionary[Constants.Name] as! String
	}
}


