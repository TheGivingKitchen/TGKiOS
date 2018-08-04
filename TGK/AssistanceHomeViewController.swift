//
//  AssistanceHomeViewController.swift
//  TGK
//
//  Created by Jay Park on 6/6/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

class AssistanceHomeViewController: UIViewController {
    
    enum AssistanceHomeRowIndex:Int {
        case overview = 0
        case forms = 1
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    let overviewCellReuseId = "homeCellReusdeId"
    let formsCellReuseId = "formsCellReuseId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(UINib(nibName: "AssistanceOverviewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.overviewCellReuseId)
        self.collectionView.register(UINib(nibName: "AssistanceFormsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.formsCellReuseId)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.fetchCellFormsIfNeeded()
    }
    
    func fetchCellFormsIfNeeded() {
        if let overviewCell = self.collectionView.cellForItem(at: IndexPath(row: AssistanceHomeRowIndex.overview.rawValue, section: 0)) as? AssistanceOverviewCollectionViewCell {
            if overviewCell.assistanceSelfFormModel == nil || overviewCell.assistanceReferralFormModel == nil {
                overviewCell.fetchForms()
            }
        }
        
        if let formsCell = self.collectionView.cellForItem(at: IndexPath(row: AssistanceHomeRowIndex.forms.rawValue, section: 0)) as? AssistanceFormsCollectionViewCell {
            print("here")
            if formsCell.volunteerFormModel == nil || formsCell.multiplyJoyModel == nil {
                formsCell.fetchForms()
            }
        }
    }
}

//MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension AssistanceHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case AssistanceHomeRowIndex.overview.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.overviewCellReuseId, for: indexPath) as! AssistanceOverviewCollectionViewCell
            cell.delegate = self
            return cell
        case AssistanceHomeRowIndex.forms.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.formsCellReuseId, for: indexPath) as! AssistanceFormsCollectionViewCell
            cell.delegate = self
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK:AssistanceFormsCollectionViewCellDelegate
extension AssistanceHomeViewController: AssistanceOverviewCollectionViewCellDelegate {
    func assistanceOverviewCollectionViewCellAssistanceForSelfPressed(cell: AssistanceOverviewCollectionViewCell) {
        guard let inquiryForm = cell.assistanceSelfFormModel else {
            return
        }
        
        let segmentedNav = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormNavigationControllerId") as! SegmentedFormNavigationController
        segmentedNav.segmentedFormModel = inquiryForm
        self.present(segmentedNav, animated: true)
    }
    
    func assistanceOverviewCollectionViewCellAssistanceReferralPressed(cell: AssistanceOverviewCollectionViewCell) {
        guard let inquiryForm = cell.assistanceReferralFormModel else {
            return
        }
        
        let segmentedNav = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormNavigationControllerId") as! SegmentedFormNavigationController
        segmentedNav.segmentedFormModel = inquiryForm
        self.present(segmentedNav, animated: true)
    }
}
extension AssistanceHomeViewController: AssistanceFormsCollectionViewCellDelegate {
    func assistanceFormsCellDidSelectMultiplyJoyForm(cell: AssistanceFormsCollectionViewCell) {
        guard let inquiryForm = cell.multiplyJoyModel else {
            return
        }
        
        let segmentedNav = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormNavigationControllerId") as! SegmentedFormNavigationController
        segmentedNav.segmentedFormModel = inquiryForm
        self.present(segmentedNav, animated: true)
    }
    
    func assistanceFormsCellDidSelectVolunteerForm(cell: AssistanceFormsCollectionViewCell) {
        guard let inquiryForm = cell.volunteerFormModel else {
            return
        }
        
        let segmentedNav = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormNavigationControllerId") as! SegmentedFormNavigationController
        segmentedNav.segmentedFormModel = inquiryForm
        self.present(segmentedNav, animated: true)
    }
    
    func assistanceFormsCellDidSelectMultiplyJoyShare(cell: AssistanceFormsCollectionViewCell) {
        ExternalShareManager.sharedInstance.presentShareControllerFromViewController(fromController: self, title: "Help restaurant workers in need", urlString: "https://thegivingkitchen.wufoo.com/forms/multiply-joy-inquiry/", image: UIImage(named: "tgkShareIcon"))
    }
    
    func assistanceFormsCellDidSelectVolunteerShare(cell: AssistanceFormsCollectionViewCell) {
        ExternalShareManager.sharedInstance.presentShareControllerFromViewController(fromController: self, title: "Sign up to be a Giving Kitchen Volunteer!", urlString: "https://thegivingkitchen.wufoo.com/forms/gk-volunteer-survey/", image: UIImage(named: "tgkShareIcon"))
    }
}
