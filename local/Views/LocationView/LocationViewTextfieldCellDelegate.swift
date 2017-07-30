//
//  LocationViewTextfieldCellDelegate.swift
//  Local
//
//  Created by Douglas Galante on 7/29/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

import Foundation

protocol LocationViewTextfieldCellDelegate {
    func placeSelected(_ placeId: String)
    func currentPlaceSelected()
}


