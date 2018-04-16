//
//  LocationManager.swift
//
//  Created by Sep Pourteymour on 17/04/2017.
//  Copyright © 2017 Appocalyptis. All rights reserved.
//

import Foundation
import CoreLocation

@objc protocol LocationOrganiserDelegate {
	@objc optional func locationOrganiserDidUpdateUserLocation(location:CLLocation)
}

enum DelegateType:Int {
	case userUpdate = 1
}

class LocationManager:NSObject, CLLocationManagerDelegate {
	
	static let instance = LocationManager()
	internal var userLocationDelegates:NSHashTable<AnyObject>
	
	var currentLocation:CLLocation? = nil
	var isVisible:Bool = false
	lazy var locationManager:CLLocationManager = {
		let lman = CLLocationManager()
		lman.requestAlwaysAuthorization()
		lman.delegate = self
		lman.desiredAccuracy = kCLLocationAccuracyBest
		lman.distanceFilter = 3; // meters, set according to the required value.
		return lman
	}()
	
	override init() {
		userLocationDelegates = NSHashTable.weakObjects()
	}
	
	func addDelegateForType(delegate:LocationOrganiserDelegate, type:DelegateType) {
		switch type {
		case .userUpdate:
			if !userLocationDelegates.contains(delegate) {
				userLocationDelegates.add(delegate)
			}
			break
		}
	}
	
	func removeDelegateForType(delegate:LocationOrganiserDelegate, type:DelegateType) {
		switch type {
		case .userUpdate:
			if userLocationDelegates.contains(delegate) {
				userLocationDelegates.remove(delegate)
			}
		}
	}
	
	func startUpdating() {
		enableLocationServices(true)
	}
	
	func stopUpdating() {
		enableLocationServices(false)
	}
	
	func setIsForVisibility(isForVisibility:Bool) {
		isVisible = isForVisibility
	}
	
	fileprivate func enableLocationServices(_ enabled: Bool) {
		switch CLLocationManager.authorizationStatus() {
		case .authorizedAlways: fallthrough
		case .authorizedWhenInUse:
			if enabled {
				locationManager.startUpdatingLocation()
			}
			else {
				locationManager.stopUpdatingLocation()
			}
		case  .notDetermined, .denied, .restricted:
			locationManager.requestAlwaysAuthorization()
			break
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .authorizedAlways:
			UserDefaults.standard.set(true, forKey: "LocationAlwaysEnabled")
			enableLocationServices(true)
		case .authorizedWhenInUse:
			UserDefaults.standard.set(true, forKey: "LocationEnabledOnlyInUse")
			enableLocationServices(true)
		case .denied, .restricted:
			fallthrough
		default:
			UserDefaults.standard.set(false, forKey: "LocationEnabledOnlyInUse")
			UserDefaults.standard.set(false, forKey: "LocationAlwaysEnabled")
			break
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
		
		currentLocation = locations.last!
		if userLocationDelegates.allObjects.count > 0 {
			for delegate in userLocationDelegates.allObjects {
				delegate.locationOrganiserDidUpdateUserLocation!(location: currentLocation!)
			}
		}
		locationManager.stopUpdatingLocation()
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Error: \(error.localizedDescription)")
	}
}
