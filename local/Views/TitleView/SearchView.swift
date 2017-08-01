//
//  SearchView.swift
//  Local
//
//  Created by Douglas Galante on 8/1/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

import UIKit

enum DropDownState : Int {
    case hidden = 0
    case revealed = 1
}

protocol SearchViewDelegate: NSObjectProtocol {
    func searchViewClicked(_ isRevealing: Bool)
}

class SearchView: UIView {
    weak var delegate: SearchViewDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var coverButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var state = DropDownState(rawValue: 0)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("SearchView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        
        //add constraints
        
    }
    
    
    func reveal() {
        coverButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.fadeImage()
            self.switchImage(to: #imageLiteral(resourceName: "LocalX"))
            self.layoutIfNeeded()
        }, completion: {(_ finished: Bool) -> Void in
            self.coverButton.isUserInteractionEnabled = true
            self.state = .revealed
        })
    }
    
    func collapse() {
        coverButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.fadeImage()
            self.switchImage(to: #imageLiteral(resourceName: "LocalSearch"))
            self.layoutIfNeeded()
        }, completion: {(_ finished: Bool) -> Void in
            self.coverButton.isUserInteractionEnabled = true
            self.state = .hidden
        })
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        delegate?.searchViewClicked(state == .hidden)
        if state == .hidden {
            reveal()
            
        }
        if state == .revealed {
            collapse()
        }

    }
    
    private func fadeImage() {
        UIView.animate(withDuration: 0.25) {
            self.imageView.alpha = 0
            self.layoutIfNeeded()
        }
    }
    
    
    private func switchImage(to image: UIImage) {
        imageView.image = image
        UIView.animate(withDuration: 0.25) {
            self.imageView.alpha = 1
            self.layoutIfNeeded()
        }
    }
    
}
