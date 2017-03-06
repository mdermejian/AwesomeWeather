//
//  Constants.swift
//  AwesomeWeather
//
//  Created by Marc Dermejian on 02/03/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import UIKit

struct Config {
	
	//Base URL
	static let BaseURLPath = "https://api.worldweatheronline.com/premium/v1"
	
	//API call timeout interval
	static let Timeout = TimeInterval(15)
	
	//API Key for worldweatheronline.com
	static let ApiKey = "24c3920d646147a0bcd84325170203"
	
	//Archiving Paths
	static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
	static let ArchiveURL = DocumentsDirectory.appendingPathComponent("locations")
	
	//The number of results to return when querying location
	static let NumberOfResults = "8"
}

// This would hold the palette of special colors being used throughout the app
struct Colors {
	
	static let ButtonBlue = UIColor(red: 0/255, green: 124/255, blue: 250/255, alpha: 1.0)
	
}

struct Images {
	
	static let PlaceholderWeatherIconImageName = "placeholder"
	static let EmptyDataSetImageName = "cancel_location-128"
	
}
