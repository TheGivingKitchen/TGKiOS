//
//  SafetyNetHomeViewController.swift
//  TGK
//
//  Created by Jay Park on 8/28/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase

class SafetyNetHomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchExpandableHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchExpandableHeaderBottomDivider: UIView!
    @IBOutlet weak var searchExpandableHeaderCloseButton: UIButton!
    @IBOutlet weak var searchCountyLabel: UILabel!
    
    fileprivate let searchExpandableHeaderExpandedHeight:CGFloat = 50.0
    
    private enum SafetyNetTableSection:Int {
        case tooltip = 0
        case facebook = 1
        case resource = 2
    }
    
    fileprivate var isSearchingOrFiltering:Bool {
        if self.isTextSearching == true || self.isLocationBasedSearching == true {
            return true
        }
        return false
    }
    
    fileprivate var isTextSearching:Bool {
        if self.searchController.searchBar.text.isNilOrEmpty {
            return false
        }
        return true
    }
    
    fileprivate var isLocationBasedSearching:Bool = false {
        didSet {
            self.configureViewControlsBasedOnState()
        }
    }
    
    fileprivate var currentUserCounty:String?
    
    let locationManager = CLLocationManager()
    
    ///datasource corresponding to viewState
    fileprivate var safetyNetModels:[SafetyNetResourceModel] = []
    fileprivate var filteredSafetyNetModels:[SafetyNetResourceModel] = []
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate var userLocationCounty:String?
    
    private let safetyNetCellReuseId = "safetyNetCellReuseId"
    private let safetyNetTooltipReuseId = "safetyNetTooltipReuseId"
    private let safetyNetFacebookCellReuseId = "safetyNetFacebookCellReuseId"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleView()
        
        self.collapseSearchHeader()
        
        self.tableView.register(UINib(nibName: "SafetyNetInfoTableViewCell", bundle: nil), forCellReuseIdentifier: self.safetyNetCellReuseId)
        self.tableView.register(UINib(nibName: "FacebookGroupAccessTableViewCell", bundle: nil), forCellReuseIdentifier: self.safetyNetFacebookCellReuseId)
        self.tableView.register(UINib(nibName: "SafetyNetHomeTooltipCell", bundle: nil), forCellReuseIdentifier: self.safetyNetTooltipReuseId)
        
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.setupSearchController()
        self.configureViewControlsBasedOnState()
        
        self.fetchData()
    }
    
    private func styleView() {
        self.searchCountyLabel.font = UIFont.tgkBody
        self.searchCountyLabel.textColor = UIColor.tgkDarkGray
        
        self.searchExpandableHeaderBottomDivider.backgroundColor = UIColor.tgkBackgroundGray
        
        self.searchExpandableHeaderCloseButton.setTemplateImage(named: "iconCloseX", for: .normal, tint: UIColor.tgkDarkGray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
    }
    
    func configureViewControlsBasedOnState() {

        if self.isLocationBasedSearching {
            self.expandSearchHeader()
            
            self.navigationItem.rightBarButtonItem = nil
            
            if let userCounty = self.userLocationCounty {
                self.searchCountyLabel.text = "Searching within \(userCounty)"
            }
            else {
                self.searchCountyLabel.text = "Searching within your county"
            }
        }
        else {
            self.collapseSearchHeader()
            
            let locationFilterBarButton = UIBarButtonItem(image: UIImage(named: "iconLocationMarker"), style: .plain, target: self, action: #selector(changeToLocationSearchPressed(_:)))
            self.navigationItem.rightBarButtonItem = locationFilterBarButton
        }
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
    
    func collapseSearchHeader() {
        UIView.animate(withDuration: 0.25) {
            self.searchExpandableHeaderHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func expandSearchHeader() {
        UIView.animate(withDuration: 0.25) {
            self.searchExpandableHeaderHeightConstraint.constant = self.searchExpandableHeaderExpandedHeight
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func searchExpandableHeaderClosePressed(_ sender: Any) {
        self.changeToNormalSearch()
    }
    
    @IBAction func changeToLocationSearchPressed(_ sender: Any) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            let locationWarmingVC = LocationWarmingViewController.instantiateWith(delegate: self)
            
            self.tabBarController?.present(locationWarmingVC, animated: true)
            break
            
        case .restricted, .denied:
            self.showLocationServicesDeniedAlert()
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            self.getUserLocationAndFilter()
            break
        }
    }
    
    func changeToNormalSearch() {
        self.searchController.searchBar.text = ""
        self.currentUserCounty = nil
        self.isLocationBasedSearching = false
        self.tableView.reloadData()
        
        Analytics.logEvent(customName: .safetyNetChangeToGlobalSearch)
    }
}

//MARK: Tableview delegate and datasource
extension SafetyNetHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SafetyNetTableSection.tooltip.rawValue:
            if AppDataStore.hasClosedSafetyNetTooltip || self.isSearchingOrFiltering {
                return 0
            }
            return 1
        case SafetyNetTableSection.facebook.rawValue:
            if self.isSearchingOrFiltering {
                return 0
            }
            return 1
        case SafetyNetTableSection.resource.rawValue:
            if self.isSearchingOrFiltering {
                return self.filteredSafetyNetModels.count
            }
            return self.safetyNetModels.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SafetyNetTableSection.tooltip.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.safetyNetTooltipReuseId) as! SafetyNetHomeTooltipCell
            cell.delegate = self
            return cell
            
        case SafetyNetTableSection.facebook.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.safetyNetFacebookCellReuseId) as! FacebookGroupAccessTableViewCell
            cell.delegate = self
            return cell
            
        case SafetyNetTableSection.resource.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.safetyNetCellReuseId) as! SafetyNetInfoTableViewCell
            
            if self.isSearchingOrFiltering {
                cell.configure(withSafetyNetModel: self.filteredSafetyNetModels[indexPath.row])
            }
            else {
                cell.configure(withSafetyNetModel: self.safetyNetModels[indexPath.row])
            }
            
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resource = self.safetyNetModels[indexPath.row]
        let detailVC = SafetyNetDetailSheetViewController.instantiateWith(safetyNetResource: resource)
        self.tabBarController?.present(detailVC, animated: true)
    }
}

