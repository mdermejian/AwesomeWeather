//
//  Utility.swift
//  AwesomeWeather
//
//  Created by Marc Dermejian on 02/03/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import Foundation
import Commons

final class Utility {
	
	// used to transform an ISO8601 date string to foundation Date object
	static var dateFormatter: DateFormatter {
		let formatter = DateFormatter.internetDateTime()!
		formatter.dateFormat = "HH':'mm a"
		return formatter
	}
	
}
