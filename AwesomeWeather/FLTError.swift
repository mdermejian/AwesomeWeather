//
//  FLTError.swift
//  AwesomeWeather
//
//  Created by Marc Dermejian on 02/03/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import Foundation

enum FLTError: Error {
	case network(error: Error) // Capture any underlying Error from the URLSession API
	case dataSerialization(error: Error)
	case jsonSerialization(error: Error)
	case xmlSerialization(error: Error)
	case objectSerialization(reason: String)
}
