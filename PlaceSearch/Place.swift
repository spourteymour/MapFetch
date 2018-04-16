//
//  Place.swift
//  PlaceSearch
//
//  Created by Sepandat Pourtaymour on 15/04/2018.
//  Copyright © 2018 Sepandat Pourtaymour. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit


struct Place {
	var geometry: Geometry
	var name: String
	var address: String
	var iconUrlString: String
	
	init(geometry: Geometry, name: String, address: String, iconUrlString: String) {
		self.geometry = geometry
		self.name = name
		self.address = address
		self.iconUrlString = iconUrlString
	}
}

extension Place: Codable {
	enum PlaceKeys: String, CodingKey { // declaring our keys
		case geometry = "geometry"
		case name = "name"
		case address = "formatted_address"
		case iconUrlString = "icon"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: PlaceKeys.self) // defining our (keyed) container
		let geometry: Geometry = try container.decode(Geometry.self, forKey: .geometry) // extracting the data
		let name: String = try container.decode(String.self, forKey: .name) // extracting the data
		let address: String = try container.decode(String.self, forKey: .address) // extracting the data
		let iconUrlString: String = try container.decode(String.self, forKey: .iconUrlString) // extracting the data

		self.init(geometry: geometry, name: name, address: address, iconUrlString: iconUrlString) // initializing our struct
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: PlaceKeys.self)
		try container.encode(geometry, forKey: .geometry)
		try container.encode(name, forKey: .name)
		try container.encode(address, forKey: .address)
		try container.encode(iconUrlString, forKey: .iconUrlString)
	}
}
