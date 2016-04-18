//
//  APIWeatherOnline.swift
//  TheWeatherApp
//
//  Created by Darren Leith on 18/04/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import XCTest
@testable import TheWeatherApp

class APIWeatherOnlineTests: XCTestCase {
	
	let client = APIWeatherOnline.sharedInstance
	
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
	
	func testCreateURLFromParameters() {
		let searchText = "Dublin"
		let parameters = [CityPickerViewController.JSONParameters.QueryParameter : searchText]
		let url = client.createURLFromParameters(parameters)
		let expected = NSURL(string: "http://api.worldweatheronline.com/premium/v1/weather.ashx?num_of_days=7&q=Dublin&format=json&key=a98286da12ba492ea0490658161604")
		
		//Test 1:
		XCTAssertNotNil(url)
		//Test 2
		XCTAssertEqual(url, expected)
	}
}