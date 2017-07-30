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
class MapVC: UIViewController, UIGestureRecognizerDelegate, LocationViewDelegate, ListViewDelegate, LocationViewTextfieldCellDelegate, PopupClickDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var qTree: QTree?
    var currentPopupView: MapPopupView?
    var titleView: TitleView?
    var locationView: LocationView?
    var listView: ListView?
    var filterListener: FilterListener?
    @IBOutlet weak var redoSearchButton: UIButton!
    var popupBeingSelelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor(red: 147/255, green: 149/255, blue: 152/255, alpha: 1)
        MTDataModel.sharedDatabaseStorage().clearPlaces()
        showListAnimation(bool: false)
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
            }
        })
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
        if !isViewLoaded { return }
        qTree = MTGooglePlacesManager.shared().qTree
        let mapRegion = mapView.region
        var useClustering = true
        
        // NEED to look up min and
//        NSMutableArray* annotationsToRemove = [self.mapView.annotations mutableCopy];
//        [annotationsToRemove removeObject:self.mapView.userLocation];
//        [annotationsToRemove removeObjectsInArray:objects];
        let minNonClusteredSpan = useClustering ? MIN(mapRegion.span.latitudeDelta, mapRegion.span.longitudeDelta) / 10
            : 0
        
        let objects = qTree?.getObjectsIn(mapRegion, minNonClusteredSpan: minNonClusteredSpan)
        var annotationsToRemove = mapView.annotations
        annotationsToRemove.remove(at: mapView.userLocation)
        annotationsToRemove.remove(objects)
        
        if let currentPopupView = currentPopupView {
            annotationsToRemove.remove(at: currentPopupView.place)
        }
        
        mapView.removeAnnotation(annotationsToRemove)
        var annotationsToAdd = objects
        annotationsToAdd.remove(mapView.annotations)
        
        mapView.addAnnotations(annotationsToAdd)
        
        
    }
    
    func drawCircleAroundCoordinate(coordinate: CLLocationCoordinate2D) {
        
    }
    
    func showListAnimation(bool: Bool) {
        
    }
    
   
    
    
    
    
    
    func setupFilterListener() {
        
    }
    
    func addGesture() {
        
    }
    
    func addBorderForRedoSearchButton() {
        redoSearchButton.layer.borderColor = UIColor(red: 238/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        redoSearchButton.layer.borderWidth = 0.5
    }
    
    func hideLocationView() {
        //duh
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
        //duh
    }
    
}
