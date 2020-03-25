//
//  StabilityNetCategoryFilterViewController.swift
//  TGK
//
//  Created by Jay Park on 2/22/20.
//  Copyright © 2020 TheGivingKitchen. All rights reserved.
//

import Foundation
import UIKit

protocol StabilityNetCategoryFilterViewControllerDelegate:class {
    func stabilityNetCategoryFilterViewControllerDidPressDone(viewController:StabilityNetCategoryFilterViewController, filters:Set<String>)
}

class StabilityNetCategoryFilterViewController:UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    
    weak var delegate:StabilityNetCategoryFilterViewControllerDelegate?
    
    var selectedCategories:Set<String> = [] {
        didSet {
            guard self.isViewLoaded else {
                return
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        self.styleView()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func styleView() {
        self.tableView.tableFooterView = UIView()
        
        self.headerLabel.font = UIFont.tgkSubtitle
        self.headerLabel.textColor = UIColor.tgkOrange
        
        self.doneButton.layer.cornerRadius = 3
        self.doneButton.layer.shadowRadius = 5
        self.doneButton.layer.shadowOpacity = 0.2
        self.doneButton.layer.shadowColor = UIColor.tgkDarkGray.cgColor
        self.doneButton.backgroundColor = UIColor.tgkOrange
        self.doneButton.titleLabel?.font = UIFont.tgkNavigation
    }
    
    @IBAction func donePressed(_ sender: Any) {
        self.delegate?.stabilityNetCategoryFilterViewControllerDidPressDone(viewController: self, filters: self.selectedCategories)
    }
}

extension StabilityNetCategoryFilterViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SafetyNetResourceModel.allCategories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = self.tableView.dequeueReusableCell(withIdentifier: "StabilityNetFilterCategoryTypeCellId") as! StabilityNetFilterCategoryTypeCell
        
        let category = SafetyNetResourceModel.allCategories[indexPath.row]
        categoryCell.configureWith(category: category, isOn: self.selectedCategories.contains(category))
        categoryCell.delegate = self
        
        return categoryCell
    }
}

extension StabilityNetCategoryFilterViewController:StabilityNetFilterCategoryTypeCellDelegate {
    func stabilityNetFilterCategoryTypeCellDidSetFilter(category: String, isActive: Bool) {
        if isActive {
            self.selectedCategories.insert(category)
        }
        else {
            self.selectedCategories.remove(category)
        }
    }
}
