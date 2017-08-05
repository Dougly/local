//
//  SubFilterVC.swift
//  Local
//
//  Created by Douglas Galante on 8/5/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

import UIKit


class SubFilterVC: UIViewController, UIGestureRecognizerDelegate {
    
    //let SUB_FILTER_VIEW_CELL: String = "MTFilterViewCell"
    var filterGroupIndex: FilterViewCellIndex?
    
    @IBOutlet var tableView: UITableView!
    var selectedIndexPath: IndexPath?
    var isClosed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateSelectedIndexPath()
        registerCells()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    func calculateSelectedIndexPath() {
        var index: Int = -1
        guard let filterGroupIndex = filterGroupIndex  else { return }
        guard let filterKeyWords = MTSettings.shared().filterKeyWords else { return }
        let subfilterStrings = Constants.subFilterTitles[filterGroupIndex.rawValue]
        for (i, string) in subfilterStrings.enumerated() {
            if string == filterKeyWords {
                index = i
                break
            }
        }
        selectedIndexPath = IndexPath(row: index, section: 0)
    }
    
    
    func registerCells() {
        tableView.register(UINib(nibName: "MTFilterViewCell", bundle: nil), forCellReuseIdentifier: "MTFilterViewCell")
    }
    
    
    // MARK: - UITableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let filterGroupIndex = filterGroupIndex {
            let titles = Constants.subFilterTitles[filterGroupIndex.rawValue]
            return titles.count
        } else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MTFilterViewCell", for: indexPath) as! MTFilterViewCell
        cell.buttonWidth?.constant = 0
        cell.imageAndTextPadding?.constant = 4
        if indexPath.row == selectedIndexPath?.row {
            cell.markImageView?.isHidden = false
        }
        else {
            cell.markImageView?.isHidden = true
        }
        
        if let filterGroupIndex = filterGroupIndex {
            let titles = Constants.subFilterTitles[filterGroupIndex.rawValue]
            cell.leftImageButton?.setTitle("", for: .normal)
            cell.captionLabel?.text = titles[indexPath.row]
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let filterGroupIndex = filterGroupIndex {
            let keywords = Constants.subFilterKeyWords[filterGroupIndex.rawValue]
            MTSettings.shared().filterKeyWords = keywords[indexPath.row]
            guard let selectedIndexPath = selectedIndexPath else { return }
            let currentlySelectedCell = self.tableView.cellForRow(at: selectedIndexPath) as! MTFilterViewCell
            currentlySelectedCell.markImageView?.isHidden = true
            let newlySelectedCell = self.tableView.cellForRow(at: indexPath) as! MTFilterViewCell
            newlySelectedCell.markImageView?.isHidden = false
            self.selectedIndexPath = indexPath
            let name = NSNotification.Name(rawValue: "HideFilterViewNotification")
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        }
    }
    
    // Swipe down to close filter view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pullDistance: CGFloat = scrollView.contentOffset.y
        if pullDistance < -70 {
            if !isClosed {
                let userInfo: [AnyHashable: Any] = ["RevertFilterVIewToPreviousIndex" : (true)]
                let name = NSNotification.Name(rawValue: "HideFilterViewNotification")
                NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
                isClosed = true
            }
        }
    }
    
}
