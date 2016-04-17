//
//  CityWeatherViewController.swift
//  TheWeatherApp
//
//  Created by Darren Leith on 16/04/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import UIKit

class CityWeatherViewController: UIViewController {
	
	//MARK: properties
	
	var city: City!
	
	//MARK:	outlets
	
	@IBOutlet weak var cityName: UILabel!
	@IBOutlet weak var weatherDescription: UILabel!
	@IBOutlet weak var mainTempValue: UILabel!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var tableView: UITableView!
	
	
	// MARK: life cycle methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		layoutCollectionView()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		cityName.text = city.name
		city.forecast.removeAll()
		
		let parameters = [JSONParameters.QueryParameter: city.name]
		
		//MARK: start search for weather
		
		APIWeatherOnline.sharedInstance().taskForResource(parameters) { [unowned self] jsonResult, error in
			
			
			guard error == nil else {
				print("Error searching for cities: \(error!.localizedDescription)")
				return
			}
			
			guard let data = jsonResult[JSONParameters.Data] as? NSDictionary else {
				print("Cannot find key 'data' in \(jsonResult)")
				return
			}
			
			guard let currentCondition = data[JSONParameters.CurrentCondition] as? [[String:AnyObject]] else {
				print("Cannot find key 'current_condition' in \(data)")
				return
			}
			
			//MARK: get the temperature and short description for today and display on the main HUD
			
			for current in currentCondition {
				
				guard let temp_C = current[JSONParameters.TempC] as? String else {
					print("Cannot find key 'temp_C' in \(currentCondition)")
					return
				}
				
				self.performUIUpdatesOnMain({
					self.mainTempValue.text = "\(temp_C)º"
				})
				
				//todays short weather description
				guard let weatherDesc = current[JSONParameters.WeatherDesc] as? [[String:AnyObject]] else {
					print("Cannot find key 'weatherDesc' in \(currentCondition)")
					return
				}
				
				for description in weatherDesc {
					guard let weatherDescValue = description[JSONParameters.WeatherDescValue] as? String else {
						print("Cannot find key 'weatherDesc' in \(weatherDesc)")
						return
				 }
					self.performUIUpdatesOnMain({
						self.weatherDescription.text = weatherDescValue
					})
				}
				
				
				//MARK: get the date, minTemp and maxTemp for each day requested in the forecast
				
				guard let weather = data[JSONParameters.Weather] as? [[String: AnyObject]] else {
					print("Cannot find key 'weather' in \(data)")
					return
				}
				
				
				for eachDay in weather {
					
					let day = Day()
					
					guard let date = eachDay[JSONParameters.Date] as? String else {
						print("Cannot find key 'date' in \(weather)")
						return
					}
					
					guard let maxTempC = eachDay[JSONParameters.MaxTempC] as? String else {
						print("Cannot find key 'maxTempC' in \(weather)")
						return
					}
					
					guard let minTempC = eachDay[JSONParameters.MinTempC] as? String else {
						print("Cannot find key 'minTempC' in \(weather)")
						return
					}
					
					//MARK: get the temperature for each day in 3-hourly intervals
					
					guard let hourly = eachDay[JSONParameters.Hourly] as? [[String: AnyObject]] else {
						print("Cannot find key 'hourly' in \(weather)")
						return
					}
					
					for hour in hourly {
						guard let tempC = hour[JSONParameters.HourlyTempC] as? String else {
							print("Cannot find key 'tempC' in \(hourly)")
							return
						}
						day.maxTemp_hours.append(tempC)
						
						
						//MARK: get the weather icon for each of the 3-hourly intervals
						
						guard let weatherIconURL = hour[JSONParameters.WeatherIconURL] as? [[String: AnyObject]] else {
							print("Cannot find key 'weatherIconUrl' in \(hourly)")
							return
						}
						
						for icon in weatherIconURL {
							guard let value = icon[JSONParameters.Value] as? String else {
								print("Cannot find key 'value' in \(hourly)")
								return
							}
							day.weatherIconUrl.append(value)
						}
						
					}
					
					//save
					day.date = date
					day.maxTempC = maxTempC
					day.minTempC = minTempC
					self.city.forecast.append(day)
					
					print(day.weatherIconUrl)
					
					//update the main view
					self.performUIUpdatesOnMain({
						self.collectionView.reloadData()
						self.tableView.reloadData()
					})
				}
			}
		}
	}
	
	
	// MARK: helper methods
	
	func performUIUpdatesOnMain(updates: () -> Void) {
		dispatch_async(dispatch_get_main_queue()) {
			updates()
		}
	}
	
	
	func getIntegerDayOfWeek(today:String)->Int {
		let formatter  = NSDateFormatter()
		formatter.dateFormat = Constants.DateFormatter
		let todayDate = formatter.dateFromString(today)!
		let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
		let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
		let weekDay = myComponents.weekday
		return weekDay
	}
	
	
	func getStringDayOfWeek(day: Int) -> String {
		var computedDayOfWeek = ""
		switch day {
		case 1:
			computedDayOfWeek = DaysOfTheWeek.Sunday
		case 2:
			computedDayOfWeek = DaysOfTheWeek.Monday
		case 3:
			computedDayOfWeek = DaysOfTheWeek.Tuesday
		case 4:
			computedDayOfWeek = DaysOfTheWeek.Wednesday
		case 5:
			computedDayOfWeek = DaysOfTheWeek.Thursday
		case 6:
			computedDayOfWeek = DaysOfTheWeek.Friday
		case 7:
			computedDayOfWeek = DaysOfTheWeek.Saturday
		default:
			break
		}
		return computedDayOfWeek
	}
	
	
	func layoutCollectionView() {
		// Lay out the collection view so that cells take up 1/4 of the width of the frame
		let width = CGRectGetWidth(view.frame) / Constants.FrameDivisor
		let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
		layout.itemSize = CGSize(width: width, height: width) //want them to be square
	}
	
	func alertViewForError(error: NSError) {
		//
	}
}


//MARK: collection view extension

extension CityWeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return APIWeatherOnline.Constants.NumberOfTimeSegments
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.ReusableCollectionViewCell, forIndexPath: indexPath) as! TodaysForecastCell
		
		if let day = city.forecast.first {
			let maxTempHours = day.maxTemp_hours
			cell.temperature.text = "\(maxTempHours[indexPath.row])º"
			cell.hour.text = day.times[indexPath.row]
			
			if let url = NSURL(string: day.weatherIconUrl[indexPath.row]) {
				let imageData = NSData(contentsOfURL: url)
				cell.imageForecast.image = UIImage(data: imageData!)
			}
			
		}
		return cell
	}

}

//MARK: table view extension

extension CityWeatherViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
	
		let day = city.forecast[indexPath.row]
		let cell = tableView.dequeueReusableCellWithIdentifier(Constants.ReusableTableViewCell, forIndexPath: indexPath)
		
		let dayOfWeek = cell.viewWithTag(1001) as! UILabel
//		let weatherImage = cell.viewWithTag(1002) as! UIImageView
		let maxTemp = cell.viewWithTag(1003) as! UILabel
		let minTemp = cell.viewWithTag(1004) as! UILabel
	
		
		let weekday = getIntegerDayOfWeek(day.date!)
		dayOfWeek.text = getStringDayOfWeek(weekday)
		maxTemp.text = day.maxTempC
		minTemp.text = day.minTempC
		
		return cell
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return city.forecast.count
	}
}