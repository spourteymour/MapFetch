//
//  PlacesTableCell.swift
//  PlaceSearch
//
//  Created by Sepandat Pourtaymour on 15/04/2018.
//  Copyright © 2018 Sepandat Pourtaymour. All rights reserved.
//

import UIKit
import Kingfisher

class PlacesTableCell: UITableViewCell {

	var iconImage: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
		imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
		return imageView
	}()
	
	var nameLabel = UILabel()
	var place: Place?
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupIconImage()
		setupLabel()
	}
	
	func setupIconImage() {
		iconImage.translatesAutoresizingMaskIntoConstraints = false
		addSubview(iconImage)
		iconImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
		iconImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
	}
	
	func setupLabel() {
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(nameLabel)
		nameLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 10).isActive = true
		nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
		nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
		nameLabel.centerYAnchor.constraint(equalTo: iconImage.centerYAnchor).isActive = true
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		guard let place = place else {return}
		nameLabel.text = place.name
		guard let url = URL(string: place.iconUrlString) else {return}
		iconImage.kf.setImage(with: url)

	}
	
	func configure(place: Place) {
		self.place = place
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		nameLabel.text = ""
		iconImage.image = nil
	}
}
