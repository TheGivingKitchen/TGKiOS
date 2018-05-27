//
//  FormDateTableViewCell.swift
//  TGK
//
//  Created by Jay Park on 5/13/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

class FormDateTableViewCell: UITableViewCell, FormItemView {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerTopOutlineView: UIView!
    @IBOutlet weak var pickerBottomOutlineView: UIView!
    
    private let dateFormater = DateFormatter()
    
    //MARK: FormItemView
    @IBOutlet weak var errorMessageLabel: UILabel! {
        didSet {
            self.errorMessageLabel.isHidden = true
        }
    }
    
    var delegate: FormItemViewDelegate?
    var formQuestion: FormQuestionModel!{
        didSet {
            self.configureView()
        }
    }
    
    var formItemOutputValue: [FormQuestionAnswerModel] {
        let dateString = self.dateFormater.string(from: self.datePicker.date)
        let answerModel = FormQuestionAnswerModel(wufooFieldID: self.formQuestion.id, userAnswer: dateString)
        return [answerModel]
    }
    
    var mainInputControl: UIView {
        return self.datePicker
    }
    //end FormItemView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //style
        self.questionLabel.font = UIFont.tgkBody
        self.questionLabel.textColor = UIColor.tgkDarkGray
        self.pickerTopOutlineView.backgroundColor = UIColor.tgkOutline
        self.pickerBottomOutlineView.backgroundColor = UIColor.tgkOutline
        self.errorMessageLabel.font = UIFont.tgkMetadata
        self.errorMessageLabel.textColor = UIColor.tgkPeach
        
        self.dateFormater.dateFormat = "yyyyMMdd" 
    }

    private func configureView() {
        
    }
}
