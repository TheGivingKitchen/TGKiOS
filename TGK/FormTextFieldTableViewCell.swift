//
//  FormTextFieldTableViewCell.swift
//  WufooPOC
//
//  Created by Jay Park on 4/7/18.
//  Copyright © 2018 ThoughtSeize. All rights reserved.
//

import UIKit
import Foundation

class FormTextFieldTableViewCell: UITableViewCell, FormItemView {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    ///Begin FormItemView conformance
    var delegate: FormItemViewDelegate?
    var formQuestion: FormQuestionModel! {
        didSet {
            self.configureView()
        }
    }
    var mainInputControl: UIView {
        return self.textField
    }
    var formItemOutputValue: [FormQuestionAnswerModel] {
        
        var answerText:String? = nil
        switch self.inputType {
        case .unspecifiedText:
            answerText = self.textField.text
        case .email:
            answerText = self.textField.text
        case .phoneNumber:
            answerText = self.textField.text?.components(separatedBy: CharacterSet.decimalDigits.inverted)
                .joined()
        case .fullName:
            answerText = self.textField.text
        case .jobTitle:
            answerText = self.textField.text
        }
        
        let answerModel = FormQuestionAnswerModel(wufooFieldID: self.formQuestion.id, userAnswer: answerText)
        return [answerModel]
    }
    
    func showError(_ error: FormFieldErrorModel) {
        self.backgroundColor = UIColor.red
    }
    ///End FormItemView conformance
    
    enum TextInputType {
        case unspecifiedText
        case email
        case phoneNumber
        case fullName
        case jobTitle
    }
    
    var inputType:TextInputType = .unspecifiedText {
        didSet {
            self.formatTextFieldBasedOnInputType()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //style
        self.questionLabel.font = UIFont.tgkBody
        self.questionLabel.textColor = UIColor.tgkDarkGray
        self.textField.font = UIFont.tgkBody
        self.textField.layer.borderColor = UIColor.tgkOutline.cgColor
        self.textField.layer.borderWidth = 1
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        self.textField.leftViewMode = UITextFieldViewMode.always
        self.textField.leftView = spacerView
        
        self.textField.delegate = self
    }
    
    private func configureView() {
        self.questionLabel.text = self.formQuestion.questionTitle
        self.formatTextFieldBasedOnInputType()
    }
}

//validation and formatting
extension FormTextFieldTableViewCell: UITextFieldDelegate {
    func formatTextFieldBasedOnInputType() {
        switch self.inputType {
        case .unspecifiedText:
            self.textField.textContentType = UITextContentType("")
            self.textField.keyboardType = .default
            self.textField.autocapitalizationType = .sentences
            break
        case .email:
            self.textField.textContentType = UITextContentType.emailAddress
            self.textField.keyboardType = .emailAddress
            self.textField.autocapitalizationType = .none
            break
        case .phoneNumber:
            self.textField.textContentType = UITextContentType.telephoneNumber
            self.textField.keyboardType = .phonePad
            self.textField.autocapitalizationType = .none
            break
        case .fullName:
            self.textField.textContentType = UITextContentType.name
            self.textField.keyboardType = .asciiCapable
            self.textField.autocapitalizationType = .words
            break
        case .jobTitle:
            self.textField.textContentType = UITextContentType.jobTitle
            self.textField.keyboardType = .default
            self.textField.autocapitalizationType = .words
            break
        }
    }

    //textField delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch self.inputType {
        case .unspecifiedText:
            return true
        case .email:
            return true
        case .phoneNumber:
            //workaround for multiple entries caused by inserting predictive text
            if string == "" || string == " " {
                return true
            }
            let fullString = textField.text! + string
            if fullString.count > 15 {
                return false
            }
            textField.text = fullString.formatStringToPhoneNumber()
            return false
        case .fullName:
            return true
        case .jobTitle:
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let delegate = self.delegate {
            textField.resignFirstResponder()
            delegate.formItemViewDidPressReturn(self)
        }
        return false
    }
}
