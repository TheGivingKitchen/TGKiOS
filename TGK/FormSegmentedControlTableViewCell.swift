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
    
    var delegate: FormItemViewDelegate?
    var formQuestion: FormQuestionModel! {
        didSet {
            self.configureView()
        }
    }
    
    var mainInputControl: UIView {
        return self.segmentedControl
    }
    
    var formItemOutputValue: String? {
        return self.segmentedControl.titleForSegment(at: self.segmentedControl.selectedSegmentIndex)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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

