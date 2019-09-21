//
//  StabilityNetMapViewController.swift
//  TGK
//
//  Created by Jay Park on 6/23/19.
//  Copyright © 2019 TheGivingKitchen. All rights reserved.
//

import UIKit
import MapKit

class StabilityNetMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var stabilityNetResources:[SafetyNetResourceModel] = []
    
    let locationManager = CLLocationManager()
    
    let mileRadius = CLLocationDistance(24140) //15 miles for now
    
    var searchViewController:StabilityNetSearchViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapTapGesture = UITapGestureRecognizer(target: self, action: #selector(mapTapGesture(_:)))
        self.mapView.addGestureRecognizer(mapTapGesture)
        
        if let userLocation = self.locationManager.location?.coordinate {
            self.centerMapOnLocation(location: userLocation)
            self.addRadiusCircle(location: userLocation)
        }
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        self.addAnnotationsToMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addBottomSheetView()
    }
    
    func addBottomSheetView(scrollable: Bool? = true) {
        self.searchViewController = UIStoryboard(name: "SafetyNet", bundle: nil).instantiateViewController(withIdentifier: "StabilityNetSearchViewControllerId") as? StabilityNetSearchViewController
        
        self.addChildViewController(self.searchViewController)
        self.view.addSubview(self.searchViewController.view)
        self.searchViewController.didMove(toParentViewController: self)
        
        let height = view.frame.height - self.searchViewController.topStickyPoint
        let width  = view.frame.width
        self.searchViewController.view.frame = CGRect(x: 0, y: self.searchViewController.bottomStickyPoint, width: width, height: height)
        
        self.searchViewController.delegate = self
    }
    
    func addAnnotationsToMap() {
//TODO this should only be turned on if we add a location based feature
//        let geoCoder = CLGeocoder()
//        if let location = locationManager.location {
//            geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
//                let circularRegion = CLCircularRegion(center: location.coordinate, radius: self.mileRadius, identifier: "aroundUser")
//                var resourcesInRegion = [SafetyNetResourceModel]()
//                for resource in self.stabilityNetResources {
//                    if let resourceCoordinates = resource.location {
//                        if circularRegion.contains(resourceCoordinates) {
//                            resourcesInRegion.append(resource)
//                        }
//                    }
//                }
//                self.mapView.addAnnotations(resourcesInRegion)
//            }
//        }
        
        self.mapView.addAnnotations(self.stabilityNetResources)
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, self.mileRadius, self.mileRadius * 1.5)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addRadiusCircle(location: CLLocationCoordinate2D){
        let circle = MKCircle(center: location, radius: self.mileRadius)
        self.mapView.add(circle)
    }
    
    @objc func mapTapGesture(_ recognizer:UITapGestureRecognizer) {
        self.searchViewController.moveToBottomStickyPoint()
    }

}

//MARK: MKMapViewDelegate
extension StabilityNetMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.tgkBlue
            circle.fillColor = UIColor.tgkLightTeal.withAlphaComponent(0.3)
            circle.lineWidth = 1
            return circle
        } else {
            return MKPolylineRenderer()
        }
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        self.searchViewController.moveToBottomStickyPoint()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let identifier = "mapAnnotationReuseId"
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView.annotation = annotation
            return annotationView
        } else {
            let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:identifier)
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
            let rightAccessoryButton = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = rightAccessoryButton
            
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        //TODO this is pretty inefficient searching. Could consider creating custom annotation view and cache the model there
        let possibleMatchedModel = self.stabilityNetResources.filter { (resourceModel) -> Bool in
            if resourceModel.name == view.annotation?.title {
                return true
            }
            return false
            }.first
        
        if let foundModel = possibleMatchedModel {
            let detailSheet = SafetyNetDetailSheetViewController.instantiateWith(safetyNetResource: foundModel)
            self.tabBarController?.present(detailSheet, animated:true)
        }
    }
    
}

//MARK: StabilityNetSearchViewControllerDelegate
extension StabilityNetMapViewController:StabilityNetSearchViewControllerDelegate {
    func stabilityNetSearchViewControllerDidFind(resources: [SafetyNetResourceModel]) {
        self.mapView.removeAnnotations(self.stabilityNetResources)
        self.stabilityNetResources = resources
        self.addAnnotationsToMap()
    }
    
    func stabilityNetSearchViewControllerDidSelect(resource: SafetyNetResourceModel) {
        if let location = resource.location {
            let offsetLocation = CLLocationCoordinate2D(latitude: location.latitude - self.mapView.region.span.latitudeDelta * 0.30, longitude: location.longitude)
            
            self.mapView.setCenter(offsetLocation, animated: true)
            
            let possibleMatchedAnnotation = self.mapView.annotations.filter { (annotation) -> Bool in
                if resource.name == annotation.title {
                    return true
                }
                return false
                }.first
            if let foundAnnotation = possibleMatchedAnnotation {
                self.mapView.selectAnnotation(foundAnnotation, animated: true)
            }
        }
        
        let detailSheet = SafetyNetDetailSheetViewController.instantiateWith(safetyNetResource: resource)
        self.tabBarController?.present(detailSheet, animated: true)
    }
}
