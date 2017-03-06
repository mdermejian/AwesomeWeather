//
//  ForecastRouter.swift
//  AwesomeWeather
//
//  Created by Marc Dermejian on 02/03/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import Alamofire

//Encapsulates the details of a URLRequest for each ForecastEndpoint API case
class ForecastRouter: URLRequestConvertible, APIConfigurator {
	
	var endpoint: ForecastEndpoint
	init(endpoint: ForecastEndpoint) {
		self.endpoint = endpoint
	}
	
	
	//MARK: - APIConfigurator implementation - URL Request properties
	var baseURL: URL {
		return URL(string: Config.BaseURLPath)!
	}
	
	var method: HTTPMethod {
		switch self.endpoint {
		case .GetForecast: return .get
		}
	}
	
	var encoding: Alamofire.ParameterEncoding {
		switch self.endpoint {
		case .GetForecast: return URLEncoding.default //return nil
		}
	}
	
	//relative path to be appended to the base url
	var relativePath: String {
		switch self.endpoint {
		case .GetForecast:
			return ("/weather.ashx")
		}
	}
	
	var parameters: [String: AnyObject]? {
		var params: [String:AnyObject] = [:]
		
		switch self.endpoint {
		case .GetForecast(let location):
			
			//example call:
			//https://api.worldweatheronline.com/premium/v1/weather.ashx?
			//key=24c3920d646147a0bcd84325170203
			//&q=Killorglin
			//&format=json
			//&num_of_days=1
			//&fx=no
			//&cc=yes
			//&mca=no
			//&fx24=no
			//&includelocation=no
			//&tp=24
			
			
			//The API key
			params["key"] = "\(Config.ApiKey)" as AnyObject
			
			//Location query
			params["q"] = location as AnyObject
			
			//The output format to return. XML, JSON, CSV, or tab.
			params["format"] = "json" as AnyObject
			
			//Number of days of forecast
			params["num_of_days"] = "1" as AnyObject
			
			//Whether to return weather forecast output
			params["fx"] = "no" as AnyObject
			
			//Whether to return current weather conditions output
			params["cc"] = "yes" as AnyObject
			
			//Whether to return monthly climate average data
			params["mca"] = "no" as AnyObject
			
			//Returns 24 hourly weather information in a 3 hourly interval response
			params["fx24"] = "no" as AnyObject
			
			//Whether to return the nearest weather point for which the weather data is returned for a given postcode, zipcode and lat/lon values
			params["includelocation"] = "no" as AnyObject
			
			//Specifies the weather forecast time interval in hours. Options are: 1 hour, 3 hourly, 6 hourly, 12 hourly (day/night) or 24 hourly (day average)
			params["tp"] = "24" as AnyObject
			
		}
		
		return params
	}
	
	var timeoutInterval: TimeInterval {
		return Config.Timeout
	}
	
	var defaultHeaders: [String: String] {
		
		var headers: [String:String] = [:]
		
		/*
		The API is a JSON API.
		Must set an Accept: application/json header on all requests.
		*/
		headers["Accept"] = "application/json"
		
		return headers
	}
	
	
	
	// MARK: - URLRequestConvertible
	func asURLRequest() throws -> URLRequest {
		
		//build the URLRequest from all the individual components
		var urlRequest = try URLRequest(url: baseURL.appendingPathComponent(relativePath),
		                                method: method,
		                                headers: defaultHeaders)
		urlRequest.timeoutInterval = timeoutInterval
		urlRequest.cachePolicy = .useProtocolCachePolicy
		
		switch self.endpoint {
		case .GetForecast:
			return try encoding.encode(urlRequest, with: parameters)
		}
	}
}
