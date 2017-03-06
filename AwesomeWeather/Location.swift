//
//  Location.swift
//  AwesomeWeather
//
//  Created by Marc Dermejian on 02/03/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import Foundation

final class Location: NSObject, NSCoding, ResponseObjectSerializable {
	
	// MARK: - stored properties
	var areaName: String?
	var country: String?
	var region: String?
	
	// MARK: - computed properties
	
	var dictionaryRepresentation: [String : Any] {
		
		let representation =
			[Fields.AreaName : "\(areaName)",
			Fields.Country : "\(country)",
			Fields.Region : "\(region)"
			] as [String : Any]
		
		return representation
	}
	
	override var description: String {
		return dictionaryRepresentation.debugDescription
	}

	// MARK: - ResponseObjectSerializable protocol implementation
	
	fileprivate typealias Fields = LocationKey
	fileprivate typealias Value = AnyObject
	
	init?(response: HTTPURLResponse, representation: Any) {
		
		guard let representation = representation as? [String: AnyObject] else { return nil }
		
		if let areaName = (representation[Fields.AreaName] as? [[String:AnyObject]])?.first?[Fields.Value] as? String { self.areaName = areaName }
		if let country = (representation[Fields.Country] as? [[String:AnyObject]])?.first?[Fields.Value] as? String { self.country = country }
		if let region = (representation[Fields.Region] as? [[String:AnyObject]])?.first?[Fields.Value] as? String { self.region = region }
		
	}
	
	//MARK: - NSCoding
	
	func encode(with aCoder: NSCoder) {
		
		aCoder.encode(areaName, forKey: Fields.AreaName)
		aCoder.encode(country, forKey: Fields.Country)
		aCoder.encode(region, forKey: Fields.Region)
	}
	
	init?(coder aDecoder: NSCoder) {
		
		super.init()
		
		areaName = aDecoder.decodeObject(forKey: Fields.AreaName) as? String
		country = aDecoder.decodeObject(forKey: Fields.Country) as? String
		region = aDecoder.decodeObject(forKey: Fields.Region) as? String
	}


// MARK: - Equatable protocol implementation

	override func isEqual(_ object: Any?) -> Bool {
		
		guard let object = object as? Location,
		object.areaName != nil
		else { return false }
		
		return self.areaName != nil
			&& self.areaName == object.areaName

	}
}

// MARK: - API Keys

// The keys to the values received in the API response
// These do not represent the entirety of the response
// we are only choosing a select few to parse and store
struct LocationKey {
	
	static let AreaName		= "areaName"
	static let Country		= "country"
	static let Region		= "region"
	static let Value		= "value"

}
