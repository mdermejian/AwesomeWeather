//
//  ForecastManager.swift
//  AwesomeWeather
//
//  Created by Marc Dermejian on 02/03/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import Alamofire

/*
This is the network controller for Forecast related API calls: it talks to the backend and then pushes data into your cache, into your persistence engine. (not implemented yet here)
*/
class ForecastManager {
	
	//MARK: methods
	
	func getForecast(forLocation location: String, completion: @escaping (_ success: Bool, _ forecast: Forecast?) -> Void) {
		
		let request = ForecastRouter(endpoint: .GetForecast(location: location))
		Alamofire.request(request)
			
			//Validates that the response has a status code in the default acceptable range of 200…299, and that the content type matches any specified in the Accept HTTP header field.
			//If validation fails, subsequent calls to response handlers will have an associated error.
			.validate()
			
			//Use Generic Response Object Serialization to map the response into a Forecast object
			.responseObject(completionHandler: { (response: DataResponse<Forecast>) in
				completion(response.result.isSuccess,
				           response.result.value)
			})
		
	}
}
