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
    
    //MARK: FormItemView
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
                    let answerText = self.formQuestion.answerOptions[index]
                    answerModels.append(FormQuestionAnswerModel(wufooFieldID: self.formQuestion.id, userAnswer: answerText))
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureView() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.questionLabel.text = self.formQuestion.questionTitle
        
        //clear out existing stuff
        for row in self.rows {
            self.stackView.removeArrangedSubview(row)
            row.removeFromSuperview()
        }
        self.rows = []
        
        switch self.selectionType {
            //if we're single selection, then it's a radio button and choices are populated from "answer choices"
        case .single:
            for answerChoice in self.formQuestion.answerOptions {
                let answerChoiceRow = FormListSelectTableViewCellRow(frame: CGRect(x: 0, y: 0, width: self.stackView.frame.size.width, height: 44.0))
                answerChoiceRow.choiceLabel.text = answerChoice
                self.stackView.addArrangedSubview(answerChoiceRow)
                answerChoiceRow.delegate = self
                self.rows.append(answerChoiceRow)
            }
            break
            //if we're multiple selection, then it's a checkbox and choices are populated form subfields
        case .multiple:
            for subfield in self.formQuestion.subfields {
                let answerChoiceRow = FormListSelectTableViewCellRow(frame: CGRect(x: 0, y: 0, width: self.stackView.frame.size.width, height: 44.0))
                answerChoiceRow.choiceLabel.text = subfield.label
                self.stackView.addArrangedSubview(answerChoiceRow)
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
            let numberOfSelectedRows = self.rows.filter { (row) -> Bool in
                return row.isSelected
            }.count
            
            guard numberOfSelectedRows > 1 else {
                return
            }
            
            guard let rowIndex = self.rows.index(of: cell) else {
                return
            }
            
            for index in 0..<self.rows.count {
                if rowIndex == index {
                    continue
                }
                self.rows[index].isSelected = false
            }
            break
        }
    }
}
