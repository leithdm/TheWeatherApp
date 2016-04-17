//
//  City.swift
//  TheWeatherApp
//
//  Created by Darren Leith on 16/04/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import Foundation

class Day: NSObject {
	
	struct Keys {
		static let Date = "date"
		static let MaxTempC = "maxTempC"
		static let MinTempC = "minTempC"
		static let MaxTemp_hours = "maxTemp_hours"
	}
	
	var date: String?
	var maxTempC: String?
	var minTempC: String?
	var maxTemp_hours = [String]()
	var weatherIconUrl: [String]?
	var times = ["00", "03", "06", "09", "12", "15", "18", "21"]
	
}


