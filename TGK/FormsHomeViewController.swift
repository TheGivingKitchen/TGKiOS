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

class TestHomeViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cancelButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cancelWidthConstraint.constant = 0
        self.cancelButtonLeadingConstraint.constant = 0
        self.cancelButtonTrailingConstraint.constant = 0
        self.headerHeightConstraint.constant = 152
        self.cancelButton.isHidden = true
        
        self.searchBar.delegate = self
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.collapseSearch()
    }
    
    @IBAction func expandSearch() {
        self.searchBar.resignFirstResponder()
        
        UIView.animate(withDuration: 0.25) {
            self.cancelWidthConstraint.constant = 0
            self.cancelButtonLeadingConstraint.constant = 0
            self.cancelButtonTrailingConstraint.constant = 0
            self.headerHeightConstraint.constant = 152
            self.cancelButton.isHidden = true
            
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func collapseSearch() {
        
        UIView.animate(withDuration: 0.25) {

            self.cancelWidthConstraint.constant = 48
            self.cancelButtonLeadingConstraint.constant = 8
            self.cancelButtonTrailingConstraint.constant = 8
            self.cancelButton.isHidden = false
            self.headerHeightConstraint.constant = 56
            
            self.view.layoutIfNeeded()
        }
    }
    
}
