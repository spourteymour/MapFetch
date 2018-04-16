//
//  Geometry.swift
//  PlaceSearch
//
//  Created by Sepandat Pourtaymour on 15/04/2018.
//  Copyright © 2018 Sepandat Pourtaymour. All rights reserved.
//

import Foundation
import UIKit


struct Geometry {
	var location: Location
	
	init(location: Location) {
		self.location = location
	}
}

extension Geometry: Codable {
	enum GeometryKeys: String, CodingKey { // declaring our keys
		case location = "location"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: GeometryKeys.self) // defining our (keyed) container
		let location: Location = try container.decode(Location.self, forKey: .location) // extracting the data
		
		self.init(location: location) // initializing our struct
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: GeometryKeys.self)
		try container.encode(location, forKey: .location)
	}
}
