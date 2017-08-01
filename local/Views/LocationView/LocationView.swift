//
//  LocationView.swift
//  Local
//
//  Created by Douglas Galante on 7/31/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

import UIKit

enum MTLocationViewCellIndex : Int {
    case mtLocationViewCellTextfield = 0
    case mtLocationViewCellCurrent
}

class LocationView: UIView, UITabBarDelegate, UITableViewDataSource, LocationViewTextfieldCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: (LocationViewDelegate & LocationViewTextfieldCellDelegate)?
    let locationViewCellTextfield: String = "LocationViewTextfieldCell"
    let locationViewCellCurrent: String = "MTLocationViewCurrentLocationCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCells()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func registerCells() {
        tableView.register(UINib(nibName: "LocationViewTextfieldCell", bundle: nil), forCellReuseIdentifier: locationViewCellTextfield)
        tableView.register(UINib(nibName: "MTLocationViewCurrentLocationCell", bundle: nil), forCellReuseIdentifier: locationViewCellCurrent)
    }
    
    // MARK: - UITableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var finalCell: UITableViewCell = UITableViewCell()
        if indexPath.row == MTLocationViewCellIndex.mtLocationViewCellTextfield.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: locationViewCellTextfield, for: indexPath) as! LocationViewTextfieldCell
            cell.delegate = self
            cell.containerView = self
            finalCell = cell
        }
        if indexPath.row == MTLocationViewCellIndex.mtLocationViewCellCurrent.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: locationViewCellCurrent, for: indexPath) as! MTLocationViewCurrentLocationCell
            finalCell = cell
        }
        return finalCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == MTLocationViewCellIndex.mtLocationViewCellCurrent.rawValue {
            currentPlaceSelected()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pullDistance: CGFloat = scrollView.contentOffset.y
        if pullDistance > 50 {
            delegate?.hideLocationView()
            delegate = nil
        }
    }
    
    // MARK: - MTLocationViewTextfieldCellDelegate
    func placeSelected(_ placeId: String) {
        delegate?.placeSelected(placeId)
        let name = NSNotification.Name(rawValue: "LocationChangedNotification")
        NotificationCenter.default.post(name: name, object: nil)
        delegate?.hideLocationView()
        delegate = nil
    }
    
    func currentPlaceSelected() {
        delegate?.currentPlaceSelected()
        let name = NSNotification.Name(rawValue: "LocationChangedNotification")
        NotificationCenter.default.post(name: name, object: nil)
        delegate?.hideLocationView()
        delegate = nil
    }
}
