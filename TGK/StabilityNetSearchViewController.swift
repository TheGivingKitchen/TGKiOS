//
//  StabilityNetSearchViewController.swift
//  TGK
//
//  Created by Jay Park on 8/4/19.
//  Copyright © 2019 TheGivingKitchen. All rights reserved.
//

import UIKit
import MapKit
import Firebase

protocol StabilityNetSearchViewControllerDelegate:class {
    func stabilityNetSearchViewControllerDidFind(resources: [SafetyNetResourceModel])
    func stabilityNetSearchViewControllerDidSelect(resource: SafetyNetResourceModel)
}

class StabilityNetSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    weak var delegate:StabilityNetSearchViewControllerDelegate?
    
    let topStickyPoint: CGFloat = 100
    var bottomStickyPoint: CGFloat {
        //round it so that the pan guesture recognizer has an integer value to work with
        return (UIScreen.main.bounds.height * 0.6).rounded()
    }
    
    private enum SafetyNetTableSection:Int {
        case categoryFilter = 0
        case resource = 1
    }
    
    fileprivate var isSearchingOrFiltering:Bool {
        if self.isTextSearching == true || self.isLocationBasedSearching == true || self.selectedCategories.count > 0 {
            return true
        }
        return false
    }
    
    fileprivate var isTextSearching:Bool {
        if self.searchBar.text.isNilOrEmpty {
            return false
        }
        return true
    }
    
    fileprivate var isLocationBasedSearching:Bool = false {
        didSet {
            //TODO
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
    
    private var selectedCategories:Set<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleView()
        
        let viewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        viewPanGesture.delegate = self
        view.addGestureRecognizer(viewPanGesture)
        
        self.tableView.register(UINib(nibName: "SafetyNetInfoTableViewCell", bundle: nil), forCellReuseIdentifier: self.safetyNetCellReuseId)
        self.tableView.register(UINib(nibName: "FacebookGroupAccessTableViewCell", bundle: nil), forCellReuseIdentifier: self.safetyNetFacebookCellReuseId)
        
//        self.tableView.tableFooterView = UIView()
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.setupSearchController()
        
        self.fetchData()
    }
    
    private func styleView() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.tgkBackgroundGray
        
        self.searchBar.setBackgroundImage(UIImage(), for: .top, barMetrics: .default)
        self.roundTopCorners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.safetyNetModels.count == 0 {
            self.fetchData()
        }
    }
    
    func fetchData() {
        ServiceManager.sharedInstace.getSafetyNetResources { (safetyNetModels, error) in
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
            
            let resourcesToShowOnMap = self.isSearchingOrFiltering ? self.filteredSafetyNetModels : self.safetyNetModels
            self.delegate?.stabilityNetSearchViewControllerDidFind(resources: resourcesToShowOnMap)
        }
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        
        let currentY = self.view.frame.minY
        
        self.view.frame = CGRect(x: 0, y: currentY + translation.y, width: view.frame.width, height: view.frame.height)
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        if recognizer.state == .ended {
            self.searchBar.resignFirstResponder()
            
            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.0, options: [.allowUserInteraction], animations: {[weak self] in
                if let unwrappedSelf = self {
                    
                    //the point at which the velocity of the movement combined with the "ended" recognition state counts as a user flicking. values are arbitrary
                    let downWardFlickThreshold:CGFloat = 1400.0
                    let upwardFlickThreshold:CGFloat = -1400.0
                    let midpoint = (unwrappedSelf.topStickyPoint + unwrappedSelf.bottomStickyPoint) / 2.0
                    var targetY:CGFloat = 0
                    
                    switch velocity.y {
                    case _ where velocity.y > downWardFlickThreshold:
                        targetY = unwrappedSelf.bottomStickyPoint
                        break
                    case _ where velocity.y < upwardFlickThreshold:
                        targetY = unwrappedSelf.topStickyPoint
                        break
                    default:
                        targetY = unwrappedSelf.view.frame.minY > midpoint ? unwrappedSelf.bottomStickyPoint : unwrappedSelf.topStickyPoint
                        break
                    }
                    
                    unwrappedSelf.view.frame = CGRect(x: 0, y: targetY, width: unwrappedSelf.view.frame.width, height: unwrappedSelf.view.frame.height)
                }
                }, completion: { [weak self] _ in
                    if ( velocity.y < 0 ) {
                        self?.tableView.isScrollEnabled = true
                    }
            })
        }
    }
    
    func moveToTopStickyPoint() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.35, delay: 0.0, options: [], animations: {[weak self] in
                if let unwrappedSelf = self {
                    unwrappedSelf.view.frame = CGRect(x: 0, y: unwrappedSelf.topStickyPoint, width: unwrappedSelf.view.frame.width, height: unwrappedSelf.view.frame.height)
                }
                }, completion: { _ in
            })
        }
    }
    
    func moveToBottomStickyPoint() {
        DispatchQueue.main.async {
            self.searchBar.resignFirstResponder()
            
            UIView.animate(withDuration: 0.35, delay: 0.0, options: [], animations: {[weak self] in
                if let unwrappedSelf = self {
                    unwrappedSelf.view.frame = CGRect(x: 0, y: unwrappedSelf.bottomStickyPoint, width: unwrappedSelf.view.frame.width, height: unwrappedSelf.view.frame.height)
                }
                }, completion: { _ in
            })
        }
    }
}

