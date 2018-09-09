//
//  SafetyNetHomeViewController.swift
//  TGK
//
//  Created by Jay Park on 8/28/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit
import GooglePlaces

class SafetyNetHomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private enum SafetyNetHomeVCRow:Int {
        case tooltip = 0
        case facebook = 1
        case resource = 2
    }
    
    enum ViewState {
        case normal
        case textSearching
        case locationBased
        case searchingWithinLocation
    }
    
    fileprivate var viewState:ViewState = .normal {
        didSet {
            self.tableView.reloadData()
            if oldValue != viewState {
                self.scrollToTop()
            }
            self.configureViewControlsBasedOnState()
        }
    }
    
    let locationManager = CLLocationManager()
    
    ///datasource corresponding to viewState
    fileprivate var safetyNetModels:[SafetyNetResourceModel] = []
    fileprivate var textSearchingSafetyNetModels:[SafetyNetResourceModel] = []
    fileprivate var locationBasedSafetyNetModels:[SafetyNetResourceModel] = []
    fileprivate var searchingLocationSafetyNetModels:[SafetyNetResourceModel] = []
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate var userLocationCounty:String?
    
    private let safetyNetCellReuseId = "safetyNetCellReuseId"
    private let safetyNetTooltipReuseId = "safetyNetTooltipReuseId"
    private let safetyNetFacebookCellReuseId = "safetyNetFacebookCellReuseId"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "SafetyNetInfoTableViewCell", bundle: nil), forCellReuseIdentifier: self.safetyNetCellReuseId)
        self.tableView.register(UINib(nibName: "FacebookGroupAccessTableViewCell", bundle: nil), forCellReuseIdentifier: self.safetyNetFacebookCellReuseId)
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
    
    func configureViewControlsBasedOnState() {

        switch self.viewState {
        case .normal, .textSearching:
            let locationFilterBarButton = UIBarButtonItem(image: UIImage(named: "iconLocationMarker"), style: .plain, target: self, action: #selector(changeToLocationSearchPressed(_:)))
            self.navigationItem.rightBarButtonItem = locationFilterBarButton
            self.navigationItem.title = ""
        case .locationBased, .searchingWithinLocation:
            let normalFilterBarButton = UIBarButtonItem(image: UIImage(named: "iconBulletList"), style: .plain, target: self, action: #selector(changeToNormalSearchPressed(_:)))
            self.navigationItem.rightBarButtonItem = normalFilterBarButton
            
            if let userCounty = self.userLocationCounty {
                self.navigationItem.title = "Resources in \(userCounty)"
            }
            else {
                self.navigationItem.title = "Resources in your county"
            }
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
    
    @IBAction func changeToLocationSearchPressed(_ sender: Any) {
        self.locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            self.showLocationServicesDeniedAlert()
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            self.getUserLocationAndFilter()
            break
        }
    }
    
    @IBAction func changeToNormalSearchPressed(_ sender: Any) {
        self.searchController.searchBar.text = ""
        self.viewState = .normal
    }
}

extension SafetyNetHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SafetyNetHomeVCRow.tooltip.rawValue:
            if AppDataStore.hasClosedSafetyNetTooltip {
                return 0
            }
            switch self.viewState {
            case .normal:
                return 1
            case .textSearching, .locationBased, .searchingWithinLocation:
                return 0
            }
        case SafetyNetHomeVCRow.facebook.rawValue:
            switch self.viewState {
            case .normal:
                return 1
            case .textSearching, .locationBased, .searchingWithinLocation:
                return 0
            }
        case SafetyNetHomeVCRow.resource.rawValue:
            switch self.viewState {
            case .normal:
                return self.safetyNetModels.count
            case .textSearching:
                return self.textSearchingSafetyNetModels.count
            case .locationBased:
                return self.locationBasedSafetyNetModels.count
            case .searchingWithinLocation:
                return self.searchingLocationSafetyNetModels.count
            }
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
            
        case SafetyNetHomeVCRow.facebook.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.safetyNetFacebookCellReuseId) as! FacebookGroupAccessTableViewCell
            cell.delegate = self
            return cell
            
        case SafetyNetHomeVCRow.resource.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.safetyNetCellReuseId) as! SafetyNetInfoTableViewCell
            
            switch self.viewState {
            case .normal:
                cell.configure(withSafetyNetModel: self.safetyNetModels[indexPath.row])
                break
            case .textSearching:
                cell.configure(withSafetyNetModel: self.textSearchingSafetyNetModels[indexPath.row])
                break
            case .locationBased:
                cell.configure(withSafetyNetModel: self.locationBasedSafetyNetModels[indexPath.row])
                break
            case .searchingWithinLocation:
                cell.configure(withSafetyNetModel: self.searchingLocationSafetyNetModels[indexPath.row])
                break
            }
            
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


//MARK: - FacebookCell Delegate
extension SafetyNetHomeViewController:FacebookGroupAccessTableViewCellDelegate {
    func facebookGroupAccessTableViewCellRequestOpen(url: URL) {
        let tgkSafariVC = TGKSafariViewController(url: url)
        self.present(tgkSafariVC, animated: true)
    }
}

//MARK: - UISearchResultsUpdating Delegate
extension SafetyNetHomeViewController: UISearchResultsUpdating {
    func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search community resources"
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
        ///If the user cancels searching or enters white space characters or is in an empty state, we're not searching. Depending on if we're filtering by location, revert to normal or locationBased state
        guard let lowercaseTrimmedSearchText = searchText?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
            lowercaseTrimmedSearchText.isEmpty == false else {
                switch self.viewState {
                case .normal:
                    break
                case .textSearching:
                    self.viewState = .normal
                    break
                case .locationBased:
                    break
                case .searchingWithinLocation:
                    self.viewState = .locationBased
                    break
                }
                
                return
        }
        
        ///If there is valid search criteria, filter the results and set us in searching state
        let searchFilterBlock:(SafetyNetResourceModel) -> Bool = { (safetyNetModel) -> Bool in
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
        }
        
        self.textSearchingSafetyNetModels = self.safetyNetModels.filter(searchFilterBlock)
        self.searchingLocationSafetyNetModels = self.locationBasedSafetyNetModels.filter(searchFilterBlock)
        
        switch self.viewState {
        case .normal:
            self.viewState = .textSearching
            break
        case .textSearching:
            self.viewState = .textSearching
            break
        case .locationBased:
            self.viewState = .searchingWithinLocation
            break
        case .searchingWithinLocation:
            self.viewState = .searchingWithinLocation
            break
        }
    }
    
    func scrollToTop() {
        DispatchQueue.main.async {
            let resourceCount = self.viewState == .normal ? self.safetyNetModels.count : self.textSearchingSafetyNetModels.count
            if resourceCount == 0 {
                return
            }
            let indexPath = IndexPath(row: 0, section: SafetyNetHomeVCRow.resource.rawValue)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
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
                        
                        self.locationBasedSafetyNetModels = self.safetyNetModels.filter({(safetyNetModel) -> Bool in
                            if let counties = safetyNetModel.counties {
                                for county in counties {
                                    if county.lowercased() == "all" {
                                        return true
                                    }
                                    if county.lowercased().range(of: sanitizedCountyString) != nil {
                                        return true
                                    }
                                }
                            }
                            return false
                        })
                        
                        self.searchController.searchBar.text = ""
                        self.viewState = .locationBased
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
