//
//  SafetyNetHomeViewController.swift
//  TGK
//
//  Created by Jay Park on 8/28/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

class SafetyNetHomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private enum SafetyNetHomeVCRow:Int {
        case tooltip = 0
        case resource = 1
    }
    
    enum ViewState {
        case normal
        case searching
    }
    
    fileprivate var viewState:ViewState = .normal
    fileprivate var safetyNetModels:[SafetyNetResourceModel] = []
    
    ///filtered models while searching
    fileprivate var filteredSafetyNetModels:[SafetyNetResourceModel] = []
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate var previousSearchText:String? = ""
    
    private let safetyNetCellReuseId = "safetyNetCellReuseId"
    private let safetyNetTooltipReuseId = "safetyNetTooltipReuseId"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "SafetyNetInfoTableViewCell", bundle: nil), forCellReuseIdentifier: self.safetyNetCellReuseId)
        self.tableView.register(UINib(nibName: "SafetyNetHomeTooltipCell", bundle: nil), forCellReuseIdentifier: self.safetyNetTooltipReuseId)
        
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.setupSearchController()
        
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

extension SafetyNetHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SafetyNetHomeVCRow.tooltip.rawValue:
            if self.viewState == .searching || AppDataStore.hasClosedSafetyNetTooltip {
                return 0
            }
            return 1
        case SafetyNetHomeVCRow.resource.rawValue:
            return self.viewState == .normal ? self.safetyNetModels.count : self.filteredSafetyNetModels.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SafetyNetHomeVCRow.tooltip.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.safetyNetTooltipReuseId) as! SafetyNetHomeTooltipCell
            cell.delegate = self
            return cell
            
        case SafetyNetHomeVCRow.resource.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.safetyNetCellReuseId) as! SafetyNetInfoTableViewCell
            
            let safetyNetModel = self.viewState == .normal ? self.safetyNetModels[indexPath.row] : self.filteredSafetyNetModels[indexPath.row]
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

//MARK: - Searching
extension SafetyNetHomeViewController: UISearchResultsUpdating {
    func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search"
        self.searchController.searchBar.barTintColor = UIColor.tgkBlue
        self.searchController.searchBar.tintColor = UIColor.tgkOrange
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.tgkBody
//        self.tableView.tableHeaderView = self.searchController.searchBar
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filterContentForSearchText(searchController.searchBar.text)
    }
    
    func filterContentForSearchText(_ searchText:String?) {
        ///If the user enters white space characters or is in an empty state, we're not searching
        guard let lowercaseTrimmedSearchText = searchText?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
            lowercaseTrimmedSearchText.isEmpty == false else {
                self.viewState = .normal
                self.tableView.reloadData()
                self.scrollToTop()
                return
        }
        
        ///If there is valid search criteria, filter the results and set us in searching state
        self.filteredSafetyNetModels = self.safetyNetModels.filter({ (safetyNetModel) -> Bool in
            if safetyNetModel.name.lowercased().contains(lowercaseTrimmedSearchText) {
                return true
            }
            
            if let phoneNumber = safetyNetModel.phoneNumber,
                phoneNumber.contains(lowercaseTrimmedSearchText),
                lowercaseTrimmedSearchText.count > 2 {
                //make keyword searching restrictive to at least 3 characters to reduce noise
                return true
            }
            
            if let contactName = safetyNetModel.contactName?.lowercased(),
                contactName.contains(lowercaseTrimmedSearchText),
                lowercaseTrimmedSearchText.count > 2 {
                //make keyword searching restrictive to at least 3 characters to reduce noise
                return true
            }
            
            if let category = safetyNetModel.category?.lowercased(),
                category.contains(lowercaseTrimmedSearchText),
                lowercaseTrimmedSearchText.count > 2 {
                //make keyword searching restrictive to at least 3 characters to reduce noise
                return true
            }
            
            if let counties = safetyNetModel.counties {
                for county in counties {
                    //make keyword searching restrictive to at least 3 characters to reduce noise
                    if lowercaseTrimmedSearchText.count < 3 {
                        break
                    }
                    if county.lowercased().range(of: lowercaseTrimmedSearchText) != nil {
                        return true
                    }
                }
            }
            
            return false
        })
        
        self.viewState = .searching
        self.tableView.reloadData()
        
        ///scroll to the top if its a new search term
        if (self.filteredSafetyNetModels.count > 0 && searchText != self.previousSearchText) {
            self.scrollToTop()
        }
        self.previousSearchText = searchText
    }
    
    func scrollToTop() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: SafetyNetHomeVCRow.resource.rawValue)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}