//MARK: Tableview delegate and datasource
extension StabilityNetSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SafetyNetTableSection.categoryFilter.rawValue:
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
        case SafetyNetTableSection.categoryFilter.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StabilityNetSearchMapFilterTableViewCellId") as! StabilityNetSearchMapFilterTableViewCell
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
        self.moveToBottomStickyPoint()
        let resource = self.isSearchingOrFiltering ? self.filteredSafetyNetModels[indexPath.row] : self.safetyNetModels[indexPath.row]
        self.delegate?.stabilityNetSearchViewControllerDidSelect(resource: resource)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case SafetyNetTableSection.categoryFilter.rawValue:
            return 100
        default:
            return UITableViewAutomaticDimension
        }
    }
}

extension StabilityNetSearchViewController :SafetyNetHomeTooltipCellDelegate {
    func safetyNetHomeTooltipCellDidPressClose(cell: SafetyNetHomeTooltipCell) {
        AppDataStore.hasClosedSafetyNetTooltip = true
        self.tableView.reloadSections(NSIndexSet(index: SafetyNetTableSection.categoryFilter.rawValue) as IndexSet, with: UITableViewRowAnimation.bottom)
    }
    
    func safetyNetHomeTooltipCellDidPressLearnMore(cell: SafetyNetHomeTooltipCell) {
        if let url = URL(string: "TODO replace with safetynet url") {
            let learnMoreVC = TGKSafariViewController(url: url)
            self.present(learnMoreVC, animated:true)
        }
    }
}

//MARK: - UISearchBarDelegate
extension StabilityNetSearchViewController: UISearchBarDelegate {
    
