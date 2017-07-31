//
//  TitleView.swift
//  Local
//
//  Created by Douglas Galante on 7/31/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

import UIKit

enum DropDownState : Int {
    case hidden = 0
    case revealed = 1
}

class TitleView: UIView {
    weak var delegate: TitleViewDelegate?
    
    @IBOutlet weak var coverButton: UIButton!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var dropDownLabel: UILabel!
    var state = DropDownState(rawValue: 0)!
    
    func reveal() {
        coverButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.dropDownLabel.transform = CGAffineTransform(rotationAngle: self.degreesToRadians(d: 180))
        }, completion: {(_ finished: Bool) -> Void in
            self.coverButton.isUserInteractionEnabled = true
            self.state = .revealed
        })
    }
    
    func collapse() {
        coverButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.dropDownLabel.transform = CGAffineTransform(rotationAngle: self.degreesToRadians(d: 360))
        }, completion: {(_ finished: Bool) -> Void in
            self.coverButton.isUserInteractionEnabled = true
            self.state = .hidden
        })
    }
    
    @IBAction func menuCLicked(_ sender: Any) {
        delegate?.titleViewClicked(state == .hidden)
        if state == .hidden {
            reveal()
        }
        if state == .revealed {
            collapse()
        }
    }
    
    func degreesToRadians(d: CGFloat) -> CGFloat {
        return d * .pi / 180
    }
}
