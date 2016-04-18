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
	
	struct Keys {
		static let Name = "name"
	}
	
	@NSManaged var name: String
	@NSManaged var forecast: [Day]

	override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
		super.init(entity: entity, insertIntoManagedObjectContext: context)
	}
	
	init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
	let entity = NSEntityDescription.entityForName("City", inManagedObjectContext: context)!
	super.init(entity: entity, insertIntoManagedObjectContext: context)

	name = dictionary[Keys.Name] as! String
	}
}


