//
//  RequestResult.swift
//  PlaceSearch
//
//  Created by Sepandat Pourtaymour on 15/04/2018.
//  Copyright © 2018 Sepandat Pourtaymour. All rights reserved.
//

import Foundation
import UIKit

struct RequestResult {
	var places: [Place]
	
	init(places: [Place]) {
		self.places = places
	}
}

extension RequestResult: Codable {
	enum RequestResultKeys: String, CodingKey { // declaring our keys
		case places = "results"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: RequestResultKeys.self) // defining our (keyed) container
		let places: [Place] = try container.decode([Place].self, forKey: .places) // extracting the data
		
		self.init(places: places) // initializing our struct
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: RequestResultKeys.self)
		try container.encode(places, forKey: .places)
	}
}

