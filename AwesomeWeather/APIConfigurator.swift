//
//  APIConfigurator.swift
//  AwesomeWeather
//
//  Created by Marc Dermejian on 02/03/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import Alamofire

/*
Allows us to configure each endpoint in the enum with the information we'll need for each endpoint, such as the encoding, base url, HTTP method, default headers, timeout and path
Needs to be adopted by Router objects!!
*/
protocol APIConfigurator {
	
	var baseURL: URL { get }
	var method: HTTPMethod { get }
	var encoding: Alamofire.ParameterEncoding { get }
	var relativePath: String { get }
	var parameters: [String : AnyObject]? { get }
	var timeoutInterval: TimeInterval { get }
	var defaultHeaders: [String: String] { get }
}
