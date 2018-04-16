//
//  PlaceDetailViewController.swift
//  PlaceSearch
//
//  Created by Sepandat Pourtaymour on 16/04/2018.
//  Copyright © 2018 Sepandat Pourtaymour. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UIViewController {

	var place: Place?

	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var addressTextView: UITextView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
    }
	
	func configure(place: Place) {
		self.place = place
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		guard let place = place else { return }
		if let url = URL(string: place.iconUrlString) {
			iconImageView.kf.setImage(with: url)
		}
		nameLabel.text = place.name
		self.title = place.name
		let addressString = place.address.replacingOccurrences(of: ",", with: "\n")
		addressTextView.text = addressString
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

	}
}
