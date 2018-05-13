//
//  FormNameTableViewCell.swift
//  TGK
//
//  Created by Jay Park on 5/13/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

class FormShortNameTableViewCell: UITableViewCell, FormItemView {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    //MARK: FormItemView
    var delegate: FormItemViewDelegate?
    var formQuestion: FormQuestionModel! {
        didSet {
            self.configureView()
        }
    }
    
    var formItemOutputValue: [FormQuestionAnswerModel]
    {
        var answerModels = [FormQuestionAnswerModel]()

        if let firstName = self.firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            firstName.isEmpty == false,
            self.formQuestion.subfields.count >= 1 {
            let firstNameFieldId = self.formQuestion.subfields[0].id
            let firstNameAnswerModel = FormQuestionAnswerModel(wufooFieldID: firstNameFieldId, userAnswer: firstName)
            answerModels.append(firstNameAnswerModel)
        }
        if let lastName = self.lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            lastName.isEmpty == false,
            self.formQuestion.subfields.count >= 2 {
            let lastNameFieldId = self.formQuestion.subfields[1].id
            let lastNameAnswerModel = FormQuestionAnswerModel(wufooFieldID: lastNameFieldId, userAnswer: lastName)
            answerModels.append(lastNameAnswerModel)
        }
        
        return answerModels
    }
    
    var mainInputControl: UIView {
        return self.firstNameTextField
    }
    //end FormItemView
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func configureView() {
        self.questionLabel.text = self.formQuestion.questionTitle
        
        guard self.formQuestion.subfields.count >= 2 else {
            return
        }
        
        let firstNameSubfield = self.formQuestion.subfields[0]
        self.firstNameTextField.placeholder = firstNameSubfield.label
        let lastNameSubfield = self.formQuestion.subfields[1]
        self.lastNameTextField.placeholder = lastNameSubfield.label
    }

}
