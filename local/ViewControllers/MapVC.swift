//
//  MapVC.swift
//  Local
//
//  Created by Douglas Galante on 7/29/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

let MIN_CLUSTERING_SPAN = 0.02
class MapVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var qTree: QTree?
    var currentPopupView: MapPopupView?
    var titleView: TitleView?
    var locationView: LocationView?
    var listView: ListView?
    var filterListener: FilterListener = FilterListener()
    @IBOutlet weak var redoSearchButton: UIButton!
    var popupBeingSelelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor(red: 147/255, green: 149/255, blue: 152/255, alpha: 1)
        MTDataModel.sharedDatabaseStorage().clearPlaces()
        showList(animated: false)
        getLocation()
        addTitleView()
        setupFilterListener()
        addGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBorderForRedoSearchButton()
    }
    
    func getLocation() {
        MTLocationManager.shared().getLocation { success, errorMessage, coordinate in
            MTProgressHUD.shared().dismiss()
            if success {
                self.getPlacesAtLocation(coordinate: coordinate)
                self.drawCircleAroundCoordinate(coordinate: coordinate)
                self.setZoomLevelWithCenter(coordinate: coordinate)
            } else {
                MTAlertBuilder.showAlert(in: self, message: errorMessage, delegate: nil)
            }
        }
    }
    
    func setZoomLevelWithCenter(coordinate: CLLocationCoordinate2D) {
        var region = MKCoordinateRegion()
        region.center.latitude = coordinate.latitude
        region.center.longitude = coordinate.longitude
        region.span.latitudeDelta = 0.06
        region.span.longitudeDelta = 0.06
        region = self.mapView.regionThatFits(region)
        self.mapView.setRegion(region, animated: true)
    }
    
    func getPlacesAtLocation(coordinate: CLLocationCoordinate2D) {
        let manager = MTGooglePlacesManager.shared()
        self.qTree = nil
        manager?.query(coordinate, radius: 1000, completion: { (success, places, error) in
            if success {
                self.reloadAnnotations()
                if places?.count == 0 {
                    self.presentAlert(with: "There were no places found matching your search criteria.")
                }
            }
        })
    }
    
    func presentAlert(with message: String) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let alert = UIAlertController(title: "No Places Found", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getTappedAnnotations(touch: UITouch) -> [MKAnnotationView] {
        var tappedAnnotations: [MKAnnotationView] = []
        for annotation in self.mapView.annotations {
            let view = self.mapView.view(for: annotation)
            let location = touch.location(in: view)
            if let view = view {
                if view.bounds.contains(location) {
                    tappedAnnotations.append(view)
                }
            }
        }
        return tappedAnnotations
    }
    
    
    func reloadAnnotations() {
        MTReloadAnnotations.reloadAnnotations(self.isViewLoaded, self.mapView, self.qTree)
    }

    


    
    func addBorderForRedoSearchButton() {
        redoSearchButton.layer.borderColor = UIColor(red: 238/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        redoSearchButton.layer.borderWidth = 0.5
    }
    
   

}

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        reloadAnnotations()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: QCluster.self) {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ClusterAnnotationView.reuseId()) as? ClusterAnnotationView
            if annotationView != nil {
                annotationView = ClusterAnnotationView(cluster: annotation as! QCluster)
            }
            annotationView?.cluster = annotation as! QCluster
            return annotationView
        } else if (annotation.isKind(of: MTPlace.self)) {
            let defaultPinID = "com.local.food"
            let pinView = MKImageAnnotationView(annotation: annotation, reuseIdentifier: defaultPinID)
            return pinView
        } else {
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if popupBeingSelelected { return }
        let annotation = view.annotation
        if let annotation = annotation {
            if annotation.isKind(of: QCluster.self) {
                let cluster = annotation as! QCluster
                let span = MKCoordinateSpanMake(2.5 * cluster.radius, 2.5 * cluster.radius)
                let region = MKCoordinateRegionMake(cluster.coordinate, span)
                mapView.setRegion(region, animated: true)
            } else {
                let cord = view.annotation?.coordinate
                if let cord = cord {
                    let pinCenter = CLLocationCoordinate2DMake(cord.latitude, cord.longitude)
                    mapView.setCenter(pinCenter, animated: true)
                    removePopup()
                    currentPopupView = Bundle.main.loadNibNamed("MapPopupView", owner: self, options: nil)?[0] as? MapPopupView
                    if let currentPopupView = currentPopupView {
                        currentPopupView.delegate = self
                        currentPopupView.pinViewFrame = view.frame
                        currentPopupView.place = annotation as! MTPlace
                        view.addSubview(currentPopupView)
                    }
                }
            }
        }
    }
    
    func removePopup() {
        currentPopupView?.removeFromSuperview()
        currentPopupView = nil
        mapView.selectedAnnotations = []
    }
    
    //MARK: Overlays
    
    func drawCircleAroundCoordinate(coordinate: CLLocationCoordinate2D) {
        let circle = MKCircle(center: coordinate, radius: 1000 + 700)
        mapView.add(circle)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKCircle.self) {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor(red: 147/255, green: 149/255, blue: 152/255, alpha: 1)
            circle.lineWidth = 1.0
            return circle
        } else {
            return MKOverlayRenderer()
        }
    }
    
    
    //MARK: Map Tap Gestures
    
    func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.delegate = self
        mapView.addGestureRecognizer(tapGesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return getTappedAnnotations(touch: touch).count == 0
    }
    
    func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            if popupBeingSelelected {
                removePopup()
            } else if let currentPopupView = currentPopupView {
                didSelectItem(for: currentPopupView.place)
            }
        }
    }
    
    @IBAction func updatePlacesInCurrentArea(_ sender: Any) {
        removePopup()
        let centerCoordinate = mapView.centerCoordinate
        updatePlaces(coordinate: centerCoordinate)
    }
    
    func updatePlaces(coordinate: CLLocationCoordinate2D) {
        mapView.removeOverlays(mapView.overlays)
        getPlacesAtLocation(coordinate: coordinate)
        drawCircleAroundCoordinate(coordinate: coordinate)
        setZoomLevelWithCenter(coordinate: coordinate)
    }
    
}



