//
//  TrimetSearchController.swift
//  TrimetSample
//
//  Created by Mathew Polzin on 2/8/17.
//  Copyright © 2017 Mathew Polzin. All rights reserved.
//

import Foundation
import SWXMLHash

struct TrimetSearchResults {
	var success = true
	var message = ""
	var routes = [RouteOption]()
	
	static func errorResult(message: String) -> TrimetSearchResults {
		var results = TrimetSearchResults()
		
		results.success = false
		results.message = message
		
		return results
	}
}

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
	class func findRoutes(fromStart start: String, toEnd end:String, completion: @escaping (_ results: TrimetSearchResults) -> Void) {
		if let url = generateSearchUrl(from: start, to: end) {
		
			let task = URLSession.shared.dataTask(with:url) {(data, response, error) in
				
				// default to unknown error that will either be overwritten with a known
				// error or successful results
				var results = TrimetSearchResults.errorResult(message: "Unknown error")
				
				//TODO: add error handling on HTTP response
				
				
				// with no HTTP error, let's parse!
				results = parseRouteOptions(String(data: data!, encoding: String.Encoding.utf8))
				
				DispatchQueue.main.async {
					completion(results)
				}
			}
			
			task.resume()
		} else {
			//TODO: report error
		}
	}
	
	/**
		Generate a TriMet search URL by just tacking a bunch of positional
		arguments together.
	*/
	class func generateSearchUrl(from: String, to: String) -> URL? {
		//TOOD: clean this up by building the URL using a utility class
		print("\(baseUrl)\(fromParam)\(from.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))/\(toParam)\(to.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))/\(appIdParam)")
		return URL(string:"\(baseUrl)\(fromParam)\(from.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))/\(toParam)\(to.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")/\(appIdParam)")
	}
	
	/**
		Parse route options from an XML string returned by the server.

		- Parameter routeOptionsXMLString: The XML string to parse.
	*/
	class func parseRouteOptions(_ routeOptionsXMLString: String?) -> TrimetSearchResults {
		var results = TrimetSearchResults()
		var routeOptions = [RouteOption]()
		
		if let xmlString = routeOptionsXMLString {
			let xml = SWXMLHash.parse(xmlString)
			
			do {
				routeOptions = try xml["response"]["itineraries"]["itinerary"].value()
			} catch _ as XMLDeserializationError {
				//TODO: handle this error
				print("error deserializing!")
			} catch _ as IndexingError {
				//TOOD: handle this error
				print("error finding key in XML!")
			} catch _ {
				//TODO: handle catchall error
				print("unkown error parsing XML!")
			}
			
			results.routes = routeOptions
			
		} else {
			results = TrimetSearchResults.errorResult(message: "Did not receive valid results from TriMet")
		}
		
		return results
	}
}
