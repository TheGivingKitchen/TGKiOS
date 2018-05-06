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
    
    var delegate: FormItemViewDelegate?
    var formQuestion: FormQuestionModel!{
        didSet {
            self.configureView()
        }
    }
    
    var formItemOutputValue: String? {
        guard self.formQuestion.answerOptions.count > 0 else {
            return nil
        }
        return self.formQuestion.answerOptions[self.picker.selectedRow(inComponent: 0)]
    }
    
    var mainInputControl: UIView {
        return self.picker
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let option = self.formQuestion.answerOptions[row]
        return option
    }
}
