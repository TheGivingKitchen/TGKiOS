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

class EventsHomeViewController: UITableViewController {
    
    var calendarEventModels = [RSSCalendarEventModel]()
    @IBOutlet weak var tableViewHeaderEventsLabel: UILabel!
    @IBOutlet weak var tableViewHeaderEventsDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
        self.styleView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedSectionHeaderHeight = UITableViewAutomaticDimension
        
        self.fetchData()
    }
    
    func fetchData() {
        ServiceManager.sharedInstace.getEventFeed { (calendarEventModels, error) in
            if let calendarEventModels = calendarEventModels {
                self.calendarEventModels = calendarEventModels
                self.tableView.reloadData()
            }
            else if let error = error {
                print(error)
            }
        }
    }
    
    func styleView() {
        self.tableViewHeaderEventsLabel.font = UIFont.tgkSubtitle
        self.tableViewHeaderEventsLabel.textColor = UIColor.tgkOrange
        
        self.tableViewHeaderEventsDescriptionLabel.font = UIFont.tgkBody
        self.tableViewHeaderEventsDescriptionLabel.textColor = UIColor.tgkBlue
    }
}

//MARK: UITableView delegate and datasource
extension EventsHomeViewController {

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventCellReuseId = "eventCellReuseId"
        let eventCell = tableView.dequeueReusableCell(withIdentifier: eventCellReuseId) as! CalendarEventOverviewTableViewCell
        eventCell.calendarEventModel = self.calendarEventModels[indexPath.row]
        eventCell.selectionStyle = .none
        return eventCell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.calendarEventModels.count
    }
    
    //TODO testing this. ask Izu how this interaction should work, of if we should do it at all
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! CalendarEventOverviewTableViewCell
        guard let urlString = cell.calendarEventModel.urlString,
            let eventUrl = URL(string: urlString) else {
            return
        }
        let tgkSafariVC = TGKSafariViewController(url: eventUrl)
        self.present(tgkSafariVC, animated: true)
        
    }
}
