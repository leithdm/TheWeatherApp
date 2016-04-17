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
		
		// MARK: - URLs
		static let ApiKey = "568945f33045470e8f3202100161604"
		static let BaseUrl = "http://api.worldweatheronline.com/premium/v1/weather.ashx"
	}
	
	struct Keys {
		static let ID = "id"
		static let ErrorStatusMessage = "status_message"
		static let ConfigBaseImageURL = "base_url"
	}
	
}