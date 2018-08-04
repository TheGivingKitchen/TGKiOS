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
    }
}

//MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension AssistanceHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case AssistanceHomeRowIndex.overview.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.overviewCellReuseId, for: indexPath) as! AssistanceOverviewCollectionViewCell
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
extension AssistanceHomeViewController: AssistanceFormsCollectionViewCellDelegate {
    func assistanceFormsCellDidSelectMultiplyJoyForm(cell: AssistanceFormsCollectionViewCell) {
        print("multiply")
    }
    
    func assistanceFormsCellDidSelectVolunteerForm(cell: AssistanceFormsCollectionViewCell) {
        print("volunteer")
    }
}
