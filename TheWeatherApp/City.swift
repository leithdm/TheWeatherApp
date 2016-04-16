//
//  City.swift
//  TheWeatherApp
//
//  Created by Darren Leith on 16/04/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import Foundation

class City: NSObject {
	
	struct Keys {
		static let Name = "name"
	}
	
	var name: String
	
	init(dictionary: [String : AnyObject]) {
		name = dictionary[Keys.Name] as! String
	}
	
}


