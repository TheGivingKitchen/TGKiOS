//
//  StabilityNetCategoryFilterTableViewCell.swift
//  TGK
//
//  Created by Jay Park on 8/18/19.
//  Copyright © 2019 TheGivingKitchen. All rights reserved.
//

import UIKit

protocol StabilityNetCategoryFilterTableViewCellDelegate:class {
    func stabilityNetCategoryFilterTableViewCellDidSelect(category:String)
    func stabilityNetCategoryFilterTableViewCellDidDeselect(category:String)
}

class StabilityNetCategoryFilterTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate:StabilityNetCategoryFilterTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.collectionView.allowsMultipleSelection = true
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension StabilityNetCategoryFilterTableViewCell:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SafetyNetResourceModel.allCategories.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "StabilityNetCatgeoryInfoCollectionViewCellId", for: indexPath) as! StabilityNetCatgeoryInfoCollectionViewCell
        cell.configureWith(category: SafetyNetResourceModel.allCategories[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collectionView.frame.size.width / 3.5), height: self.collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < SafetyNetResourceModel.allCategories.count else {
            return
        }
        let categoryString = SafetyNetResourceModel.allCategories[indexPath.row]
        print("select \(categoryString)")
        self.delegate?.stabilityNetCategoryFilterTableViewCellDidSelect(category: categoryString)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard indexPath.row < SafetyNetResourceModel.allCategories.count else {
            return
        }
        let categoryString = SafetyNetResourceModel.allCategories[indexPath.row]
        print("select \(categoryString)")
        self.delegate?.stabilityNetCategoryFilterTableViewCellDidDeselect(category: categoryString)
    }
}
