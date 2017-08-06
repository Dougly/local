//
//  FilterViewController.swift
//  Local
//
//  Created by Douglas Galante on 8/5/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

import UIKit
import Firebase

class FilterVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var subfilterIndex: Int = 0
    var selectedIndexPath: IndexPath?
    var isClosed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBorder()
        registerCells()
        // Remove first cell top separator
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        // Remove last cell bottom separator
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
    }
    
    func prepareForShow() {
        calculateSelectedIndexPath()
        tableView.reloadData()
        isClosed = false
    }
    
    func addBorder() {
        let upperBorder = CALayer()
        upperBorder.backgroundColor = UIColor(red: 47/255, green: 149/255, blue: 152/255, alpha: 1).cgColor
        upperBorder.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1.0)
        view.layer.addSublayer(upperBorder)
    }
    
    func calculateSelectedIndexPath() {
        var index: Int = -1
        guard let filterKeyWord = MTSettings.shared().filterKeyWords else { return }
        print(filterKeyWord)
        switch filterKeyWord {
        case Constants.filterKeyWords[0]:
            print("got to 0")

            index = 0
        case Constants.filterKeyWords[4]:
            print("got to 4")

            index = 4
        default:
            print("got to default")
            for (i, stringArray) in Constants.subFilterKeyWords.enumerated() {
                for (j, subfilterWord) in stringArray.enumerated() {
                    if subfilterWord == filterKeyWord {
                        subfilterIndex = j
                        index = i
                        break
                    }
                }
            }
        }
        print("selected index : \(index)")
        selectedIndexPath = IndexPath(row: index, section: 0)
    }
    
    func registerCells() {
        tableView.register(UINib(nibName: "MTFilterViewCell", bundle: nil), forCellReuseIdentifier: "MTFilterViewCell")
        tableView.register(UINib(nibName: "MTFilterPriceCell", bundle: nil), forCellReuseIdentifier: "MTFilterPriceCell")
    }
    
    // MARK: - UITableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilterViewCellIndex.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var finalCell: UITableViewCell? = nil
        // all the filter cells
        if indexPath.row < FilterViewCellIndex.price.rawValue {
            print("first if")

            let cell = tableView.dequeueReusableCell(withIdentifier: "MTFilterViewCell", for: indexPath) as! MTFilterViewCell
            var subfilterString: String = ""
            
            if let selectedIndexPath = self.selectedIndexPath {
                if indexPath.row == selectedIndexPath.row {
                    cell.markImageView?.isHidden = false
                }
                else {
                    cell.markImageView?.isHidden = true
                }
                
                if selectedIndexPath.row < Constants.filterTitles.count && indexPath.row == selectedIndexPath.row && !Constants.subFilterTitles[selectedIndexPath.row].isEmpty {
                    if selectedIndexPath.row >= FilterViewCellIndex.healthy.rawValue {
                        let subfilters = Constants.subFilterTitles[selectedIndexPath.row]
                        print(subfilters.count)
                        print(subfilterIndex)
                        subfilterString = subfilters[subfilterIndex]
                        subfilterString = " [\(subfilterString)]"
                        
                    }
                }
            }
            
            switch indexPath.row {
            case FilterViewCellIndex.coffee.rawValue:
                cell.leftImageButton?.titleLabel?.font = UIFont(name: "FontAwesome", size: 14)
                cell.leftImageButton?.setTitle("", for: .normal)
                cell.captionLabel?.text = "Caffeine"
                finalCell = cell
            case FilterViewCellIndex.hardStuff.rawValue:
                cell.leftImageButton?.titleLabel?.font = UIFont(name: "FontAwesome", size: 14)
                cell.leftImageButton?.setTitle("0000f000", for: .normal)
                cell.captionLabel?.text = "The Hard Stuff"
                finalCell = cell
            case FilterViewCellIndex.healthy.rawValue:
                cell.leftImageButton?.setTitle("0000e09e", for: .normal)
                cell.captionLabel?.text = "Healthy-ish" + (subfilterString)
                finalCell = cell
            case FilterViewCellIndex.comfort.rawValue:
                cell.leftImageButton?.setTitle("0000e04d", for: .normal)
                cell.captionLabel?.text = "Comfort Food" + (subfilterString)
                finalCell = cell
            case FilterViewCellIndex.sweet.rawValue:
                cell.leftImageButton?.setTitle("0000e073", for: .normal)
                cell.captionLabel?.text = "Sweet Treats" + (subfilterString)
                finalCell = cell
            default:
                break
            }
        } else {
            print("got to else")
            let cell = tableView.dequeueReusableCell(withIdentifier: "MTFilterPriceCell", for: indexPath) as! MTFilterPriceCell
            finalCell = cell
        }
        print(finalCell)
        return finalCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Analytics
        // Cell selection logic
        if indexPath.row == FilterViewCellIndex.coffee.rawValue || indexPath.row == FilterViewCellIndex.hardStuff.rawValue {
            MTSettings.shared().filterKeyWords = Constants.filterKeyWords[indexPath.row]
            if let selectedIndexPath = selectedIndexPath {
                let currentlySelectedCell = tableView.cellForRow(at: selectedIndexPath) as! MTFilterViewCell
                currentlySelectedCell.markImageView?.isHidden = true
                let newlySelectedCell = tableView.cellForRow(at: indexPath) as! MTFilterViewCell
                newlySelectedCell.markImageView?.isHidden = false
                self.selectedIndexPath = indexPath
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
                    let name = NSNotification.Name(rawValue: "HideFilterViewNotification")
                    NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
                })
            }
        }
        else {
            let main = UIStoryboard(name: "Main", bundle: nil)
            let subfilterViewController = main.instantiateViewController(withIdentifier: "subFilterVC") as! SubFilterVC
            subfilterViewController.filterGroupIndex = FilterViewCellIndex(rawValue: indexPath.row)
            navigationController?.pushViewController(subfilterViewController, animated: true)
        }
        self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
        Analytics.logEvent(Constants.selectedFilterEvent, parameters: nil)
        // Add switch statement
    }
    
    
    //If user swipes down hide scroll view
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

