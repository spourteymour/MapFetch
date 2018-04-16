//
//  GeneralEnums.swift
//  PlaceSearch
//
//  Created by Sepandat Pourtaymour on 15/04/2018.
//  Copyright © 2018 Sepandat Pourtaymour. All rights reserved.
//

import Foundation

enum AppError: Error {
	case RequestFailed, NotFound
	case searchError(errorDescription: String)
}
