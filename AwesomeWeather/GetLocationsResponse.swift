//
//  GetLocationsResponse.swift
//  AwesomeWeather
//
//  Created by Marc Dermejian on 02/03/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import Foundation

/*
The keys in the key-value pairs received from the backend response to GetLocations
*/
fileprivate enum GetLocationsResponseFields: String {
	
	case Results		= "result"
	case SearchAPI		= "search_api"

}

/*
The backend response to GetLocationResponse API call
*/
struct GetLocationsResponse: ResponseObjectSerializable {
	
	//MARK: - stored properties
	var locations: [Location]?
	
	// MARK: ResponseObjectSerializable
	
	fileprivate typealias Fields = GetLocationsResponseFields
	
	init?(response: HTTPURLResponse, representation: Any) {
		
		guard let representation = representation as? [String: AnyObject]
			else { return nil }
		
		var _locations: [Location] = []
		if let allLocations = representation[Fields.SearchAPI.rawValue]?[Fields.Results.rawValue] as? [[String:AnyObject]] {
			for locationRepresentation in allLocations {
				if let location = Location(response: response, representation: locationRepresentation as AnyObject) {
					_locations.append(location)
				}
			}
		}
		locations = _locations
		
	}
}

