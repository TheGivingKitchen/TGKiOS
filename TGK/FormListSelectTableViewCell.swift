//
//  FormListSelectTableViewCell.swift
//  WufooPOC
//
//  Created by Jay Park on 4/27/18.
//  Copyright © 2018 ThoughtSeize. All rights reserved.
//

import UIKit

class FormListSelectTableViewCell: UITableViewCell, FormItemView {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var hasOtherFieldView: UIView!
        {
        didSet {
            hasOtherFieldView.isHidden = true
        }
    }
    @IBOutlet weak var hasOtherFieldTextField: UITextField!
    
    
    //MARK: FormItemView
    @IBOutlet weak var errorMessageLabel: UILabel! {
        didSet {
            self.hideErrorState()
        }
    }
    
    var delegate: FormItemViewDelegate?
    var formQuestion: FormQuestionModel! {
        didSet {
            self.configureView()
        }
    }
    
    var formItemOutputValue: [FormQuestionAnswerModel]
    {
        let numberOfSelectedRows = self.rows.filter { (row) -> Bool in
            return row.isSelected
            }.count
        
        if numberOfSelectedRows == 0 {
            return []
        }
        
        switch self.selectionType {
        case .single:
            //this field allows "hasOtherField", so if thats selected, return that answer
            if self.hasOtherSelected {
                let answerModel = FormQuestionAnswerModel(wufooFieldID: self.formQuestion.id, userAnswer: self.hasOtherFieldTextField.text)
                return [answerModel]
            }
            //Always return the first selected index in case multiple selection slipped through
            for index in 0..<self.rows.count {
                let row = self.rows[index]
                if row.isSelected {
                    let answerText = self.formQuestion.answerOptions[index]
                    return [FormQuestionAnswerModel(wufooFieldID: self.formQuestion.id, userAnswer: answerText)]
                }
            }
            return []
        case .multiple://TODO change once we know what multiple looks like
            var answerModels = [FormQuestionAnswerModel]()
            for index in 0..<self.rows.count {
                let row = self.rows[index]
                if row.isSelected {
                    let answerText = self.formQuestion.subfields[index].label
                    let subfieldId = self.formQuestion.subfields[index].id
                    answerModels.append(FormQuestionAnswerModel(wufooFieldID: subfieldId, userAnswer: answerText))
                }
            }
            return answerModels
        }
    }
    
    var mainInputControl: UIView {
        return self.stackView
    }
    //end FormItemView
    
    var rows = [FormListSelectTableViewCellRow]()
    enum SelectionType {
        case single
        case multiple
    }
    var selectionType:SelectionType = .multiple {
        didSet {
            self.configureView()
        }
    }
    
    var hasOtherSelected:Bool {
        if self.formQuestion.hasOtherField == false {
            return false
        }
        
        if self.rows.count > 0 {
            let lastRow = self.rows[self.rows.count - 1]
            return lastRow.isSelected
        }
        
        return false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //style
        self.questionLabel.font = UIFont.tgkBody
        self.questionLabel.textColor = UIColor.tgkDarkGray
        self.hasOtherFieldView.backgroundColor = UIColor.tgkLightGray
        self.hasOtherFieldTextField.font = UIFont.tgkBody
        self.hasOtherFieldTextField.backgroundColor = UIColor.white
        self.hasOtherFieldTextField.layer.borderWidth = 1
        self.hasOtherFieldTextField.layer.borderColor = UIColor.tgkNavy.cgColor
        self.hasOtherFieldTextField.textColor = UIColor.tgkDarkGray
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        self.hasOtherFieldTextField.leftViewMode = UITextFieldViewMode.always
        self.hasOtherFieldTextField.leftView = spacerView
        self.errorMessageLabel.font = UIFont.tgkMetadata
        self.errorMessageLabel.textColor = UIColor.tgkPeach
    }
    
    func configureView() {
        self.questionLabel.text = self.formQuestion.questionTitle
        
        //clear out existing stuff
        for row in self.rows {
            self.stackView.removeArrangedSubview(row)
            row.removeFromSuperview()
        }
        self.rows = []
        let rowHeight:CGFloat = 60.0
        switch self.selectionType {
            //if we're single selection, then it's a radio button and choices are populated from "answer choices"
        case .single:
            for answerChoice in self.formQuestion.answerOptions {
                let answerChoiceRow = FormListSelectTableViewCellRow(frame: CGRect(x: 0, y: 0, width: self.stackView.frame.size.width, height: rowHeight))
                answerChoiceRow.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
                answerChoiceRow.choiceLabel.text = answerChoice
                //insert right before the last subview. The last subview is the "hasOtherField" textView
                self.stackView.insertArrangedSubview(answerChoiceRow, at: self.stackView.arrangedSubviews.count - 1)
                answerChoiceRow.delegate = self
                self.rows.append(answerChoiceRow)
                
                //Auto-select the first row for single selection
                if self.rows.count > 0 {
                    self.rows[0].isSelected = true
                }
            }
            break
            //if we're multiple selection, then it's a checkbox and choices are populated form subfields
        case .multiple:
            for subfield in self.formQuestion.subfields {
                let answerChoiceRow = FormListSelectTableViewCellRow(frame: CGRect(x: 0, y: 0, width: self.stackView.frame.size.width, height: rowHeight))
                answerChoiceRow.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
                answerChoiceRow.choiceLabel.text = subfield.label
                //insert right before the last subview. The last subview is the "hasOtherField" textView
                self.stackView.insertArrangedSubview(answerChoiceRow, at: self.stackView.arrangedSubviews.count - 1)
                answerChoiceRow.delegate = self
                self.rows.append(answerChoiceRow)
            }
            break
        }
    }
}

extension FormListSelectTableViewCell: FormListSelectTableViewCellRowDelegate {
    func formListSelectTableViewCellRowWasSelected(cell: FormListSelectTableViewCellRow) {
        switch  self.selectionType {
        case .multiple:
            break
        case .single:
            //Deselect all other rows
            guard let rowIndex = self.rows.index(of: cell) else {
                return
            }
            
            for index in 0..<self.rows.count {
                if rowIndex == index {
                    continue
                }
                self.rows[index].isSelected = false
            }
            
            //if we're on the last segment and hasOtherField flag is enabled, then show text input
            if self.hasOtherSelected && self.formQuestion.hasOtherField == true && self.hasOtherFieldView.isHidden == true {
                self.hasOtherFieldView.isHidden = false
                self.hasOtherFieldTextField.becomeFirstResponder()
                self.delegate?.formItemViewRequestTableViewUpdates(self)
            }
            else {
                if self.hasOtherFieldView.isHidden == false {
                    self.hasOtherFieldView.isHidden = true
                    self.hasOtherFieldTextField.resignFirstResponder()
                    self.delegate?.formItemViewRequestTableViewUpdates(self)
                }
            }
            break
        }
    }
}
