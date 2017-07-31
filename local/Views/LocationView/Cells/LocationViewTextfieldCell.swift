//
//  LocationViewTextfieldCell.swift
//  Local
//
//  Created by Douglas Galante on 7/31/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

import UIKit

class LocationViewTextfieldCell: UITableViewCell, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var autoCompleteTextField: AutoCompleteTextField!

    var delegate: LocationViewTextfieldCellDelegate?
    private weak var _containerView: UIView?
    weak var containerView: UIView? {
        get {
            return _containerView
        }
        set(containerView) {
            _containerView = containerView
            autoCompleteTextField.containerview = self.containerView
            autoCompleteTextField.onSelect = {(_ place: PredictionPlace) -> Void in
                self.autoCompleteTextField.resignFirstResponder()
                self.delegate?.placeSelected(place.placeId)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
