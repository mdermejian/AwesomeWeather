//
//  LocationTests.swift
//  AwesomeWeather
//
//  Created by Marc Dermejian on 06/03/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import XCTest
@testable import AwesomeWeather

class LocationTests: XCTestCase {
	
	var blankLocation: [String: AnyObject] = [:]
	let dummyResponse = HTTPURLResponse()

	
    override func tearDown() {
        super.tearDown()
		blankLocation = [:]
    }
	
	func testConstructorReturnsNonNil() {
		
		let location = Location(response: dummyResponse, representation: blankLocation)
		XCTAssertNotNil(location, "location should not be nil")
		
	}

	func testPropertiesAreNil() {
		
		guard let location = Location(response: dummyResponse, representation: blankLocation) else {
			XCTFail("guard statement failed")
			return
		}
		
		XCTAssertNil(location.areaName, "uninitialized optional property should be nil")
		XCTAssertNil(location.country, "uninitialized optional property should be nil")
		XCTAssertNil(location.region, "uninitialized optional property should be nil")
	}

	func testInvalidRepresentation() {
		
		let invalidRepresentation: [Int: String] = [1:"xxx"]
		let location = Location(response: dummyResponse, representation: invalidRepresentation)
		XCTAssertNil(location, "location should be nil")
	}

	func testValidRepresentation() {
		
		let validLocationRepresentation =
			[
				"areaName": [["value":"Helsinki"]],
				"country":[["value":"Finland"]],
				"region":[["value":"Southern Finland"]],
				] as [String : Any]
		
		let location = Location(response: dummyResponse, representation: validLocationRepresentation)
		XCTAssertNotNil(location, "location should not be nil")
		
		XCTAssertTrue(location!.areaName == "Helsinki")
		XCTAssertTrue(location!.country == "Finland")
		XCTAssertTrue(location!.region == "Southern Finland")
		
	}

	func testEquatable() {
		guard let location1 = Location(response: dummyResponse, representation: blankLocation),
			let location2 = Location(response: dummyResponse, representation: blankLocation) else {
				XCTFail("location should not be nil")
				return
		}
		
		location1.areaName = "Helsinki"
		location2.areaName = "Helsinki"
		XCTAssertTrue(location1.isEqual(location2), "locations should be equal")
		
		location1.areaName = "Helsinki"
		location2.areaName = "Bergen"
		XCTAssertFalse(location1.isEqual(location2), "locations should NOT be equal")
		
		location1.areaName = nil
		location2.areaName = "Bergen"
		XCTAssertFalse(location1.isEqual(location2), "locations should NOT be equal")
		
		location1.areaName = "Helsinki"
		location2.areaName = nil
		XCTAssertFalse(location1.isEqual(location2), "locations should NOT be equal")
		
		location1.areaName = nil
		location2.areaName = nil
		XCTAssertFalse(location1.isEqual(location2), "locations should NOT be equal")
	}

}
