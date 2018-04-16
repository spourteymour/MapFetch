//
//  RequestParameters.swift
//  PlaceSearch
//
//  Created by Sepandat Pourtaymour on 15/04/2018.
//  Copyright © 2018 Sepandat Pourtaymour. All rights reserved.
//

import Foundation

enum OutputType: String {
	case json
	case xml
}

enum RequestParameters: String {
	case query
	case radius
	case key
	case type
	case location

	static func textSearchComponents() -> [RequestParameters] {
		return [.key, .radius, .query]
	}
	
	static func radiusSearchComponents() -> [RequestParameters] {
		return [.key, .location, .radius, .type]
	}
	
	static func getURL(forRadius: Bool, locationString: String) -> URLRequest? {
		let searchComponents = RequestParameters.radiusSearchComponents()
		var queryItems = [URLQueryItem]()
		searchComponents.forEach {
			switch $0 {
			case .type, .query, .location:
				var value: String = "Not Set"
				switch $0 {
				case .type:
					value = "bar"
				case .query:
					value = "TO Fetch from textfield"
				case .location:
					value = locationString
				default:
					break
				}
				let parameter = RequestParameters.setupSearchParams(parameter: $0, value: value)
				if let value = parameter.value {
					let queryItem = URLQueryItem(name: parameter.key, value: value)
					queryItems.append(queryItem)
				}
			default:
				let parameter = RequestParameters.setupSearchParams(parameter: $0)
				if let value = parameter.value {
					let queryItem = URLQueryItem(name: parameter.key, value: value)
					queryItems.append(queryItem)
				}
			}
		}
		
		return RequestParameters.requestPlaces(queryItems: queryItems, outputType: .json, urlString: nil, isForTextSearch: true)
	}
	
	static func setupSearchParams(parameter: RequestParameters, value: String? = nil) -> (key: String, value: String?) {
		let key = parameter.rawValue
		switch parameter {
		case .key:
			return (key: key, value: AppData.Keys.googlePlacesKey)
		case .radius:
			return (key: key, value: "1000")
		case .type, .query, .location:
			guard let value = value else { return (key: key, value: nil) }
			return (key: key, value: value)
		}
	}

	static func requestPlaces(queryItems: [URLQueryItem], outputType: OutputType = .json, urlString: String?, isForTextSearch: Bool = false) -> URLRequest? {
		let requestSearchString = isForTextSearch ? "textsearch" : "nearbysearch"
		let outputString = outputType.rawValue
		var requestUrlString = AppData.Keys.googlePlacesUrl
		if let string = urlString {
			requestUrlString = string
		}
		requestUrlString.append("/\(requestSearchString)/\(outputString)")
		let urlComps = NSURLComponents(string: requestUrlString)!
		urlComps.queryItems = queryItems
		guard let url = urlComps.url else {return nil}
		return URLRequest(url: url)
	}
}


