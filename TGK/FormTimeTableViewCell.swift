//
//  FormTimeTableViewCell.swift
//  TGK
//
//  Created by Jay Park on 9/4/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

class FormTimeTableViewCell: UITableViewCell, FormItemView {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerTopOutlineView: UIView!
    @IBOutlet weak var pickerBottomOutlineView: UIView!
    
    private let dateFormater = DateFormatter()
    
    //MARK: FormItemView
    @IBOutlet weak var errorMessageLabel: UILabel! {
        didSet {
            self.hideErrorState()
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
        self.dateFormater.dateFormat = "HH:mm:ss"
        
        self.styleView()
    }
    
    func styleView() {
        self.questionLabel.font = UIFont.tgkBody
        self.questionLabel.textColor = UIColor.tgkDarkDarkGray
        self.pickerTopOutlineView.backgroundColor = UIColor.tgkOutline
        self.pickerBottomOutlineView.backgroundColor = UIColor.tgkOutline
        self.errorMessageLabel.font = UIFont.tgkMetadata
        self.errorMessageLabel.textColor = UIColor.tgkOrange
    }
    
    private func configureView() {
        self.questionLabel.text = self.formQuestion.isRequired ? self.formQuestion.questionTitle + "*" : self.formQuestion.questionTitle
    }
}
