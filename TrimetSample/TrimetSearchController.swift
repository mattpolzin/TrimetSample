//
//  TrimetSearchController.swift
//  TrimetSample
//
//  Created by Mathew Polzin on 2/8/17.
//  Copyright © 2017 Mathew Polzin. All rights reserved.
//

import Foundation
import SWXMLHash

/**
	Store the status of a TriMet search (success or failure) and a message upon
	failure or an array of RouteOptions upon success.

	See https://developer.trimet.org/ws_docs/tripplanner_ws.shtml for TriMet API
	documentation.
*/
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

/**
	Static methods that facilitate searching TriMet's trip planner API,
*/
class TrimetSearchController {
	
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
		let urlEncodedFrom: String = from.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
		let urlEncodedTo: String = to.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
		return URL(string:"\(baseUrl)\(fromParam)\(urlEncodedFrom)/\(toParam)\(urlEncodedTo)/\(appIdParam)")
	}
	
	/**
		Parse route options from an XML string returned by the server.

		- Parameter routeOptionsXMLString: The XML string to parse.
	*/
	class func parseRouteOptions(_ routeOptionsXMLString: String?) -> TrimetSearchResults {
		print(routeOptionsXMLString!)
		
		var results = TrimetSearchResults()
		var routeOptions = [RouteOption]()
		
		var errorMessage: String?
		
		if let xmlString = routeOptionsXMLString {
			let xml = SWXMLHash.parse(xmlString)
			
			do {
				let success: Bool = try xml["response"].value(ofAttribute:"success")
				if success {
					// success!
					
					do {
						routeOptions = try xml["response"]["itineraries"]["itinerary"].value()
						results.routes = routeOptions
					} catch let error as XMLDeserializationError {
						errorMessage = "Error deserializing! msg: \(error.description)"
					} catch let error as IndexingError {
						errorMessage = "Error finding key in XML! msg: \(error.description)"
					} catch _ {
						errorMessage = "Uknown Error parsing XML!"
					}
					
				} else {
					// failure
					
					let reason: String = try xml["response"]["error"]["message"].value()
					errorMessage = reason
				}
			} catch {
				errorMessage = "Uknown Error parsing XML!"
			}
			
		} else {
			// failure
			
			errorMessage = "Did not receive valid results from TriMet"
		}
		
		// set up error message in returned results
		if let errMsg = errorMessage {
			results = TrimetSearchResults.errorResult(message: errMsg)
		}
		
		return results
	}
}
