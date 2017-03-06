//
//  ForecastTests.swift
//  AwesomeWeather
//
//  Created by Marc Dermejian on 06/03/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import XCTest
@testable import AwesomeWeather

class ForecastTests: XCTestCase {

//	var blankForecast: [String: AnyObject] = [:]
	
	var blankForecast =
		["data":["current_condition":[[:]]]] as [String : Any]

	
	let dummyResponse = HTTPURLResponse()
	
    override func tearDown() {
        super.tearDown()
		blankForecast = [:]
    }
    
	func testConstructorReturnsNonNil() {
		
		let forecast = Forecast(response: dummyResponse, representation: blankForecast)
		XCTAssertNotNil(forecast, "forecast should not be nil")
		
	}
	
	func testPropertiesAreNil() {
		
		guard let forecast = Forecast(response: dummyResponse, representation: blankForecast) else {
			XCTFail("guard statement failed")
			return
		}
		
		XCTAssertNil(forecast.observationTime, "uninitialized optional property should be nil")
		XCTAssertNil(forecast.tempC, "uninitialized optional property should be nil")
		XCTAssertNil(forecast.weatherIconString, "uninitialized optional property should be nil")
		XCTAssertNil(forecast.shortDescription, "uninitialized optional property should be nil")
		XCTAssertNil(forecast.windspeed, "uninitialized optional property should be nil")
		
		XCTAssertNil(forecast.weatherIconURL, "weatherIconURL computed property should be nil when posterPath is nil")
	}
	
	func testInvalidRepresentation() {
		
		let invalidRepresentation: [Int: String] = [1:"xxx"]
		let forecast = Forecast(response: dummyResponse, representation: invalidRepresentation)
		XCTAssertNil(forecast, "forecast should be nil")
	}
	
	func testValidRepresentation() {
		
		let validForecastRepresentation =
			["data":
				["current_condition":[[
				"FeelsLikeC" : "27",
				"FeelsLikeF" : "81",
				"cloudcover" : "38",
				"humidity" : "78",
				"observation_time" : "10:02 AM",
				"precipMM" : "0.0",
				"pressure" : "1009",
				"temp_C" : "25",
				"temp_F" : "77",
				"visibility" : "10",
				"weatherCode" : "116",
				"weatherDesc" : [["value" : "Partly cloudy"]],
				"weatherIconUrl" : [["value" : "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png"]],
				"windspeedKmph" : "18"
				]]
				]
		] as [String : Any]

		let forecast = Forecast(response: dummyResponse, representation: validForecastRepresentation)
		XCTAssertNotNil(forecast, "forecast should not be nil")
		
		let date = Utility.dateFormatter.date(from: "10:02 AM")
		XCTAssertNotNil(date, "date should not be nil")
		XCTAssertTrue(forecast!.observationTime?.compare(date!) == .orderedSame)
		
		XCTAssertTrue(forecast!.tempC == "25")
		XCTAssertTrue(forecast!.weatherIconString == "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png")
		XCTAssertTrue(forecast!.shortDescription == "Partly cloudy")
		XCTAssertTrue(forecast!.windspeed == "18")
		
		let urlString = "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png"
		XCTAssertTrue(forecast!.weatherIconURL == URL(string: urlString))
		
	}
		
}
