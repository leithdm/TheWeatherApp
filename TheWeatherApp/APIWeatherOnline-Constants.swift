//
//  APIWeatherOnline-Constants.swift
//  TheWeatherApp
//
//  Created by Darren Leith on 16/04/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import Foundation

extension APIWeatherOnline {
	
	
	struct Constants {
		static let ApiKey = "a98286da12ba492ea0490658161604"
		static let BaseUrl = "http://api.worldweatheronline.com/premium/v1/weather.ashx"
		static let NumberOfTimeSegments = 8 
	}
	
	struct Keys {
		static let ID = "id"
		static let ErrorStatusMessage = "status_message"
		static let ConfigBaseImageURL = "base_url"
	}
	
	struct JSONKeys {
		static let Key = "key"
		static let Format = "format"
		static let DaysForecast = "num_of_days"
		
	}
	
	struct JSONParameterValues {
		static let JSON = "json"
		static let DaysForecast = "7"
	}

}