extension SafetyNetHomeViewController :SafetyNetHomeTooltipCellDelegate {
    func safetyNetHomeTooltipCellDidPressClose(cell: SafetyNetHomeTooltipCell) {
        AppDataStore.hasClosedSafetyNetTooltip = true
        self.tableView.reloadSections(NSIndexSet(index: SafetyNetTableSection.tooltip.rawValue) as IndexSet, with: UITableViewRowAnimation.bottom)
    }
    
    func safetyNetHomeTooltipCellDidPressLearnMore(cell: SafetyNetHomeTooltipCell) {
        if let url = URL(string: "TODO replace with safetynet url") {
            let learnMoreVC = TGKSafariViewController(url: url)
            self.present(learnMoreVC, animated:true)
        }
    }
}


//MARK: - FacebookCell Delegate
extension SafetyNetHomeViewController:FacebookGroupAccessTableViewCellDelegate {
    func facebookGroupAccessTableViewCellRequestTableViewUpdate() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    func facebookGroupAccessTableViewCellRequestOpen(url: URL) {
        let tgkSafariVC = TGKSafariViewController(url: url)
        self.present(tgkSafariVC, animated: true)
    }
}

//MARK: - UISearchResultsUpdating Delegate
extension SafetyNetHomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func setupSearchController() {
        self.searchController.searchBar.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search SafetyNet"
        self.searchController.searchBar.barTintColor = UIColor.tgkBlue
        self.searchController.searchBar.tintColor = UIColor.tgkOrange
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.tgkBody
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {return}
        if !searchText.isEmpty {
            ///Set search bar text to empty so that reloading happens properly
            searchBar.text = ""
            self.scrollToTop()
            self.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.scrollToTop()
            self.tableView.reloadData()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filterContentForSearchText(searchController.searchBar.text)
    }
    
    func filterContentForSearchText(_ searchText:String?) {
        ///Location based filter first
        var filteredModels = self.safetyNetModels
        if let userCounty = self.currentUserCounty,
            self.isLocationBasedSearching == true {
            filteredModels = filteredModels.filter({ (safetyNetModel) -> Bool in
                if let counties = safetyNetModel.counties {
                    for county in counties {
                        if county.lowercased() == "all" {
                            return true
                        }
                        if county.lowercased().range(of: userCounty) != nil {
                            return true
                        }
                    }
                }
                return false
            })
        }
        self.filteredSafetyNetModels = filteredModels
        
        ///Text Based searching next
        guard let lowercaseTrimmedSearchText = searchText?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
            lowercaseTrimmedSearchText.isEmpty == false else {
                return
        }
        
        if self.isTextSearching {
            filteredModels = filteredModels.filter({ (safetyNetModel) -> Bool in
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
        }
        
        self.filteredSafetyNetModels = filteredModels
        
        self.scrollToTop()
        self.tableView.reloadData()
        
        Analytics.logEvent(customName: .safetyNetSearch, parameters: [.safetyNetSearchLocationBased:self.isLocationBasedSearching,
                                                                      .safetyNetSearchTerm:lowercaseTrimmedSearchText])
    }
    
    func scrollToTop() {
        DispatchQueue.main.async {
            if self.tableView.numberOfRows(inSection: SafetyNetTableSection.resource.rawValue) > 0 {
                let indexPath = IndexPath(row: 0, section: SafetyNetTableSection.resource.rawValue)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
}

//MARK: CLLocationManagerDelegate
extension SafetyNetHomeViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            break
            
        case .restricted, .denied:
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            self.getUserLocationAndFilter()
            break
        }
    }
    
    func getUserLocationAndFilter() {
        Analytics.logEvent(customName: .safetyNetChangeToLocationSearch)
        
        self.userLocationCounty = nil
        
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
                        self.userLocationCounty = component.name
                        let sanitizedCountyString = component.name.lowercased().replacingOccurrences(of: "county", with: "").trimmingCharacters(in: .whitespaces)
                        
                        self.currentUserCounty = sanitizedCountyString
                        
                        self.searchController.searchBar.text = ""
                        self.isLocationBasedSearching = true
                        self.updateSearchResults(for: self.searchController)
                        self.scrollToTop()
                        self.tableView.reloadData()
                    }
                }
            }
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

//MARK: LocationWarmingViewControllerDelegate
extension SafetyNetHomeViewController:LocationWarmingViewControllerDelegate {
    func locationWarmingViewControllerDidAccept(viewController: LocationWarmingViewController) {
        viewController.dismiss(animated: true)
        
        self.locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationWarmingViewControllerDidDecline(viewController: LocationWarmingViewController) {
        viewController.dismiss(animated: true)
    }
}
