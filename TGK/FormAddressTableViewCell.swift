//
//  FormAddressTableViewCell.swift
//  TGK
//
//  Created by Jay Park on 5/13/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

//Probably the most fragile view due to hardcoding. Everything breaks here if the form subfields != 6 or if they are unordered, but it seems low risk considering wufoo's history
class FormAddressTableViewCell: UITableViewCell, FormItemView {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var address1Label: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    
    //MARK: FormItemView
    var delegate: FormItemViewDelegate?
    var formQuestion: FormQuestionModel! {
        didSet {
            self.configureView()
        }
    }
    
    var formItemOutputValue: [FormQuestionAnswerModel]
    {
        guard self.formQuestion.subfields.count == 6 else {
            return []
        }
        
        var answerModels = [FormQuestionAnswerModel]()
        
        if let address1 = self.address1TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            address1.isEmpty == false {
            let address1FieldId = self.formQuestion.subfields[0].id
            let address1AnswerModel = FormQuestionAnswerModel(wufooFieldID: address1FieldId, userAnswer: address1)
            answerModels.append(address1AnswerModel)
        }
        if let address2 = self.address1TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            address2.isEmpty == false {
            let address2FieldId = self.formQuestion.subfields[1].id
            let address2AnswerModel = FormQuestionAnswerModel(wufooFieldID: address2FieldId, userAnswer: address2)
            answerModels.append(address2AnswerModel)
        }
        if let city = self.address1TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            city.isEmpty == false {
            let cityFieldId = self.formQuestion.subfields[2].id
            let cityModel = FormQuestionAnswerModel(wufooFieldID: cityFieldId, userAnswer: city)
            answerModels.append(cityModel)
        }
        if let state = self.address1TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            state.isEmpty == false {
            let stateFieldId = self.formQuestion.subfields[3].id
            let stateModel = FormQuestionAnswerModel(wufooFieldID: stateFieldId, userAnswer: state)
            answerModels.append(stateModel)
        }
        if let zip = self.address1TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            zip.isEmpty == false {
            let zipFieldId = self.formQuestion.subfields[4].id
            let zipModel = FormQuestionAnswerModel(wufooFieldID: zipFieldId, userAnswer: zip)
            answerModels.append(zipModel)
        }
        
        let countryFieldId = self.formQuestion.subfields[5].id
        answerModels.append(FormQuestionAnswerModel(wufooFieldID: countryFieldId, userAnswer: "United States"))
        
        return answerModels
    }
    
    var mainInputControl: UIView {
        return self.address1Label
    }
    //end formItemView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //style
        self.questionLabel.font = UIFont.tgkBody
        self.questionLabel.textColor = UIColor.tgkDarkGray
        self.address1Label.font = UIFont.tgkBody
        self.address1Label.textColor = UIColor.tgkDarkGray
        self.address1TextField.font = UIFont.tgkBody
        self.address1TextField.textColor = UIColor.tgkDarkGray
        self.address2Label.font = UIFont.tgkBody
        self.address2Label.textColor = UIColor.tgkDarkGray
        self.address2TextField.font = UIFont.tgkBody
        self.address2TextField.textColor = UIColor.tgkDarkGray
        self.cityLabel.font = UIFont.tgkBody
        self.cityLabel.textColor = UIColor.tgkDarkGray
        self.cityTextField.font = UIFont.tgkBody
        self.cityTextField.textColor = UIColor.tgkDarkGray
        self.stateLabel.font = UIFont.tgkBody
        self.stateLabel.textColor = UIColor.tgkDarkGray
        self.stateTextField.font = UIFont.tgkBody
        self.stateTextField.textColor = UIColor.tgkDarkGray
        self.zipLabel.font = UIFont.tgkBody
        self.zipLabel.textColor = UIColor.tgkDarkGray
        self.zipTextField.font = UIFont.tgkBody
        self.zipTextField.textColor = UIColor.tgkDarkGray
    }

    private func configureView() {
        self.questionLabel.text = self.formQuestion.questionTitle
        
        guard self.formQuestion.subfields.count == 6 else {
            return
        }
        
        let address1Subfield = self.formQuestion.subfields[0]
        self.address1Label.text = address1Subfield.label
        
        let address2Subfield = self.formQuestion.subfields[1]
        self.address2Label.text = address2Subfield.label
        
        let citySubfield = self.formQuestion.subfields[2]
        self.cityLabel.text = citySubfield.label
        
        let stateSubfield = self.formQuestion.subfields[3]
        self.stateLabel.text = stateSubfield.label
        
        let zipSubfield = self.formQuestion.subfields[4]
        self.zipLabel.text = zipSubfield.label
    }

}
