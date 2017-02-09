//
//  TrimetSearchController.swift
//  TrimetSample
//
//  Created by Mathew Polzin on 2/8/17.
//  Copyright © 2017 Mathew Polzin. All rights reserved.
//

import Foundation

class TrimetSearchController : NSObject {
	
	static let baseUrl = "https://developer.trimet.org/ws/V1/trips/tripplanner/"
	static let appIdParam = "appId/6079AA4BBA3D45EB4395BD3B9"
	static let fromParam = "fromplace/"
	static let toParam = "toplace/"
	
	/**
		Search TriMet for route options that will get the user from point A to
		point B. When the search is complete, an array of options will be
		sent to the completion handler.

		- Parameters:
			- fromStart: The location where the user will start.
			- toEnd: The location where the user will end.
			- completion: The callback invoked when the search has finished.
	*/
	class func findRoutes(fromStart start: String, toEnd end:String, completion: @escaping (_ results: [RouteOption]) -> Void) {
		let url = generateSearchUrl(from: start, to: end)
		
		let task = URLSession.shared.dataTask(with:url!) {(data, response, error) in
			print(String(data: data!, encoding: String.Encoding.utf8) ?? "")
			
			//TODO: add error handling
			
			let routeOptions: [RouteOption] = parseRouteOptions(String(data: data!, encoding: String.Encoding.utf8))
			
			DispatchQueue.main.async {
				completion(routeOptions)
			}
		}
		
		task.resume()
	}
	
	/**
		Generate a TriMet search URL by just tacking a bunch of positional
		arguments together.
	*/
	class func generateSearchUrl(from: String, to: String) -> URL? {
		//TOOD: clean this up by building the URL using a utility class
		return URL(string:"\(baseUrl)\(fromParam)\(from)/\(toParam)\(to)/\(appIdParam)")
	}
	
	/**
		Parse route options from an XML string returned by the server.

		- Parameter routeOptionsXMLString: The XML string to parse.
	*/
	class func parseRouteOptions(_ routeOptionsXMLString: String?) -> [RouteOption] {
		let routeOptions = [RouteOption]()
		
		//TODO: add route options
		
		return routeOptions
	}
}
