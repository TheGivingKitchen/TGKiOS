//
//  FormTableViewController.swift
//  WufooPOC
//
//  Created by Jay Park on 4/7/18.
//  Copyright © 2018 ThoughtSeize. All rights reserved.
//

import UIKit

class FormTableViewController: UITableViewController {
    
    var questionModels = [FormQuestionModel]()
    var formQuestionCells = [UITableViewCell]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditingForTableView))
        self.tableView.addGestureRecognizer(tapGesture)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        
        ServiceManager.sharedInstace.getFormAlamofire { (formQuestionModels, error) in
            if let error = error {
                print(error)
            }
            
            if let formQuestionModels = formQuestionModels {
                self.questionModels = formQuestionModels
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func endEditingForTableView() {
        self.tableView.endEditing(true)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        var answerDict = [String:String]()
        var index = 0
        for cell in self.formQuestionCells {
            guard let castedCell = cell as? FormItemView else {
                continue
            }
            let questionItem = self.questionModels[index]
            
            answerDict[questionItem.id] = castedCell.formItemOutputValue
            
            index += 1
        }
        
        ServiceManager.sharedInstace.submitAnswers(answerDict) { (success, errror) in
//            if success {
//                self.dismiss(animated: true)
//            }
//            else {
//                //show alert dialgue
//            }
        }
    }
    
    
}

//Datasource
extension FormTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questionModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.formQuestionCells.count > indexPath.row {
            return self.formQuestionCells[indexPath.row]
        }
        
        let questionModel = self.questionModels[indexPath.row]
        
        switch questionModel.questionType {
        case .textField:
            let textCell = Bundle.main.loadNibNamed("FormTextFieldTableViewCell", owner: self, options: [:])?.first as! FormTextFieldTableViewCell
            textCell.formQuestion = questionModel
            textCell.delegate = self
            self.formQuestionCells.append(textCell)
            return textCell
        case .phoneNumber:
            let phoneNumberTextCell = Bundle.main.loadNibNamed("FormTextFieldTableViewCell", owner: self, options: [:])?.first as! FormTextFieldTableViewCell
            phoneNumberTextCell.formQuestion = questionModel
            phoneNumberTextCell.inputType = .phoneNumber
            phoneNumberTextCell.delegate = self
            self.formQuestionCells.append(phoneNumberTextCell)
            return phoneNumberTextCell
        case .number:
            let numberCell = UITableViewCell(style: .default, reuseIdentifier: "questionCell")
            self.formQuestionCells.append(numberCell)
            numberCell.textLabel?.text = "number cell"
            return numberCell
        case .radio:
            let radioCell = Bundle.main.loadNibNamed("FormSegmentedControlTableViewCell", owner: self, options: [:])?.first as! FormSegmentedControlTableViewCell
            self.formQuestionCells.append(radioCell)
            radioCell.formQuestion = questionModel
            radioCell.delegate = self
            return radioCell
        case .select:
            let dropDownCell = Bundle.main.loadNibNamed("FormPickerTableViewCell", owner: self, options: [:])?.first as! FormPickerTableViewCell
            self.formQuestionCells.append(dropDownCell)
            dropDownCell.formQuestion = questionModel
            dropDownCell.delegate = self
            return dropDownCell
        case .listSingleSelect:
            let singleSelectCell = Bundle.main.loadNibNamed("FormListSelectTableViewCell", owner: self, options: [:])?.first as! FormListSelectTableViewCell
            self.formQuestionCells.append(singleSelectCell)
            singleSelectCell.formQuestion = questionModel
            singleSelectCell.delegate = self
            return singleSelectCell
        case .textView:
            let textViewCell = Bundle.main.loadNibNamed("FormTextViewTableViewCell", owner: self, options: [:])?.first as! FormTextViewTableViewCell
            self.formQuestionCells.append(textViewCell)
            textViewCell.formQuestion = questionModel
            textViewCell.delegate = self
            return textViewCell
            
        case .unknown:
            let unknownCell = UITableViewCell(style: .default, reuseIdentifier: "questionCell")
            self.formQuestionCells.append(unknownCell)
            unknownCell.textLabel?.text = "unknown"
            return unknownCell
        }
    }
}

extension FormTableViewController:FormItemViewDelegate {
    func formItemViewDidPressReturn(_ formItemView: FormItemView) {
        guard let castedFormCell = formItemView as? UITableViewCell else {
            return
        }
        guard let indexOfCell = self.formQuestionCells.index(of: castedFormCell) else {
            return
        }
        let nextIndex = indexOfCell + 1
        guard self.formQuestionCells.count > nextIndex else {
            return
        }
        guard let nextCellAsFormItem = self.formQuestionCells[nextIndex] as? FormItemView else {
            return
        }
        nextCellAsFormItem.mainInputControl.becomeFirstResponder()
    }
}


