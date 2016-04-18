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

class Day: NSManagedObject {
	
	struct HoursInTheDay {
		static let Midnight		= "00:00"
		static let ThreeAM		= "03:00"
		static let SixAM		= "06:00"
		static let NineAM		= "09:00"
		static let Midday		= "12:00"
		static let ThreePM		= "15:00"
		static let SixPM		= "18:00"
		static let NinePM		= "21:00"
	}
	
	@NSManaged var date: String?
	@NSManaged var maxTempC: String?
	@NSManaged var minTempC: String?
	@NSManaged var weatherDescription: String?
	@NSManaged var maxTemp_hours: [String]
	@NSManaged var weatherIconUrl: [String]
	
	var times = [
		HoursInTheDay.Midnight,
		HoursInTheDay.ThreeAM,
		HoursInTheDay.SixAM,
		HoursInTheDay.NineAM,
		HoursInTheDay.Midday,
		HoursInTheDay.ThreePM,
		HoursInTheDay.SixPM,
		HoursInTheDay.NinePM
		]

	override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
		super.init(entity: entity, insertIntoManagedObjectContext: context)
	}

	init(context: NSManagedObjectContext) {
		let entity = NSEntityDescription.entityForName("Day", inManagedObjectContext: context)!
		super.init(entity: entity, insertIntoManagedObjectContext: context)
	}
	
}


