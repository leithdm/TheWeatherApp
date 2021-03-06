//
//  APIWeatherOnline-Constants.swift
//  TheWeatherApp
//
//  Created by Darren Leith on 16/04/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import Foundation
import UIKit

extension CityWeatherViewController {
	
	struct Constants {
		static let FrameDivisor: CGFloat		= 4.0
		static let ReusableCollectionViewCell	= "TodaysForecastCell"
		static let ReusableTableViewCell		= "TableViewCell"
		static let DateFormatter				= "yyyy-MM-dd"
		static let AlertTitleConnection			= "Error"
		static let AlertMessageConnection		= "Error connecting to the server"
		static let AlertActionTitle				= "Ok"
	}
	
	struct JSONParameters {
		static let Data				= "data"
		static let CurrentCondition = "current_condition"
		static let TempC			= "temp_C"
		static let WeatherDesc		= "weatherDesc"
		static let WeatherDescValue = "value"
		static let Weather			= "weather"
		static let Date				= "date"
		static let MaxTempC			= "maxtempC"
		static let MinTempC			= "mintempC"
		static let Hourly			= "hourly"
		static let HourlyTempC		= "tempC"
		static let WeatherIconURL	= "weatherIconUrl"
		static let Value			= "value"
		static let QueryParameter	= "q"
	}
	
	struct DaysOfTheWeek {
		static let Monday		= "Monday"
		static let Tuesday		= "Tuesday"
		static let Wednesday	= "Wednesday"
		static let Thursday		= "Thursday"
		static let Friday		= "Friday"
		static let Saturday		= "Saturday"
		static let Sunday		= "Sunday"
	}
	
	struct Errors {
		static let ErrorStatusMessage = "status_message"
		static let ConfigBaseImageURL = "base_url"
	}
}