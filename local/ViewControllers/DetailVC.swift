//
//  DetailVC.swift
//  Local
//
//  Created by Douglas Galante on 7/28/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

import Foundation

class DetailVC: UIViewController, MKMapViewDelegate {
    
    var pageIndex: Int = 0
    var place: MTPlace?
    private(set) var placeDetails: MTPlaceDetails?
    var initialScrollBottomMargin: CGFloat = 0.0

    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var hoursLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    var mapViewOverlay: UIView?
    var reviewBorder: CALayer?
    var addressBorder: CALayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        addBordersForRatingView()
    }
    
    func addBordersForRatingView() {
        let upperBorder = CALayer()
        upperBorder.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1).cgColor
        upperBorder.frame = CGRect(x: 0, y: 0, width: ratingView.frame.width, height: 1.5)
        ratingView.layer.addSublayer(upperBorder)
        let bottomBorder = CALayer()
        bottomBorder.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1).cgColor
        bottomBorder.frame = CGRect(x: 0, y: ratingView.bounds.size.height - 1.5, width: ratingView.frame.width, height: 1.5)
        ratingView.layer.addSublayer(bottomBorder)
    }
    
    func setup() {
        MTProgressHUD.shared().dismiss()
        MTProgressHUD.shared().show(on: view, percentage: false)
        hideUI()
        self.mainImageView.image = nil
//        getYelpRating()
        
        getDetails(place!) { (largestPhoto, details) in
            self.placeDetails = details
            self.showDetails()
            guard let photoRef = largestPhoto?.reference else { return }
            let stringUrl: String = "https://maps.googleapis.com/maps/api/place/photo?&maxheight=\(1600)&photoreference=\(photoRef)&key=\(Constants.googleMapAPIKey)"
            let url = URL(string: stringUrl)
            if let url = url {
                self.mainImageView.setImageWith(url, completed: { (image, error, cacheType) in
                    self.mainImageView.alpha = 0.0
                    self.mainImageView.image = image
                    self.mainImageView.contentMode = .scaleToFill
                    UIView.animate(withDuration: 0.5, animations: {() -> Void in
                        self.mainImageView.alpha = 1.0
                    })
                    MTProgressHUD.shared().dismiss()
                })
            }
        }
    }
    
    func showDetails() {
        if let place = place {
            detailsLabel.text = place.getDetailsString()
            titleLabel.text = place.name
        }
        
        let reviews = self.placeDetails?.reviewsSet()?.allObjects
        if let reviews = reviews {
            if reviews.count > 0 {
                let review: MTPlaceReview? = reviews.first as? MTPlaceReview
                reviewTextView.text = review?.text
            }
        }
        
        let sizeThatFitsReviewTextView = reviewTextView.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width - 24, height: CGFloat(MAXFLOAT)))
        addressTextView.text = ""
        if let formattedAddress = placeDetails?.formattedAddress {
            addressTextView.text = addressTextView.text + formattedAddress + "\n"
        }
        if let localPhone = placeDetails?.localPhone {
            addressTextView.text = addressTextView.text + localPhone + "\n"
        }
        if let website = placeDetails?.website {
            addressTextView.text = addressTextView.text + website
        }
        let sizeThatFitsAddressTextView = addressTextView.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width - 24, height: CGFloat(MAXFLOAT)))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double((Int64)(0.7 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            self.contentHeight.constant = self.addressTextView.frame.origin.y + sizeThatFitsReviewTextView.height + sizeThatFitsAddressTextView.height + self.mapView.bounds.size.height - 50 * 1.2
        })
        
        let gregorian = Calendar(identifier: .gregorian)
        let comps = gregorian.dateComponents([.weekday], from: Date())
        let weekday: Int = comps.weekday ?? 0
        let openPeriods = self.placeDetails?.openingHoursPeriods
        let predicate = NSPredicate(format: "periodNumber == %d", weekday)
        var filteredPeriods = openPeriods?.filter { predicate.evaluate(with: $0) }
        
        //Sometimes opening time is devided into 2 periods like from 8am to 3pm and from 3pm to 22pm
        //That's why we need to sort. The latest period should come after earlier period
        filteredPeriods = filteredPeriods?.sorted { $0.openTime! < $1.openTime! }
        if let filteredPeriods = filteredPeriods {
            if filteredPeriods.count > 0 {
                let firstPeriod = filteredPeriods.first
                var lastPeriod = filteredPeriods.first
                if filteredPeriods.count > 1 {
                    lastPeriod = filteredPeriods.last
                }
                let periodText: String? = "\(firstPeriod!.openPmTime())-\(lastPeriod!.closePmTime())"
                hoursLabel.text = periodText
            }
        }
        setupMap()
        showUI()
    }

    
    func getDetails(_ place: MTPlace, completion: @escaping (MTPhoto?, MTPlaceDetails?) -> Void ) {
        let placeDetails: MTPlaceDetails? = MTDataModel.sharedDatabaseStorage().getPlaceDetials(forId: place.placeId)
        if placeDetails != nil {
            completion(placeDetails?.getLargestPhoto(), placeDetails)
        }
        else {
            let request = MTGetPlaceDetailRequest()
            request.placeId = place.placeId
            
            request.completionBlock = { request, response in
                if let response = response, let request = request {
                    if response.isSuccess() {
                        let detailsResponse: MTGetPlaceDetailsResponse? = (response as? MTGetPlaceDetailsResponse)
                        let placeDetails: MTPlaceDetails? = detailsResponse?.placeDetails
                        let largestPhoto: MTPhoto? = placeDetails?.getLargestPhoto()
                        completion(largestPhoto, placeDetails)
                    }
                    else {
                        completion(nil, nil)
                    }
                    request.run()
                }
            }
        }
    }
    
    func hideUI() {
        contentView.alpha = 0.0
    }
    
    func showUI() {
        UIView.animate(withDuration: 0.5, animations: {
            self.contentView.alpha = 1.0
        }, completion: { success in
            self.reviewTextView.tintColor = UIColor.red
            self.reviewTextView.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.red]
            self.addressTextView.tintColor = UIColor.red
            self.addressTextView.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.red]
        })
    }
    
    func setupMap() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double((Int64)(0.4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            self.mapView.isUserInteractionEnabled = false
            self.mapView.delegate = self
            // this sets the zoom level, a smaller value like 0.02
            // zooms in, a larger value like 80.0 zooms out
            let location = CLLocationCoordinate2D(latitude: Double((self.placeDetails?.lat)!), longitude: Double((self.placeDetails?.lon)!))
            let coordSpan = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
            let myRegion: MKCoordinateRegion = MKCoordinateRegion(center: location, span: coordSpan)
            
            
            // move the map to our location
            self.mapView?.setRegion(myRegion, animated: false)
            if (self.mapViewOverlay != nil) {
                self.mapViewOverlay?.removeFromSuperview()
            }
            self.mapViewOverlay = UIView(frame: CGRect(x: 0, y: 0, width: self.mapView.bounds.size.width, height: self.mapView.bounds.size.height))
            self.mapViewOverlay?.backgroundColor = UIColor(red: 0.55, green: 0.55, blue: 0.55, alpha: 0.6)
            self.mapView?.addSubview(self.mapViewOverlay!)
            //annotation
            let annot = TGAnnotation(coordinate: CLLocationCoordinate2DMake(Double(self.place!.lat!), Double(self.place!.lon!)))
            self.mapView?.addAnnotation(annot!)
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let myPinAnnotationIdentifier: String = "Pin"
        let pinView: MKPinAnnotationView? = (self.mapView?.dequeueReusableAnnotationView(withIdentifier: myPinAnnotationIdentifier) as? MKPinAnnotationView)
        if let pinView = pinView {
            //pinView.center = CGPoint(x: pinView.frame.maxX / 2, y: pinView.frame.maxY)
            pinView.centerOffset = CGPoint (x: 0, y: pinView.frame.maxY / 2)
            pinView.image = #imageLiteral(resourceName: "LocalPin")
            return pinView
        } else {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: myPinAnnotationIdentifier)
            annotationView.centerOffset = CGPoint (x: 0, y: annotationView.frame.maxY / 2)
            let pinImage = #imageLiteral(resourceName: "LocalPin")
            annotationView.image = pinImage
            return annotationView
        }

    }

    
}
