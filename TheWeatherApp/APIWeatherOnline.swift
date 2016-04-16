//
//  APIWeatherOnline.swift
//  TheWeatherApp
//
//  Created by Darren Leith on 16/04/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import Foundation

class APIWeatherOnline: NSObject {
	
	typealias CompletionHander = (result: AnyObject!, error: NSError?) -> Void
	var session: NSURLSession
	
	override init() {
		session = NSURLSession.sharedSession()
		super.init()
	}
	
	// MARK: - All purpose task method for data
	
	func taskForResource(parameters: [String : AnyObject], completionHandler: CompletionHander) -> NSURLSessionDataTask {
		
		var mutableParameters = parameters
		
		// Add in the API Key

		mutableParameters["format"] = "json"
		mutableParameters["num_of_days"] = "5"
		mutableParameters["key"] = Constants.ApiKey
		
		let urlString = Constants.BaseUrl + APIWeatherOnline.escapedParameters(mutableParameters)
		let url = NSURL(string: urlString)!
		let request = NSURLRequest(URL: url)
		
		print(url)
		
		let task = session.dataTaskWithRequest(request) {data, response, downloadError in
			
			if let error = downloadError {
				let newError = APIWeatherOnline.errorForData(data, response: response, error: error)
				completionHandler(result: nil, error: newError)
			} else {
				print("Step 3 - taskForResource's completionHandler is invoked.")
				APIWeatherOnline.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
			}
		}
		
		task.resume()
		return task
	}
	
	// Parsing the JSON
	
	class func parseJSONWithCompletionHandler(data: NSData, completionHandler: CompletionHander) {
		var parsingError: NSError? = nil
		
		let parsedResult: AnyObject?
		do {
			parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
		} catch let error as NSError {
			parsingError = error
			parsedResult = nil
		}
		
		if let error = parsingError {
			completionHandler(result: nil, error: error)
		} else {
			print("Step 4 - parseJSONWithCompletionHandler is invoked.")
			completionHandler(result: parsedResult, error: nil)
		}
	}
	
	// URL Encoding a dictionary into a parameter string
	
	class func escapedParameters(parameters: [String : AnyObject]) -> String {
		
		var urlVars = [String]()
		
		for (key, value) in parameters {
			// make sure that it is a string value
			let stringValue = "\(value)"
			
			//escape it
			let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
			
			//append it
			if let unwrappedEscapedValue = escapedValue {
				urlVars += [key + "=" + "\(unwrappedEscapedValue)"]
			} else {
				print("Warning: trouble escaping string \"\(stringValue)\"")
			}
		}
		
		return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
	}
	
	
	// MARK: - Shared Instance
	
	class func sharedInstance() -> APIWeatherOnline {
		struct Singleton {
			static var sharedInstance = APIWeatherOnline()
		}
		return Singleton.sharedInstance
	}
	
	
	//create a more detailed error
	
	class func errorForData(data: NSData?, response: NSURLResponse?, error: NSError) -> NSError {
		
		if data == nil {
			return error
		}

		do {
			let parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
			
			if let parsedResult = parsedResult as? [String : AnyObject], errorMessage = parsedResult[APIWeatherOnline.Keys.ErrorStatusMessage] as? String {
				let userInfo = [NSLocalizedDescriptionKey : errorMessage]
				return NSError(domain: "API Error", code: 1, userInfo: userInfo)
			}
			
		} catch {}
		
		return error
	}
}