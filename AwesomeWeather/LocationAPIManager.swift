//
//  LocationAPIManager.swift
//  AwesomeWeather
//
//  Created by Marc Dermejian on 02/03/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import Alamofire

/*
This is the network controller for Location related API calls: it communicates with the backend and then pushes data into your cache, into your persistence engine. (not implemented yet here)
*/
class LocationAPIManager {
	
	//MARK: methods
	
	func getLocations(named locationName: String, completion: @escaping (_ success: Bool, _ locations: [Location]?) -> Void) {
		
		let request = LocationRouter(endpoint: .GetLocations(named: locationName))
		Alamofire.request(request)
			
			//Validates that the response has a status code in the default acceptable range of 200…299, and that the content type matches any specified in the Accept HTTP header field.
			//If validation fails, subsequent calls to response handlers will have an associated error.
			.validate()
			
			//Use Generic Response Object Serialization to map the response into a GetLocationsResponse object
			.responseObject(completionHandler: { (response: DataResponse<GetLocationsResponse>) in
				completion(response.result.isSuccess,
				           response.result.value?.locations)
			})
		
	}
}
