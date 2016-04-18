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
		let searchText1 = "Dublin"
		let parameters1 = [CityPickerViewController.JSONParameters.QueryParameter : searchText1]
		let url1 = client.createURLFromParameters(parameters1)
		let expected1 = NSURL(string: "http://api.worldweatheronline.com/premium/v1/weather.ashx?num_of_days=7&q=Dublin&format=json&key=a98286da12ba492ea0490658161604")
		
		//Test 1:
		XCTAssertNotNil(url1)
		//Test 2
		XCTAssertEqual(url1, expected1)
		
		
		let searchText2 = "Grosseto"
		let parameters2 = [CityPickerViewController.JSONParameters.QueryParameter : searchText2]
		let url2 = client.createURLFromParameters(parameters2)
		let expected2 = NSURL(string: "http://api.worldweatheronline.com/premium/v1/weather.ashx?num_of_days=7&q=Grosseto&format=json&key=a98286da12ba492ea0490658161604")
		
		//Test 3:
		XCTAssertNotNil(url2)
		//Test 4
		XCTAssertEqual(url2, expected2)
	}
	
	
	//MARK: test asynchronous call to WorldWeatherOnline API
	
	func testTaskForResource() {
		let expectation1 = expectationWithDescription("expect data to be returned from asynchronous call to worldweatheronlineAPI")
		let searchText1 = "Dublin"
		let parameters1 = [CityPickerViewController.JSONParameters.QueryParameter : searchText1]
		client.taskForResource(parameters1) { (result, error) in
			if result == nil || error != nil {
				XCTFail()
			} else {
				expectation1.fulfill()
			}
		}
		waitForExpectationsWithTimeout(3, handler: nil)
		
		
		let expectation2 = expectationWithDescription("expect data to be returned from asynchronous call to worldweatheronlineAPI")
		let searchText2 = "Grosseto"
		let parameters2 = [CityPickerViewController.JSONParameters.QueryParameter : searchText2]
		client.taskForResource(parameters2) { (result, error) in
			if result == nil || error != nil {
				XCTFail()
			} else {
				expectation2.fulfill()
			}
		}
		waitForExpectationsWithTimeout(3, handler: nil)
	}
}