    func setupSearchController() {
        self.searchBar.delegate = self
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.tgkBody
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.moveToTopStickyPoint()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.scrollToTop()
            self.tableView.reloadData()
            self.updateParentMapView()
        }
        else {
            self.filterAndShowContentForSearchText()
        }
        
        
    }
    
    func filterAndShowContentForSearchText() {
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
        let searchText = self.searchBar.text
        let lowercaseTrimmedSearchText = searchText?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        if let lowercaseTrimmedSearchText = lowercaseTrimmedSearchText,
            lowercaseTrimmedSearchText.isEmpty == false,
            self.isTextSearching {
            filteredModels = filteredModels.filter({ (safetyNetModel) -> Bool in
                if safetyNetModel.name.lowercased().contains(lowercaseTrimmedSearchText) {
                    return true
                }
                
                if let phoneNumber = safetyNetModel.phoneNumber,
                    phoneNumber.contains(lowercaseTrimmedSearchText),
                    lowercaseTrimmedSearchText.count > 2 {
                    //make keyword searching restrictive to at least 2 characters to reduce noise
                    return true
                }
                
                if let contactName = safetyNetModel.contactName?.lowercased(),
                    contactName.contains(lowercaseTrimmedSearchText),
                    lowercaseTrimmedSearchText.count > 2 {
                    //make keyword searching restrictive to at least 2 characters to reduce noise
                    return true
                }
                
                if safetyNetModel.category.lowercased().contains(lowercaseTrimmedSearchText),
                    lowercaseTrimmedSearchText.count > 2 {
                    return true
                    //make keyword searching restrictive to at least 2 characters to reduce noise
                }
                
                
                for subcategory in safetyNetModel.subcategories {
                    if let _ = subcategory.range(of: lowercaseTrimmedSearchText, options: .caseInsensitive),
                        lowercaseTrimmedSearchText.count > 2 {
                        return true
                        //make keyword searching restrictive to at least 2 characters to reduce noise
                    }
                }
                
                if let counties = safetyNetModel.counties {
                    for county in counties {
                        //make keyword searching restrictive to at least 3 characters to reduce noise
                        if let _ = county.range(of: lowercaseTrimmedSearchText, options: .caseInsensitive),
                            lowercaseTrimmedSearchText.count < 3 {
                            break
                        }
                        if county.lowercased().range(of: lowercaseTrimmedSearchText) != nil {
                            return true
                        }
                    }
                }
                
                for keyword in safetyNetModel.keywords {
                    //make keyword searching restrictive to at least 3 characters to reduce noise
                    if let _ = keyword.range(of: lowercaseTrimmedSearchText, options: .caseInsensitive),
                        lowercaseTrimmedSearchText.count < 3 {
                        break
                    }
                    if keyword.lowercased().range(of: lowercaseTrimmedSearchText) != nil {
                        return true
                    }
                }
                
                return false
            })
        }
        
        //Filter if the user has selected categories
        if selectedCategories.count > 0 {
            filteredModels = filteredModels.filter { (resource) -> Bool in
                for selectedCategory in self.selectedCategories {
                    if resource.category.caseInsensitiveCompare(selectedCategory) == .orderedSame {
                        return true
                    }
                }
                return false
            }
        }
        
        self.filteredSafetyNetModels = filteredModels
        
        self.scrollToTop()
        self.tableView.reloadData()
        self.updateParentMapView()
        
        Analytics.logEvent(customName: .safetyNetSearch, parameters: [.safetyNetSearchLocationBased:self.isLocationBasedSearching,
                                                                      .safetyNetSearchTerm:lowercaseTrimmedSearchText as Any])
    }
    
    func scrollToTop() {
        DispatchQueue.main.async {
            if self.tableView.numberOfRows(inSection: SafetyNetTableSection.resource.rawValue) > 0 {
                let indexPath = IndexPath(row: 0, section: SafetyNetTableSection.categoryFilter.rawValue)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
    
    func updateParentMapView() {
        let resourcesToShowOnMap = self.isSearchingOrFiltering ? self.filteredSafetyNetModels : self.safetyNetModels
        self.delegate?.stabilityNetSearchViewControllerDidFind(resources: resourcesToShowOnMap)
    }
}

//MARK: CLLocationManagerDelegate
extension StabilityNetSearchViewController:CLLocationManagerDelegate {
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
        
        let locationManager = CLLocationManager()
        let geoCoder = CLGeocoder()
        
        if let location = locationManager.location {
            geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemarks = placemarks,
                    let place = placemarks.first,
                    let county = place.subAdministrativeArea {
                    self.userLocationCounty = county
                    let sanitizedCountyString = county.lowercased().replacingOccurrences(of: "county", with: "").trimmingCharacters(in: .whitespaces)
                    
                    self.currentUserCounty = sanitizedCountyString
                    
                    self.searchController.searchBar.text = ""
                    self.isLocationBasedSearching = true
                    self.scrollToTop()
                    self.tableView.reloadData()
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
extension StabilityNetSearchViewController:LocationWarmingViewControllerDelegate {
    func locationWarmingViewControllerDidAccept(viewController: LocationWarmingViewController) {
        viewController.dismiss(animated: true)
        
        self.locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationWarmingViewControllerDidDecline(viewController: LocationWarmingViewController) {
        viewController.dismiss(animated: true)
    }
}

//MARK: PanGestureRecognizerDelegate
extension StabilityNetSearchViewController: UIGestureRecognizerDelegate {
    
    //TODO these two delegate functions aren't quite right. they work but the logic is flawed
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y
        let y = view.frame.minY
        
        //if we're at the topStickyPoint, and the of the tableview, and the user is dragging downward, disable scrolling to enable the flick downward
        if ((y == topStickyPoint && tableView.contentOffset.y <= 0 && direction > 0)) {
            tableView.isScrollEnabled = false
        }
        else if (y == self.bottomStickyPoint && direction < 0) {
            tableView.isScrollEnabled = false
        }
        else {
            tableView.isScrollEnabled = true
        }

        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y
        let y = view.frame.minY
        
        //if we're at the topStickyPoint, and the top of the tableview, just allow the tableview to scroll and cancel the panGesture so it doesn't try to move the view upward.
        if ((y == topStickyPoint && tableView.contentOffset.y == 0 && direction < 0)) {
            return true
        }
        
        if (y == self.bottomStickyPoint && direction < 0) {
            return true
        }
        
        return false
    }
}

//extension StabilityNetSearchViewController:StabilityNetCategoryFilterTableViewCellDelegate {
//    func stabilityNetCategoryFilterTableViewCellDidSelect(category: String) {
//        self.selectedCategories.insert(category)
//        self.filterAndShowContentForSearchText()
//    }
//
//    func stabilityNetCategoryFilterTableViewCellDidDeselect(category: String) {
//        self.selectedCategories.remove(category)
//        self.filterAndShowContentForSearchText()
//    }
//}

extension StabilityNetSearchViewController:StabilityNetSearchMapFilterTableViewCellDelegate {
    func stabilityNetSearchMapFilterTableViewCellDidTapFilter() {
        let filterVC = UIStoryboard(name: "SafetyNet", bundle: nil).instantiateViewController(withIdentifier: "StabilityNetCategoryFilterViewControllerId") as! StabilityNetCategoryFilterViewController
        filterVC.selectedCategories = self.selectedCategories
        self.present(filterVC, animated: true)
    }
}

