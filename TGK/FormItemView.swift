//
//  FormOutput.swift
//  WufooPOC
//
//  Created by Jay Park on 4/7/18.
//  Copyright © 2018 ThoughtSeize. All rights reserved.
//

import Foundation
import UIKit

protocol FormItemViewDelegate {
    func formItemViewDidPressReturn(_ formItemView: FormItemView)
    func formItemViewRequestTableViewUpdates(_ view:FormItemView)
}

protocol FormItemView {
    //To be set after loaded from nib
    var formQuestion:FormQuestionModel! {get set}
    
    //The output items of the form that will eventually be submitted
    var formItemOutputValue:[FormQuestionAnswerModel] {get}
    
    //Main input view that the user will interact with. becomeFirstResponder() will be called on this view
    var mainInputControl:UIView {get}
    
    //Error message label only shown after attempting to submit
    var errorMessageLabel:UILabel! {get set}
    
    var delegate:FormItemViewDelegate? {get set}
}

extension FormItemView {
    func showErrorState(_ error:FormFieldErrorModel) {
        //Remove the height anchor pinning the height to 0
        var foundHeightAnchor:NSLayoutConstraint?
        for constraint in self.errorMessageLabel.constraints {
            if constraint.identifier == "errorMessageHeightAnchor" {
                foundHeightAnchor = constraint
                break
            }
        }
        if let foundHeightAnchor = foundHeightAnchor {
            self.errorMessageLabel.removeConstraint(foundHeightAnchor)
        }
        
        self.errorMessageLabel.text = error.errorText
        self.errorMessageLabel.isHidden = false
        self.delegate?.formItemViewRequestTableViewUpdates(self)
    }
    
    func hideErrorState() {
        //Pin the height to 0 to collapse the label
        let heightAchor = self.errorMessageLabel.heightAnchor.constraint(equalToConstant: 0)
        heightAchor.identifier = "errorMessageHeightAnchor"
        heightAchor.isActive = true
        
        self.errorMessageLabel.isHidden = true
        self.delegate?.formItemViewRequestTableViewUpdates(self)
    }
}
