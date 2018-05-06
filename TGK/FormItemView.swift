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
}

protocol FormItemView {
    //To be set after loaded from nib
    var formQuestion:FormQuestionModel! {get set}
    var formItemOutputValue:String? {get}
    var mainInputControl:UIView {get}
    
    var delegate:FormItemViewDelegate? {get set}
    
}
