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
    @IBOutlet weak var ratingNumberLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingIconLabel: UILabel!
    @IBOutlet weak var ratingIconLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var ratingIconAndLabelPadding: NSLayoutConstraint!
    @IBOutlet weak var ratingSourceLabel: UILabel!
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
        weak var weakSelf = self
        self.mainImageView.image = nil
        getYelpRating()
        getDetails(place!, completion: {(_ largestPhoto: MTPhoto, _ details: MTPlaceDetails) -> Void in
            self.placeDetails = details
            self.showDetails()
            let strinUrl: String = "https://maps.googleapis.com/maps/api/place/photo?&maxheight=\(1600)&photoreference=\(largestPhoto.reference)&key=\(Constants.googleMapAPIKey)"
            self.mainImageView.setImageWith(URL(string: strinUrl), completed: {(_ image: UIImage, _ error: Error?, _ cacheType: SDImageCacheType) -> Void in
                self.mainImageView.alpha = 0.0
                self.mainImageView.image = image
                self.mainImageView.contentMode = .scaleToFill
                UIView.animate(withDuration: 0.5, animations: {() -> Void in
                    self.mainImageView.alpha = 1.0
                })
                MTProgressHUD.shared().dismiss()
            } as! SDWebImageCompletedBlock)
        } as! (MTPhoto?, MTPlaceDetails?) -> Void)
    }
    
    func showDetails() {
        detailsLabel.text = place?.getDetailsString()
        titleLabel.text = place?.name
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
        print("AddressHeight: \(sizeThatFitsAddressTextView.height)")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(0.7 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
            //print("HEIGHTOFCONTENT: \(reviewTextView.frame.origin.y + sizeThatFitsReviewTextView.height + sizeThatFitsAddressTextView.height + mapView.bounds?.size?.height)")
            self.contentHeight.constant = self.addressTextView.frame.origin.y + sizeThatFitsReviewTextView.height + sizeThatFitsAddressTextView.height + self.mapView.bounds.size.height - 50 * 1.2
        })
        
        let gregorian = Calendar(identifier: .gregorian)
        let comps = gregorian.dateComponents([.weekday], from: Date())
        let weekday: Int? = comps.weekday
        let openPeriods = self.placeDetails?.openingHoursPeriods
        let predicate = NSPredicate(format: "periodNumber == %d", weekday!)
        var filteredPeriods: [Any] = openPeriods!.filter { predicate.evaluate(with: $0) }
        //Sometimes opening time is devided into 2 periods like from 8am to 3pm and from 3pm to 22pm
        //That's why we need to sort. The latest period should come after earlier period
        let descriptor = NSSortDescriptor(key: "openTime", ascending: true)
        filteredPeriods = (filteredPeriods as NSArray).sortedArray(using: [descriptor])
        if filteredPeriods.count > 0 {
            let firstPeriod: MTOpeningHourPeriod? = filteredPeriods.first as? MTOpeningHourPeriod
            var lastPeriod: MTOpeningHourPeriod? = filteredPeriods.first as? MTOpeningHourPeriod
            if filteredPeriods.count > 1 {
                lastPeriod = filteredPeriods.last as? MTOpeningHourPeriod
            }
            let periodText: String? = "\(firstPeriod!.openPmTime())-\(lastPeriod!.closePmTime())"
            hoursLabel.text = periodText
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
            request.completionBlock = {(_ request: SDRequest, _ response: SDResult) -> Void in
                if response.isSuccess() {
                    let detailsResponse: MTGetPlaceDetailsResponse? = (response as? MTGetPlaceDetailsResponse)
                    let placeDetails: MTPlaceDetails? = detailsResponse?.placeDetails
                    let largestPhoto: MTPhoto? = placeDetails?.getLargestPhoto()
                    completion(largestPhoto, placeDetails)
                }
                else {
                    completion(nil, nil)
                }
            } as! SDRequestCompletionBlock
            request.run()
        }
    }
    
    func getYelpRating() {
        ratingLabel.alpha = 0.0
        weak var weakSelf = self
        MTYelpManager.shared().getYelpPlace(matchingGooglePlace: place, completion: {(_ success: Bool, _ yelpPlace: MTYelpPlace, _ error: Error?) -> Void in
            weakSelf!.showRating(yelpPlace)
        } as! YelpCompletion)
    }
    
    func showRating(_ yelpPlace: MTYelpPlace) {
        if yelpPlace != nil {
            ratingNumberLabel.text = String(format: "%.1f", CFloat(yelpPlace.rating!))
            ratingLabel.attributedText = yelpPlace.ratingString()
            ratingIconLabel.text = ""
            ratingSourceLabel.text = "YELP"
        }
        else {
            ratingNumberLabel.text = String(format: "%.1f", CFloat(place!.rating!))
            ratingLabel.attributedText = place?.ratingString()
            ratingIconLabelWidth.constant = 0
            ratingIconAndLabelPadding.constant = 4
            ratingSourceLabel.text = "GOOGLE"
        }
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.ratingLabel.alpha = 1.0
        })
    }
    
    func hideUI() {
        contentView.alpha = 0.0
    }
    
    func showUI() {
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.contentView.alpha = 1.0
        }, completion: {(_ finished: Bool) -> Void in
            //[weakSelf postProcessTextViewLinksStyle:weakSelf.addressTextView];
            self.reviewTextView.tintColor = UIColor.red
            self.reviewTextView.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.red]
            self.addressTextView.tintColor = UIColor.red
            self.addressTextView.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.red]
        })
    }
    
    func setupMap() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(0.4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
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
    
    // MARK: - MKMap View methods
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation.coordinate == mapView.centerCoordinate {
//            return nil
//        }
        let MyPinAnnotationIdentifier: String = "Pin"
        let pinView: MKPinAnnotationView? = (self.mapView?.dequeueReusableAnnotationView(withIdentifier: MyPinAnnotationIdentifier) as? MKPinAnnotationView)
        if pinView == nil {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: MyPinAnnotationIdentifier)
            annotationView.image = UIImage(named: "ic_pin")
            return annotationView
        }
        else {
            pinView?.image = UIImage(named: "ic_pin")
            return pinView!
        }
        return nil
    }

    
}
