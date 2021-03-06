//
//  ViewController.swift
//  HGCircularSlider
//
//  Created by Hamza Ghazouani on 10/19/2016.
//  Copyright (c) 2016 Hamza Ghazouani. All rights reserved.
//

import UIKit
import HGCircularSlider

extension Date {
    
}

class ClockViewController: UIViewController {
    

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var bedtimeLabel: UILabel!
    @IBOutlet weak var wakeLabel: UILabel!
    @IBOutlet weak var rangeCircularSlider: RangeCircularSlider!
    @IBOutlet weak var clockFormatSegmentedControl: UISegmentedControl!
    var timer: Timer!
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rangeCircularSlider.trackFillColor = UIColor.init(colorLiteralRed: 94.0/255.0, green: 159.0/255.0, blue: 222.0/255.0, alpha: 1.0)
        // setup O'clock
        rangeCircularSlider.startThumbImage = UIImage(named: "Opened")
        rangeCircularSlider.endThumbImage = UIImage(named: "Closed")
        
        let dayInSeconds = 24 * 60 * 60
        rangeCircularSlider.maximumValue = CGFloat(dayInSeconds)
        
        rangeCircularSlider.startPointValue = CGFloat(9 * 60 * 60)
        rangeCircularSlider.endPointValue = CGFloat(19 * 60 * 60)

        updateTexts(nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateTexts(_ sender: AnyObject?) {
        
        adjustValue(value: &rangeCircularSlider.startPointValue)
        adjustValue(value: &rangeCircularSlider.endPointValue)

        
        let bedtime = TimeInterval(rangeCircularSlider.startPointValue)
        let bedtimeDate = Date(timeIntervalSinceReferenceDate: bedtime)
        bedtimeLabel.text = dateFormatter.string(from: bedtimeDate)
        
        let wake = TimeInterval(rangeCircularSlider.endPointValue)
        let wakeDate = Date(timeIntervalSinceReferenceDate: wake)
        wakeLabel.text = dateFormatter.string(from: wakeDate)
        
        let duration = wake - bedtime
        let durationDate = Date(timeIntervalSinceReferenceDate: duration)
        dateFormatter.dateFormat = "HH:mm"
        durationLabel.text = dateFormatter.string(from: durationDate)
        dateFormatter.dateFormat = "hh:mm a"
        
        if (durationLabel.text == "00:00") {
            durationLabel.text = "24/7"
            durationLabel.isHidden = false;
        }
        else {
            durationLabel.isHidden = true
        }
    }
    
    func adjustValue(value: inout CGFloat) {
        let minutes = value / 60
        let adjustedMinutes =  ceil(minutes / 5.0) * 5
        value = adjustedMinutes * 60
    }

}

