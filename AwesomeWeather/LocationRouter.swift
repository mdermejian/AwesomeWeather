//
//  LocationRouter.swift
//  AwesomeWeather
//
//  Created by Marc Dermejian on 02/03/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import Alamofire

//Encapsulates the details of a URLRequest for each LocationEndpoint API case
class LocationRouter: URLRequestConvertible, APIConfigurator {
	
	var endpoint: LocationEndpoint
	init(endpoint: LocationEndpoint) {
		self.endpoint = endpoint
	}
	
	
	//MARK: - APIConfigurator implementation - URL Request properties
	var baseURL: URL {
		return URL(string: Config.BaseURLPath)!
	}
	
	var method: HTTPMethod {
		switch self.endpoint {
		case .GetLocations: return .get
		}
	}
	
	var encoding: Alamofire.ParameterEncoding {
		switch self.endpoint {
		case .GetLocations: return URLEncoding.default
		}
	}
	
	//relative path to be appended to the base url
	var relativePath: String {
		switch self.endpoint {
		case .GetLocations:
			return ("/search.ashx")
		}
	}
	
	var parameters: [String: AnyObject]? {
		var params: [String:AnyObject] = [:]
		
		switch self.endpoint {
		case .GetLocations(let query):
			
			//example call:
			//https://api.worldweatheronline.com/premium/v1/search.ashx?
			//key=24c3920d646147a0bcd84325170203
			//&format=json
			//&query=dublin
			//&popular=yes
			//&num_of_results=5
			
			//The API key.
			params["key"] = "\(Config.ApiKey)" as AnyObject
			
			//The output format to return. XML, JSON, or TAB
			params["format"] = "json" as AnyObject
			
			//Whether to only search for popular locations, such as major cities.
			params["popular"] = "yes" as AnyObject
			
			//Location
			params["query"] = query as AnyObject
			
			//The number of results to return
			params["num_of_results"] = Config.NumberOfResults as AnyObject
			
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
		case .GetLocations:
			return try encoding.encode(urlRequest, with: parameters)
		}
	}
}
