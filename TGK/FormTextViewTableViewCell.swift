//
//  FormTextViewTableViewCell.swift
//  WufooPOC
//
//  Created by Jay Park on 4/8/18.
//  Copyright © 2018 ThoughtSeize. All rights reserved.
//

import UIKit

class FormTextViewTableViewCell: UITableViewCell, FormItemView {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var delegate: FormItemViewDelegate?
    var formQuestion: FormQuestionModel! {
        didSet {
            self.configureView()
        }
    }
    
    var formItemOutputValue: [FormQuestionAnswerModel]
    {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let answerModel = FormQuestionAnswerModel(wufooFieldID: self.formQuestion.id, userAnswer: text)
        return [answerModel]
    }
    
    var mainInputControl: UIView {
        return self.textView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.layer.borderWidth = 1
        self.textView.layer.borderColor = UIColor.black.cgColor
    }

    private func configureView() {
        self.questionLabel.text = self.formQuestion.questionTitle
    }
}
