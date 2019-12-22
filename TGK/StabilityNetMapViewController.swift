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
        
        self.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        self.mapView.register(StabilityNetClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
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
    
    func centerMapOnLocation(location: CLLocationCoordinate2D, zoomScale: Double) {
        let offsetLocation = CLLocationCoordinate2D(latitude: location.latitude - self.mapView.region.span.latitudeDelta * 0.05, longitude: location.longitude)
        
        let newCoordinateRegion = MKCoordinateRegionMakeWithDistance(offsetLocation, self.mapView.currentRadius() * zoomScale, self.mapView.currentRadius() * zoomScale)
        
        self.mapView.setRegion(newCoordinateRegion, animationDuration: 0.3)
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D, mileRadius:CLLocationDistance = 25.0) {
        
        let baseCoordinateRegion = MKCoordinateRegionMakeWithDistance(location, self.oneMileInMeters * mileRadius, self.oneMileInMeters * mileRadius)
        
        let offsetLocation = CLLocationCoordinate2D(latitude: location.latitude - baseCoordinateRegion.span.latitudeDelta * 0.6, longitude: location.longitude)
        
        let offsetCoordinateRegion = MKCoordinateRegionMakeWithDistance(offsetLocation, self.oneMileInMeters * mileRadius, self.oneMileInMeters * mileRadius)

        self.mapView.setRegion(offsetCoordinateRegion, animationDuration: 0.3)
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
        switch annotation {
        case is MKUserLocation:
            return nil //return nil so map view draws "blue dot" for standard user location
        case is MKClusterAnnotation:
            let clusterAnnotation = self.mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier, for: annotation)
            clusterAnnotation.displayPriority = .required
            return clusterAnnotation
        case is SafetyNetResourceModel:
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation)
            annotationView.clusteringIdentifier = "stabilityNetClusterId"
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
            
            let rightAccessoryButton = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = rightAccessoryButton
            annotationView.displayPriority = .required
            return annotationView
        default:
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //if its a plain pin, show the callout and add a gesture recognizer to make the overall callout tappable
        if view is MKMarkerAnnotationView {
            let calloutTapGestureRec = UITapGestureRecognizer(target: self, action: #selector(handleAnnotationCalloutTapped(sender:)))
            view.addGestureRecognizer(calloutTapGestureRec)
        }
        //if its a clustered pin
        else if view is StabilityNetClusterAnnotationView,
            let annotation = view.annotation as? MKClusterAnnotation {
            
            //check if the cluster is actually a cluster of items with the same lat/long
            let firstAnnotationCoordinate = annotation.memberAnnotations[0].coordinate
            let filteredAnnotations = annotation.memberAnnotations.filter { (annotationMember) -> Bool in
                if annotationMember.coordinate.latitude == firstAnnotationCoordinate.latitude && annotationMember.coordinate.longitude == firstAnnotationCoordinate.longitude {
                    return true
                }
                return false
            }
            //true case - it's multiple locations with same lat/long in a cluster
            if filteredAnnotations.count == annotation.memberAnnotations.count {
                let alertController = UIAlertController(title: nil, message: "There are multiple locations here. Please select one", preferredStyle: .actionSheet)
                for memberAnnotation in annotation.memberAnnotations {
                    let action = UIAlertAction(title: memberAnnotation.title ?? "", style: .default) { (action) in
                        DispatchQueue.main.async {
                            self.presentDetailSheetForSelectedAnnotation(annotation: memberAnnotation)
                        }
                    }
                    alertController.addAction(action)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                alertController.view.tintColor = UIColor.tgkBlue
                self.tabBarController?.present(alertController, animated:true)
            }
            //false case - it's a true cluster annotation. Center it and zoom in
            else {
                self.centerMapOnLocation(location: annotation.coordinate, zoomScale: 0.3)
            }
            //Force deselect the clustered pin so it can be tapped again
            self.mapView.deselectAnnotation(annotation, animated: false)
        }
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
        if let annotation = annotationView.annotation {
            self.presentDetailSheetForSelectedAnnotation(annotation: annotation)
        }
    }
    
    private func presentDetailSheetForSelectedAnnotation(annotation: MKAnnotation) {
        //TODO this is pretty inefficient searching. Could consider creating custom annotation view and cache the model there
        let possibleMatchedModel = self.stabilityNetResources.filter { (resourceModel) -> Bool in
            if resourceModel.name == annotation.title {
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
            self.centerMapOnLocation(location: location, mileRadius: 1)
            
            let possibleMatchedAnnotation = self.mapView.annotations.filter { (annotation) -> Bool in
                if resource.name == annotation.title {
                    return true
                }
                return false
                }.first
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                if let foundAnnotation = possibleMatchedAnnotation {
                    self.mapView.selectAnnotation(foundAnnotation, animated: true)
                }
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
