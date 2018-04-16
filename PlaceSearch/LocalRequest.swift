//
//  LocalRequest.swift
//  PlaceSearch
//
//  Created by Sepandat Pourtaymour on 16/04/2018.
//  Copyright © 2018 Sepandat Pourtaymour. All rights reserved.
//

import Foundation

class LocalRequest {
	static func getURL() -> URL {
		let fileName:String = "lastSearch.pdf"
		var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last
		docURL = docURL?.appendingPathComponent(fileName)
		return docURL!
	}

	static func store<T: Encodable>(_ object: T) {
		let url = LocalRequest.getURL()
		
		let encoder = JSONEncoder()
		do {
			let data = try encoder.encode(object)
			if FileManager.default.fileExists(atPath: url.path) {
				try FileManager.default.removeItem(at: url)
			}
			FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
		} catch {
			fatalError(error.localizedDescription)
		}
	}
	
	static func retrieve<T: Decodable>(as type: T.Type) -> T {
		let url = getURL()
		
		if !FileManager.default.fileExists(atPath: url.path) {
			fatalError("File at path \(url.path) does not exist!")
		}
		
		if let data = FileManager.default.contents(atPath: url.path) {
			let decoder = JSONDecoder()
			do {
				let model = try decoder.decode(type, from: data)
				return model
			} catch {
				fatalError(error.localizedDescription)
			}
		} else {
			fatalError("No data at \(url.path)!")
		}
	}

}
