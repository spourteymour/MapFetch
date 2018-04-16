//
//  ViewController.swift
//  PlaceSearch
//
//  Created by Sepandat Pourtaymour on 15/04/2018.
//  Copyright © 2018 Sepandat Pourtaymour. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

	@IBOutlet weak var startButton: CorneredButton!
	@IBOutlet weak var mapButton: CorneredButton!
	@IBOutlet weak var ctaLabel: UILabel!
	
	var isForMap = false
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	@IBAction func didTapMapStart(_ sender: Any) {
		isForMap = true
		startLocationUpdate()
	}
	
	@IBAction func didTapStart(_ sender: Any) {
		isForMap = false
		startLocationUpdate()
	}
	
	func startLocationUpdate() {
		// For now we're relying on URLSession to fail in order to trigger local fetch
		//TODO: implement Reachability to determine network availability
		LocationManager.instance.addDelegateForType(delegate: self, type: .userUpdate)
		LocationManager.instance.startUpdating()
		startButton.isEnabled = false
		self.startButton.borderWidth = 0
		mapButton.isEnabled = false
		self.mapButton.borderWidth = 0
		ctaLabel.text = "Please Wait"
	}
	
	func setupSearchParams(parameter: RequestParameters, value: String? = nil) -> (key: String, value: String?) {
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

	func checkPrevious() {
		let result = LocalRequest.retrieve(as: RequestResult.self)
		guard let firstItem = result.places.first else { return }
		let location = CLLocation(latitude: CLLocationDegrees(firstItem.geometry.location.lat), longitude: CLLocationDegrees(firstItem.geometry.location.long))
		displayResult(requestResult: result, location: location)
	}
	
	func saveLast(requestResult: RequestResult) {
		LocalRequest.store(requestResult)
	}
		
	func displayResult(requestResult: RequestResult, location: CLLocation) {
		DispatchQueue.main.async {
			self.ctaLabel.text = "Tap the button to search surrounding pubs"
			self.startButton.isEnabled = true
			self.startButton.borderWidth = 1
			self.mapButton.isEnabled = true
			self.mapButton.borderWidth = 1
			
			if self.isForMap {
				let mapVC = MapViewController()
				mapVC.location = location
				mapVC.places = requestResult.places
				self.navigationController?.pushViewController(mapVC, animated: true)
			} else {
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				if let controller = storyboard.instantiateViewController(withIdentifier: "placesTableViewController") as? PlacesTableViewController {
					controller.places = requestResult.places
					self.navigationController?.pushViewController(controller, animated: true)
				}
			}

		}
	}
}

extension ViewController: LocationOrganiserDelegate {
	func locationOrganiserDidUpdateUserLocation(location:CLLocation) {
		LocationManager.instance.removeDelegateForType(delegate: self, type: .userUpdate)
		
		let latitude = String(stringInterpolationSegment: location.coordinate.latitude)
		let longitude = String(stringInterpolationSegment: location.coordinate.longitude)
		let locationString = String(format: "%@,%@", latitude, longitude)
		
		guard let request = RequestParameters.getURL(forRadius: true, locationString: locationString) else { return }
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			if error != nil {
				self.checkPrevious()
				return
			}
			guard let receivedData = data, let requestResult = try? JSONDecoder().decode(RequestResult.self, from: receivedData) else {
				self.checkPrevious()
				return
			}
			self.saveLast(requestResult: requestResult)
			self.displayResult(requestResult: requestResult, location: location)
			}.resume()
	}
}
