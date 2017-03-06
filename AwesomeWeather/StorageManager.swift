//
//  StorageManager.swift
//  AwesomeWeather
//
//  Created by Marc Dermejian on 03/03/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import Foundation

class StorageManager {
	
	@discardableResult
	func save(locations: [Location]) -> Bool {
		let saved = NSKeyedArchiver.archiveRootObject(locations, toFile: Config.ArchiveURL.path)
		return saved
	}
	
	func restoreLocations() -> [Location] {
		guard let locations = NSKeyedUnarchiver.unarchiveObject(withFile: Config.ArchiveURL.path) as? [Location]
			else { return [] }
		return locations
	}
	
}
