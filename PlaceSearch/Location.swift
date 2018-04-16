//
//  Location.swift
//  PlaceSearch
//
//  Created by Sepandat Pourtaymour on 15/04/2018.
//  Copyright © 2018 Sepandat Pourtaymour. All rights reserved.
//

import Foundation
import UIKit

struct Location {
	var lat: CGFloat
	var long: CGFloat
	
	init(lat: CGFloat, long: CGFloat) {
		self.lat = lat
		self.long = long
	}
}

extension Location: Codable {
	enum LocationKeys: String, CodingKey { // declaring our keys
		case lat = "lat"
		case long = "lng"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: LocationKeys.self) // defining our (keyed) container
		let lat: CGFloat = try container.decode(CGFloat.self, forKey: .lat) // extracting the data
		let long: CGFloat = try container.decode(CGFloat.self, forKey: .long) // extracting the data
		
		self.init(lat: lat, long: long) // initializing our struct
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: LocationKeys.self)
		try container.encode(lat, forKey: .lat)
		try container.encode(long, forKey: .long)
	}
}
