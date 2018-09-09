//
//  FormsHomeViewController.swift
//  TGK
//
//  Created by Jay Park on 5/20/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Alamofire
import FirebaseAuth
import GooglePlaces

class TestHomeViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }
    
    @IBAction func buttontapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: "fb://group?id=1426736404312089")!, options: [:]) { (success) in
            if success == false {
                let tgkSafariVC = TGKSafariViewController(url: URL(string: "https://www.facebook.com/groups/1426736404312089")!)
                self.present(tgkSafariVC, animated: true)
            }
        }
    }
    
    @IBAction func northGA(_ sender: Any) {
        UIApplication.shared.open(URL(string: "fb://group?id=1836033839791219")!, options: [:]) { (success) in
            if success == false {
                let tgkSafariVC = TGKSafariViewController(url: URL(string: "https://www.facebook.com/groups/1836033839791219")!)
                self.present(tgkSafariVC, animated: true)
            }
        }
    }
    
    @IBAction func southGA(_ sender: Any) {
        UIApplication.shared.open(URL(string: "fb://group?id=1763853010365060")!, options: [:]) { (success) in
            if success == false {
                let tgkSafariVC = TGKSafariViewController(url: URL(string: "https://www.facebook.com/groups/1763853010365060")!)
                self.present(tgkSafariVC, animated: true)
            }
        }
    }
    @IBAction func locateUser(_ sender: Any) {
        
        
        
        
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    func getLocation() {
        let placesClient = GMSPlacesClient.shared()
        placesClient.currentPlace { (placeLikelihoodList, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList,
                let place = placeLikelihoodList.likelihoods.first?.place,
                let addressComponenets = place.addressComponents {
                for component in addressComponenets {
                    if component.type == "administrative_area_level_2" {
                        print("County \(component.name)")
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            break
            
        case .restricted, .denied:
            // Disable location features
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            getLocation()
            break
        }
    }
}
