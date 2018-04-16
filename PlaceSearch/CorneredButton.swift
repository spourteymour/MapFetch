//
//  CorneredButton.swift
//  PlaceSearch
//
//  Created by Sepandat Pourtaymour on 15/04/2018.
//  Copyright © 2018 Sepandat Pourtaymour. All rights reserved.
//

import UIKit

@IBDesignable
class CorneredButton: UIButton {
	@IBInspectable var radius: CGFloat = 0.0 {
		didSet {
			self.layer.cornerRadius = radius
			self.layer.masksToBounds = true
		}
	}

	@IBInspectable var borderWidth: CGFloat = 0.0 {
		didSet {
			self.layer.borderWidth = borderWidth
			self.layer.masksToBounds = true
		}
	}
	
	@IBInspectable var borderColor: UIColor = .clear {
		didSet {
			self.layer.borderColor = borderColor.cgColor
			self.layer.masksToBounds = true
		}
	}
}