extension MapVC: TitleViewDelegate {
    
    func addTitleView() {
        self.titleView = Bundle.main.loadNibNamed("TitleView", owner: self, options: nil)?[0] as? TitleView
        self.titleView?.delegate = self
        self.navigationItem.titleView = self.titleView
        let item = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(self.logOut))
        self.navigationItem.setLeftBarButton(item, animated: true)
    }
    
    func logOut() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.auth.signOut()
    }
    
    
    func titleViewClicked(_ isRevealing: Bool) {
        if isRevealing {
            showLocationView()
        } else {
            hideLocationView()
        }
    }
    
    func showLocationView() {
        locationView = Bundle.main.loadNibNamed("LocationView", owner: self, options: nil)?[0] as? LocationView
        if let locationView = locationView {
            locationView.delegate = self
            locationView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 0)
            view.addSubview(locationView)
            
            UIView.animate(withDuration: 0.5) {
                locationView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
            }
        }
    }
    
    
    //MARK: Right Navigtion Item
    
    func showListNavigationItem() {
        let item = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_list_item"), style: .plain, target: self, action: #selector(showListByClickingNavigationItem))
        let color = UIColor(red: 147/255, green: 149/255, blue: 152/255, alpha: 1)
        let font = UIFont(name: "FontAwesome", size: 16.0)!
        let attributes: [String : Any] = [ NSForegroundColorAttributeName : color,
                           NSFontAttributeName : font ]
        item.setTitleTextAttributes(attributes, for: .normal)
        self.navigationItem.rightBarButtonItem = item
    }
    
    func showMapNavigationItem() {
        let item = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_map_item"), style: .plain, target: self, action: #selector(showMap))
        let color = UIColor(red: 147/255, green: 149/255, blue: 152/255, alpha: 1)
        let font = UIFont(name: "FontAwesome", size: 16.0)!
        let attributes: [String : Any] = [ NSForegroundColorAttributeName : color,
                                           NSFontAttributeName : font ]
        item.setTitleTextAttributes(attributes, for: .normal)
        self.navigationItem.rightBarButtonItem = item
    }
    
    //MARK: Switching between list and map
    func showListByClickingNavigationItem() {
        showList(animated: true)
    }
    
    func showList(animated: Bool) {
        listView = Bundle.main.loadNibNamed("ListView", owner: self, options: nil)?[0] as? ListView
        if let listView = listView {
            listView.delegate = self
            listView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
            view.addSubview(listView)
        }
        
        if animated {
            listView?.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.listView?.alpha = 1
            })
        }
        
        showMapNavigationItem()
    }
    
    func showMap() {
        UIView.animate(withDuration: 0.5, animations: { 
            self.listView?.alpha = 0.0
        }) { (success) in
            self.listView?.removeFromSuperview()
        }
        
        showListNavigationItem()
    }
}

extension MapVC: ListViewDelegate {
    
    func didSelectItem(for place: MTPlace) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let pageController = main.instantiateViewController(withIdentifier: "MTPageContainerViewController") as? MTPageContainerViewController
        
        if let pageController = pageController {
            pageController.title = place.name
            pageController.place = place
            navigationController?.pushViewController(pageController, animated: true)
            removePopup()
            popupBeingSelelected = false
        }
        
    }
    
}

extension MapVC: LocationViewTextfieldCellDelegate {
    
    func placeSelected(_ placeId: String) {
        let request = MTGetPlaceDetailRequest.request(withOwner: self) as? MTGetPlaceDetailRequest
        if let request = request {
            request.placeId = placeId
            request.completionBlock = { request, response in
                if let response = response {
                    if response.isSuccess() {
                        let detailsResponse: MTGetPlaceDetailsResponse? = response as? MTGetPlaceDetailsResponse
                        if let placeDetails = detailsResponse?.placeDetails {
                            if let lat = placeDetails.lat?.floatValue, let lon = placeDetails.lon?.floatValue {
                            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon))
                            self.updatePlaces(coordinate: coordinate)
                            }
                        }
                    }
                }
            }
            request.run()
        }
    }
    
    func currentPlaceSelected() {
        updatePlaces(coordinate: MTLocationManager.shared().lastLocation)
    }
    
    func setupFilterListener() {
        self.filterListener.onKeyWordUpdatedHandler = {
            self.removePopup()
            self.updatePlaces(coordinate: MTLocationManager.shared().lastUsedLocation)
        }
    }
    
}

extension MapVC: LocationViewDelegate {
    
    func hideLocationView() {
        titleView?.collapse()
        UIView.animate(withDuration: 0.5, animations: {
            self.locationView?.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 0)
        }) { success in
            self.locationView?.removeFromSuperview()
        }
    }

}

extension MapVC: PopupClickDelegate {
    
    func popClicked(for place: MTPlace!) {
        didSelectItem(for: place)
    }
    
    func popupTouchBegan() {
        popupBeingSelelected = true
    }
    
}


