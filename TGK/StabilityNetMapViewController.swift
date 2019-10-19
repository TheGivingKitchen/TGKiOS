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
    var userLocationButton: UIButton!
    
    var stabilityNetResources:[SafetyNetResourceModel] = []
    
    let locationManager = CLLocationManager()
    
    private let oneMileInMeters = CLLocationDistance(1609)
    
    var searchViewController:StabilityNetSearchViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapTapGesture = UITapGestureRecognizer(target: self, action: #selector(mapTapGesture(_:)))
        self.mapView.addGestureRecognizer(mapTapGesture)
        
        self.addBottomSheetView()
        self.addUserLocationButton()
        
        if let _ = self.locationManager.location?.coordinate {
            self.centerOnUserLocation()
            //self.addRadiusCircle(location: userLocation)
        }
        else {
            let atlanta2dCoordinates = CLLocationCoordinate2D(latitude: 33.659, longitude: -84.358)
            self.centerMapOnLocation(location: atlanta2dCoordinates)
        }
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        self.addAnnotationsToMap()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func addUserLocationButton() {
        self.userLocationButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60.0, height: 60.0))
        self.userLocationButton.setImage(UIImage(named: "iconUserLocationPointer"), for: .normal)
        self.userLocationButton.addTarget(self, action: #selector(self.userLocationButtonPressed(_:)), for: .touchUpInside)
        self.userLocationButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.userLocationButton)
        
        self.userLocationButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16.0).isActive = true
        self.userLocationButton.bottomAnchor.constraint(equalTo: self.searchViewController.view.topAnchor, constant: -16).isActive = true
        self.userLocationButton.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        self.userLocationButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
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
    
    func centerOnUserLocation() {
        if let userLocation = self.locationManager.location?.coordinate {

            self.centerMapOnLocation(location: userLocation, mileRadius: 15)
            self.userLocationButton.isHidden = true
        }
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D, mileRadius:CLLocationDistance = 25.0) {
        
        let baseCoordinateRegion = MKCoordinateRegionMakeWithDistance(location, self.oneMileInMeters * mileRadius, self.oneMileInMeters * mileRadius)
        
        let offsetLocation = CLLocationCoordinate2D(latitude: location.latitude - baseCoordinateRegion.span.latitudeDelta * 0.3, longitude: location.longitude)
        
        let offsetCoordinateRegion = MKCoordinateRegionMakeWithDistance(offsetLocation, self.oneMileInMeters * mileRadius, self.oneMileInMeters * mileRadius)

        mapView.setRegion(offsetCoordinateRegion, animated: true)
    }
    
    func addRadiusCircle(location: CLLocationCoordinate2D){
        let circle = MKCircle(center: location, radius: self.oneMileInMeters)
        self.mapView.add(circle)
    }
    
    @objc func mapTapGesture(_ recognizer:UITapGestureRecognizer) {
        self.searchViewController.moveToBottomStickyPoint()
    }
    
    @objc func userLocationButtonPressed(_ sender: Any) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            let locationWarmingVC = LocationWarmingViewController.instantiateWith(delegate: self)
            
            self.tabBarController?.present(locationWarmingVC, animated: true)
            break
            
        case .restricted, .denied:
            self.showLocationServicesDeniedAlert()
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            self.centerOnUserLocation()
            break
        }
    }
    
    func showLocationServicesDeniedAlert() {
        let alertController = UIAlertController(title: "Enable Location Services",
                                                message: "Location services have been turned off. Please enable them in Settings > TGK > Location to continue.",
                                                preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Open Settings", style: .default) { (alertAction) in
            if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: { (success) in
                })
            }
        }
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
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
        self.userLocationButton.isHidden = false
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
            annotationView.pinTintColor = UIColor.tgkOrange
            let rightAccessoryButton = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = rightAccessoryButton
            
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let calloutTapGestureRec = UITapGestureRecognizer(target: self, action: #selector(handleAnnotationCalloutTapped(sender:)))
        view.addGestureRecognizer(calloutTapGestureRec)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        self.presentDetailSheetForSelectedAnnotationView(annotationView: view)
    }
    
    @objc private func handleAnnotationCalloutTapped(sender:UITapGestureRecognizer) {
        guard let annotation = sender.view as? MKAnnotationView else {
            return
        }
        self.presentDetailSheetForSelectedAnnotationView(annotationView: annotation)
    }
    
    private func presentDetailSheetForSelectedAnnotationView(annotationView: MKAnnotationView) {
        //TODO this is pretty inefficient searching. Could consider creating custom annotation view and cache the model there
        let possibleMatchedModel = self.stabilityNetResources.filter { (resourceModel) -> Bool in
            if resourceModel.name == annotationView.annotation?.title {
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
            self.centerMapOnLocation(location: location, mileRadius: 5)
            
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

//MARK: LocationWarmingViewControllerDelegate
extension StabilityNetMapViewController:LocationWarmingViewControllerDelegate {
    func locationWarmingViewControllerDidAccept(viewController: LocationWarmingViewController) {
        viewController.dismiss(animated: true)
        
        self.locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationWarmingViewControllerDidDecline(viewController: LocationWarmingViewController) {
        viewController.dismiss(animated: true)
    }
}

extension StabilityNetMapViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            break
            
        case .restricted, .denied:
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            self.centerOnUserLocation()
            break
        }
    }
}
