//
//  FormSegmentedControlTableViewCell.swift
//  WufooPOC
//
//  Created by Jay Park on 4/7/18.
//  Copyright © 2018 ThoughtSeize. All rights reserved.
//

import UIKit

class FormSegmentedControlTableViewCell: UITableViewCell, FormItemView {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var hasOtherFieldView: UIView! {
        didSet {
            hasOtherFieldView.isHidden = true
        }
    }
    @IBOutlet weak var hasOtherFieldTextView: UITextField!
    
    //MARK: FormItemView conformance
    var delegate: FormItemViewDelegate?
    var formQuestion: FormQuestionModel! {
        didSet {
            self.configureView()
        }
    }
    
    var mainInputControl: UIView {
        return self.segmentedControl
    }
    
    var hasOtherSelected:Bool {
        if self.formQuestion.hasOtherField == false {
            return false
        }
        if self.segmentedControl.selectedSegmentIndex == self.formQuestion.answerOptions.count - 1 {
            return true
        }
        return false
    }
    
    var formItemOutputValue: [FormQuestionAnswerModel] {
        let answerText = self.segmentedControl.titleForSegment(at: self.segmentedControl.selectedSegmentIndex)
        
        
        let answerModel = self.hasOtherSelected ? FormQuestionAnswerModel(wufooFieldID: self.formQuestion.id, userAnswer: self.hasOtherFieldTextView.text) : FormQuestionAnswerModel(wufooFieldID: self.formQuestion.id, userAnswer: answerText)
        
        return [answerModel]
    }
    //End FormItemView conformance
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.segmentedControl.addTarget(self, action: #selector(segmentedControlDidChangeSegment(sender:)), for: .valueChanged)
    }
    
    private func configureView() {
        self.questionLabel.text = self.formQuestion.questionTitle
        self.segmentedControl.removeAllSegments()
        for index in 0..<self.formQuestion.answerOptions.count {
            let option = self.formQuestion.answerOptions[index]
            self.segmentedControl.insertSegment(withTitle: option, at: index, animated: false)
        }
        if self.segmentedControl.numberOfSegments > 0 {
            self.segmentedControl.selectedSegmentIndex = 0
        }
    }
}

//MARK: hasOtherField
extension FormSegmentedControlTableViewCell {
    //if we're on the last segment and hasOtherField flag is enabled, then show text input
    @objc func segmentedControlDidChangeSegment(sender: UISegmentedControl) {
        
        if self.hasOtherSelected && self.formQuestion.hasOtherField == true {
            self.hasOtherFieldView.isHidden = false
        }
        else {
            self.hasOtherFieldView.isHidden = true
        }
        self.delegate?.formSegmentedControlTableViewCellRequestTableViewUpdates(self)
    }
}


