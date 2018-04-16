//
//  MapViewController.swift
//  PlaceSearch
//
//  Created by Sepandat Pourtaymour on 16/04/2018.
//  Copyright © 2018 Sepandat Pourtaymour. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
	var mapView:GMSMapView? = nil
	var places = [Place]()
	var location: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Near Me"
		let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 13)
		mapView = GMSMapView.map(withFrame: UIScreen.main.bounds, camera: camera)
		if let mapView = mapView {
			view.addSubview(mapView)
			mapView.translatesAutoresizingMaskIntoConstraints = false
			mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
			mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
			mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
			mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		mapView?.delegate = self
		mapView?.isUserInteractionEnabled = true
		mapView?.isMyLocationEnabled = false
		guard let location = location, let currentZoom = mapView?.camera.zoom else {return}
		let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: currentZoom)
		mapView?.animate(to: camera)
		setupMarkers()
	}
	
	func setupMarkers() {
		places.forEach{
			let location = CLLocationCoordinate2D(latitude: CLLocationDegrees($0.geometry.location.lat), longitude: CLLocationDegrees($0.geometry.location.long))
			let marker = PlaceMapMarker(position: location)
			marker.place = $0
			marker.title = $0.name
			marker.map = mapView
		}
	}
}

extension MapViewController: GMSMapViewDelegate {
	func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
		var placeToUse: Place?
		if let placeMarker = marker as? PlaceMapMarker {
			placeToUse = placeMarker.place
		} else {
			let markerLocation = marker.position
			let latitude = NSNumber(floatLiteral: markerLocation.latitude)
			let longitude = NSNumber(floatLiteral: markerLocation.longitude)
			placeToUse = places.filter {
				return ($0.geometry.location.lat == CGFloat(latitude.floatValue)) && ($0.geometry.location.long == CGFloat(longitude.floatValue))
				}.first
		}
		guard let place = placeToUse else {return false}
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		if let controller = storyboard.instantiateViewController(withIdentifier: "placeDetailViewController") as? PlaceDetailViewController {
			controller.configure(place: place)
			navigationController?.pushViewController(controller, animated: true)
		}

		return true
	}
}
