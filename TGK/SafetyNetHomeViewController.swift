//
//  SafetyNetHomeViewController.swift
//  TGK
//
//  Created by Jay Park on 8/28/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

class SafetyNetHomeViewController: UITableViewController {
    
    private enum SafetyNetHomeVCRow:Int {
        case tooltip = 0
        case resource = 1
    }
    
    var safetyNetModels:[SafetyNetResourceModel] = []
    
    private let safetyNetCellReuseId = "safetyNetCellReuseId"
    private let safetyNetTooltipReuseId = "safetyNetTooltipReuseId"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "SafetyNetInfoTableViewCell", bundle: nil), forCellReuseIdentifier: self.safetyNetCellReuseId)
        self.tableView.register(UINib(nibName: "SafetyNetHomeTooltipCell", bundle: nil), forCellReuseIdentifier: self.safetyNetTooltipReuseId)
        
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.fetchData()
    }
    
    func fetchData() {
        ServiceManager.sharedInstace.getSafetyNetResources { (safetyNetModels, error) in
            ServiceManager.sharedInstace.getLocalSafetyNetResources { (safetyNetModels, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let safetyNetModels = safetyNetModels,
                    self.safetyNetModels != safetyNetModels else {
                        return
                }
                
                self.safetyNetModels = safetyNetModels
                self.tableView.reloadData()
            }
        }
    }
}

extension SafetyNetHomeViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SafetyNetHomeVCRow.tooltip.rawValue:
            if AppDataStore.hasClosedSafetyNetTooltip {
                return 0
            }
            return 1
        case SafetyNetHomeVCRow.resource.rawValue:
            return self.safetyNetModels.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SafetyNetHomeVCRow.tooltip.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.safetyNetTooltipReuseId) as! SafetyNetHomeTooltipCell
            cell.delegate = self
            return cell
            
        case SafetyNetHomeVCRow.resource.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.safetyNetCellReuseId) as! SafetyNetInfoTableViewCell
            
            let safetyNetModel = self.safetyNetModels[indexPath.row]
            cell.configure(withSafetyNetModel: safetyNetModel)
            cell.delegate = self
            
            return cell
            
        default:
            break
        }
        return UITableViewCell()
    }
}

extension SafetyNetHomeViewController:SafetyNetInfoTableViewCellDelegate {
    func safetyNetInfoTableViewCellRequestOpenWeb(url: URL, cell: SafetyNetInfoTableViewCell) {
        let webviewVC = TGKSafariViewController(url: url)
        self.present(webviewVC, animated:true)
    }
    
    func safetyNetInfoTableViewCellRequestCallPhone(url: URL, cell: SafetyNetInfoTableViewCell) {
        UIApplication.shared.open(url, options: [:]) { (success) in
        }
    }
}

extension SafetyNetHomeViewController :SafetyNetHomeTooltipCellDelegate {
    func safetyNetHomeTooltipCellDidPressClose(cell: SafetyNetHomeTooltipCell) {
        AppDataStore.hasClosedSafetyNetTooltip = true
        self.tableView.reloadSections(NSIndexSet(index: SafetyNetHomeVCRow.tooltip.rawValue) as IndexSet, with: UITableViewRowAnimation.bottom)
    }
}
