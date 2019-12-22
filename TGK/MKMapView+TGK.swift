//
//  MKMapView+TGK.swift
//  TGK
//
//  Created by Jay Park on 12/1/19.
//  Copyright © 2019 TheGivingKitchen. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {

    func topCenterCoordinate() -> CLLocationCoordinate2D {
        return self.convert(CGPoint(x: self.frame.size.width / 2.0, y: 0), toCoordinateFrom: self)
    }

    func currentRadius() -> Double {
        let centerLocation = CLLocation(latitude: self.centerCoordinate.latitude, longitude: self.centerCoordinate.longitude)
        let topCenterCoordinate = self.topCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        return centerLocation.distance(from: topCenterLocation)
    }
    
    func setRegion(_ zoomRegion:MKCoordinateRegion, animationDuration:TimeInterval) {
        MKMapView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.setRegion(zoomRegion, animated: true)
            }, completion: nil)
    }
}
