//
//  Forecast.swift
//  AwesomeWeather
//
//  Created by Marc Dermejian on 02/03/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import UIKit
import Commons

struct Forecast: CustomStringConvertible, ResponseObjectSerializable {
	
	// MARK: - stored properties
	
	var observationTime: Date?
	var tempC: String?
	var weatherIconString: String?
	var shortDescription: String?
	var windspeed: String?
	
	// MARK: - computed properties
	
	var weatherIconURL: URL? {
		//Returns nil if a URL cannot be formed with the string (for example, if the string contains characters that are illegal in a URL, or is an empty string)
		//or if the logo string is empty
		if weatherIconString != nil {
			return URL(string: weatherIconString!)
		}
		return nil
	}
	
	var placeholderImage: UIImage {
		return UIImage(named: "placeholder")!
	}
	
	
	// MARK: - ResponseObjectSerializable protocol implementation
	
	fileprivate typealias Fields = ForecastKey
	fileprivate typealias Value = AnyObject
	
	init?(response: HTTPURLResponse, representation: Any) {
		
		guard let representation = representation as? [String: AnyObject],
			let data = representation[Fields.Data] as? [String: AnyObject],
			let currentConditions = data[Fields.CurrentCondition] as? [[String: AnyObject]],
			let currentCondition = currentConditions.first
			else { return nil }
		
		
		if let observationTime = currentCondition[Fields.ObservationTime] as? String,
			let date = Utility.dateFormatter.date(from: observationTime) {
			self.observationTime = date
		}

		if let tempC = currentCondition[Fields.TempC] as? String { self.tempC = tempC }
		if let windspeed = currentCondition[Fields.WindspeedKPH] as? String { self.windspeed = windspeed }
		
		if let weatherIconString = (currentCondition[Fields.WeatherIconUrl] as? [[String: AnyObject]])?.first?[Fields.Value] as? String { self.weatherIconString = weatherIconString }
		
		if let shortDescription = (currentCondition[Fields.WeatherDesc] as? [[String: AnyObject]])?.first?[Fields.Value] as? String { self.shortDescription = shortDescription }
		
	}
}

// MARK: - API Keys

// The keys to the values received in the API response
// These do not represent the entirety of the response
// we are only choosing a select few to parse and store
struct ForecastKey {
	
	static let ObservationTime	= "observation_time"
	static let TempC			= "temp_C"
	static let WeatherIconUrl	= "weatherIconUrl"
	static let WeatherDesc		= "weatherDesc"
	static let WindspeedKPH		= "windspeedKmph"
	static let Value			= "value"
	static let Data				= "data"
	static let CurrentCondition	= "current_condition"
}




