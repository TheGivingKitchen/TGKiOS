//
//  EventsHomeViewController.swift
//  TGK
//
//  Created by Jay Park on 6/6/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyXMLParser
import Firebase

class EventsHomeViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeaderEventsDescriptionLabel: UILabel!
    @IBOutlet weak var learnMoreButton: UIButton!
    @IBOutlet weak var tableViewBottomDividerView: UIView!
    
    @IBOutlet weak var volunteerView: UIView!
    @IBOutlet weak var volunteerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var volunteerTextButton: UIButton!
    
    var calendarEventModels = [RSSCalendarEventModel]()
    var volunteerFormModel:SegmentedFormModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
        self.styleView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.configureVolunteerView(animated: false)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedSectionHeaderHeight = UITableViewAutomaticDimension
        
        self.fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let headerView = tableView.tableHeaderView else {
            return
        }
        
        let size = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableView.layoutIfNeeded()
        }
    }
    
    func fetchData() {
        ServiceManager.sharedInstace.getEventFeed { (calendarEventModels, error) in
            if let calendarEventModels = calendarEventModels {
                if self.calendarEventModels != calendarEventModels {
                    self.calendarEventModels = calendarEventModels
                    self.tableView.reloadData()
                }
            }
            else if let error = error {
                print(error)
            }
        }
        
        ServiceManager.sharedInstace.getFirebaseForm(id: "volunteerSignup") { (volunteerFormModel, error) in
            if let unwrappedModel = volunteerFormModel {
                self.volunteerFormModel = unwrappedModel
                DispatchQueue.main.async {
                    self.configureVolunteerView(animated: true)
                }
            }
        }
    }
    
    func styleView() {
        self.tableViewHeaderEventsDescriptionLabel.font = UIFont.tgkSubtitle
        self.tableViewHeaderEventsDescriptionLabel.textColor = UIColor.tgkBlue
        
        self.tableViewBottomDividerView.backgroundColor = UIColor.tgkBackgroundGray
        
        self.learnMoreButton.titleLabel?.font = UIFont.tgkBody
        self.learnMoreButton.setTitleColor(UIColor.tgkOrange, for: .normal)
        
        self.volunteerView.backgroundColor = UIColor.tgkBlue
        self.volunteerTextButton.titleLabel?.font = UIFont.tgkBody
        self.volunteerTextButton.titleLabel?.minimumScaleFactor = 0.7
    }
    
    @IBAction func learnMorePressed(_ sender: Any) {
        if let url = URL(string: "https://thegivingkitchen.org/events/") {
            let learnMoreVC = TGKSafariViewController(url: url)
            self.present(learnMoreVC, animated:true)
        }
    }
    
    @IBAction func volunteerCloseButton(_ sender: Any) {
        AppDataStore.hasClosedEventHomeVolunteerButton = true
        self.configureVolunteerView(animated: true)
    }
    
    @IBAction func volunteerConfirmButton(_ sender: Any) {
        guard let formModel = self.volunteerFormModel else {
            return
        }
        
        let segmentedNav = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormNavigationControllerId") as! SegmentedFormNavigationController
        segmentedNav.segmentedFormModel = formModel
        segmentedNav.formDelegate = self
        self.present(segmentedNav, animated: true)
    }
    
    private func configureVolunteerView(animated:Bool) {
        
        var targetHeight:CGFloat = AppDataStore.hasClosedEventHomeVolunteerButton ? 0 : 44.0
        targetHeight = self.volunteerFormModel == nil ? 0 : targetHeight
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.volunteerViewHeightConstraint.constant = targetHeight
                self.view.layoutIfNeeded()
            }
        }
        else {
            self.volunteerViewHeightConstraint.constant = targetHeight
            self.view.layoutIfNeeded()
        }
    }
}

//MARK: UITableView delegate and datasource
extension EventsHomeViewController:UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventCellReuseId = "eventCellReuseId"
        let eventCell = tableView.dequeueReusableCell(withIdentifier: eventCellReuseId) as! CalendarEventOverviewTableViewCell
        eventCell.calendarEventModel = self.calendarEventModels[indexPath.row]
        eventCell.selectionStyle = .none
        return eventCell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.calendarEventModels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! CalendarEventOverviewTableViewCell
        guard let urlString = cell.calendarEventModel.urlString,
            let eventUrl = URL(string: urlString) else {
            return
        }
        let tgkSafariVC = TGKSafariViewController(url: eventUrl)
        self.present(tgkSafariVC, animated: true)
        
        Analytics.logEvent(customName: .eventViewDetails, parameters: [.eventViewDetailsEventUrl:eventUrl.absoluteString,
                                                                       .eventViewDetailsEventName:cell.calendarEventModel.title])
    }
}

//MARK: SegmentedFormNavigationControllerDelegate
extension EventsHomeViewController:SegmentedFormNavigationControllerDelegate {
    func segmentedFormNavigationControllerDidFinish(viewController: SegmentedFormNavigationController) {
        viewController.dismiss(animated: true)
        AppDataStore.hasClosedEventHomeVolunteerButton = true
        self.configureVolunteerView(animated: true)
    }
}
