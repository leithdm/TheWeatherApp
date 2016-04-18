//
//  CityWeatherViewControllerTests.swift
//  TheWeatherApp
//
//  Created by Darren Leith on 18/04/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import XCTest
@testable import TheWeatherApp

class CityWeatherViewControllerTests: XCTestCase {
	
	let vc = CityWeatherViewController()
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testGetStringDayOfWeek() {
		let day1 = 1
		let expected1 = "Sunday"
		let result1 = vc.getStringDayOfWeek(day1)
		
		let day2 = 7
		let expected2 = "Saturday"
		let result2 = vc.getStringDayOfWeek(day2)
		
		//Test 1
		XCTAssertEqual(expected1, result1, "an input of 1 should equal a Sunday")
		//Test 2
		XCTAssertEqual(expected2, result2, "an input of 7 should equal a Saturday")
	}
	
	func testGetIntegerDayOfWeek() {
		let date1 = "2016-01-01"
		let expected1 = 6 // 6 equates to a Friday
		let result1 = vc.getIntegerDayOfWeek(date1)
		
		let date2 = "2016-12-31"
		let expected2 = 7 // 7 equates to a Saturday
		let result2 = vc.getIntegerDayOfWeek(date2)
		
		//Test 1
		XCTAssertEqual(expected1, result1, "an input of '2016-01-01' should equal a Friday")
		//Test 1
		XCTAssertEqual(expected2, result2, "an input of '2016-12-31' should equal a Saturday")
	}
	
	
}