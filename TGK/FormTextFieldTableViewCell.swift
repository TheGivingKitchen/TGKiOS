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
    var mainInputControl: UIView {
        return self.textField
    }
    var formItemOutputValue: [FormQuestionAnswerModel] {
        
        var answerText:String? = nil
        switch self.inputType {
        case .unspecifiedText, .email, .fullName, .jobTitle, .currency, .url:
            answerText = self.textField.text
        case .phoneNumber, .number:
            answerText = self.textField.text?.formatStringToNumericString()
        }
        
        let answerModel = FormQuestionAnswerModel(wufooFieldID: self.formQuestion.id, userAnswer: answerText)
        return [answerModel]
    }
    ///End FormItemView conformance
    
    enum TextInputType {
        case unspecifiedText
        case email
        case phoneNumber
        case fullName
        case jobTitle
        case number
        case currency
        case url
    }
    
    var inputType:TextInputType = .unspecifiedText {
        didSet {
            self.formatTextFieldBasedOnInputType()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.styleView()
        self.textField.delegate = self
    }
    
    private func styleView() {
        self.questionLabel.font = UIFont.tgkBody
        self.questionLabel.textColor = UIColor.tgkDarkDarkGray
        self.textField.font = UIFont.tgkBody
        self.textField.layer.borderColor = UIColor.tgkOutline.cgColor
        self.textField.layer.borderWidth = 1
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        self.textField.leftViewMode = UITextFieldViewMode.always
        self.textField.leftView = spacerView
        self.errorMessageLabel.font = UIFont.tgkMetadata
        self.errorMessageLabel.textColor = UIColor.tgkOrange
    }
    
    private func configureView() {
        self.questionLabel.text = self.formQuestion.isRequired ? self.formQuestion.questionTitle + "*" : self.formQuestion.questionTitle
        self.formatTextFieldBasedOnInputType()
    }
    
    override func prepareForReuse() {
        self.textField.textContentType = UITextContentType("")
        self.textField.keyboardType = .default
        self.textField.autocapitalizationType = .sentences
        self.textField.placeholder = ""
        self.textField.autocorrectionType = .no
    }
}

///validation and formatting. Make sure to revert back to defaults in prepareForReuse()
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
            self.textField.autocorrectionType = .no
            self.textField.placeholder = "johnnyappleseed@gmail.com"
            break
        case .phoneNumber:
            self.textField.textContentType = UITextContentType.telephoneNumber
            self.textField.keyboardType = .phonePad
            self.textField.autocapitalizationType = .none
            self.textField.placeholder = "4045555555".formatStringToPhoneNumber()
            break
        case .fullName:
            self.textField.textContentType = UITextContentType.name
            self.textField.keyboardType = .asciiCapable
            self.textField.autocapitalizationType = .words
            self.textField.autocorrectionType = .no
            self.textField.placeholder = "Johnny Appleseed"
            break
        case .jobTitle:
            self.textField.textContentType = UITextContentType.jobTitle
            self.textField.keyboardType = .default
            self.textField.autocapitalizationType = .words
            self.textField.placeholder = "Line cook"
        case .number:
            self.textField.textContentType = UITextContentType("")
            self.textField.keyboardType = .phonePad
            self.textField.autocapitalizationType = .none
            self.textField.placeholder = "123"
            break
        case .currency:
            self.textField.textContentType = UITextContentType("")
            self.textField.keyboardType = .phonePad
            self.textField.autocapitalizationType = .none
            self.textField.placeholder = "$0.00"
            break
        case .url:
            self.textField.textContentType = UITextContentType.URL
            self.textField.keyboardType = .URL
            self.textField.autocapitalizationType = .none
            self.textField.autocorrectionType = .no
            self.textField.placeholder = "http://example.com"
            break
        }
    }

    //textField delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch self.inputType {
        case .unspecifiedText, .email, .url, .fullName, .jobTitle:
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
        case .number:
            //workaround for multiple entries caused by inserting predictive text
            if string == "" || string == " " {
                return true
            }
            let fullString = textField.text! + string
            textField.text = fullString.formatStringToNumericString()
            return false
        case .currency:
            var fullString = textField.text! + string
            if string == "" {
                fullString = String(fullString.dropLast())
            }
            
            let numericString = fullString.formatStringToNumericString()
            textField.text = self.formatStringToTwoDecimals(numberString: numericString)
            return false
        }
    }
    
    private func formatStringToTwoDecimals(numberString:String) -> String {
        guard let integerRepresentation = Int(numberString) else {
                return "0.00"
        }
        
        let sanitizedNumberString = String(integerRepresentation)
        
        if sanitizedNumberString.count == 0 {
            return "0.00"
        }
        if sanitizedNumberString.count == 1 {
            return "0.0"+sanitizedNumberString
        }
        if sanitizedNumberString.count == 2 {
            return "0."+sanitizedNumberString
        }
        
        var mutatingString = sanitizedNumberString
        let decimalIndex = mutatingString.index(mutatingString.endIndex, offsetBy: -2)
        mutatingString.insert(".", at: decimalIndex)
        return mutatingString
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let delegate = self.delegate {
            textField.resignFirstResponder()
            delegate.formItemViewDidPressReturn(self)
        }
        return false
    }
}
