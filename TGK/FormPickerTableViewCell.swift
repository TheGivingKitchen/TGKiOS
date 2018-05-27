//
//  FormPickerTableViewCell.swift
//  WufooPOC
//
//  Created by Jay Park on 4/8/18.
//  Copyright © 2018 ThoughtSeize. All rights reserved.
//

import UIKit

class FormPickerTableViewCell: UITableViewCell, FormItemView {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var pickerBottomOutlineView: UIView!
    @IBOutlet weak var pickerTopOutlineView: UIView!
    
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
        guard self.formQuestion.answerOptions.count > 0 else {
            return []
        }
        let answerModel = FormQuestionAnswerModel(wufooFieldID: self.formQuestion.id, userAnswer: self.formQuestion.answerOptions[self.picker.selectedRow(inComponent: 0)])
        return [answerModel]
    }
    
    var mainInputControl: UIView {
        return self.picker
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
        
        self.picker.dataSource = self
        self.picker.delegate = self
    }
    
    private func configureView() {
        self.questionLabel.text = self.formQuestion.questionTitle
    }
}

extension FormPickerTableViewCell:UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.formQuestion.answerOptions.count
    }
}

extension FormPickerTableViewCell:UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let option = self.formQuestion.answerOptions[row]
        let attributedOption = NSAttributedString(string: option, attributes: [NSAttributedStringKey.font:UIFont.tgkBody, NSAttributedStringKey.foregroundColor:UIColor.tgkDarkGray])
        return attributedOption
    }
}
