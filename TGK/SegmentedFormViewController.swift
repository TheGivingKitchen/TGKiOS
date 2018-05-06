//
//  SegmentedFormViewController.swift
//  WufooPOC
//
//  Created by Jay Park on 4/18/18.
//  Copyright © 2018 ThoughtSeize. All rights reserved.
//

import UIKit

protocol SegmentedFormViewControllerDelegate {
    func segmentedFormViewController(_ segmentedFormViewController:SegmentedFormViewController, didAdvanceWithAnswers answers:[FormQuestionAnswerModel])
    func segmentedFormViewControllerDidPressCancel(_ segmentedFormViewController:SegmentedFormViewController)
}

class SegmentedFormViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var informationlabel: UILabel!
    
    //dependencies
    var isLastPageInForm = false
    var isFirstPageInForm = false
    var delegate:SegmentedFormViewControllerDelegate?
    var formPage:FormPagePageModel! {
        didSet {
            guard self.isViewLoaded else {return}
            self.configureView()
        }
    }
    //end dependencies
    
    var formQuestionCells = [UITableViewCell]()
    
    var questionModels:[FormQuestionModel] {
            return self.formPage.questions
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.configureView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditingInTableView))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureBarButtonItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard self.formQuestionCells.count > 0,
         let firstFormItem = self.formQuestionCells[0] as? FormItemView else {
            return
        }
        firstFormItem.mainInputControl.becomeFirstResponder()
    }
    
    fileprivate func configureView() {
        self.navigationItem.title = self.formPage.pageTitle
        self.informationlabel.text = self.formPage.pageInformation
        self.tableView.reloadData()
    }
    
    fileprivate func configureBarButtonItems() {
        var rightBarButtonItem = UIBarButtonItem()
        if self.isLastPageInForm {
            rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(advancePageOrSubmit))
        }
        else {
            rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(advancePageOrSubmit))
        }
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        if self.isFirstPageInForm {
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(userDidTapCancel))
            self.navigationItem.leftBarButtonItem = cancelButton
        }
    }
    
    @objc fileprivate func userDidTapCancel() {
        self.delegate?.segmentedFormViewControllerDidPressCancel(self)
    }
    
    @objc fileprivate func endEditingInTableView() {
        self.view.endEditing(true)
    }

    @objc func advancePageOrSubmit(_ sender: Any) {
        var index = 0
        var questionAnswers = [FormQuestionAnswerModel]()
        for cell in self.formQuestionCells {
            guard let castedCell = cell as? FormItemView,
            let formItemOutputValue = castedCell.formItemOutputValue else {
                continue
            }
            let questionItem = self.questionModels[index]
            
            let questionAnswer = FormQuestionAnswerModel(wufooFieldID: questionItem.id, userAnswer: formItemOutputValue)
            questionAnswers.append(questionAnswer)
            index += 1
        }
        
        if let delegate = self.delegate {
            delegate.segmentedFormViewController(self, didAdvanceWithAnswers: questionAnswers)
        }
    }
}

//MARK: Tableview Datasource
extension SegmentedFormViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questionModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        case .email:
            let emailCell = Bundle.main.loadNibNamed("FormTextFieldTableViewCell", owner: self, options: [:])?.first as! FormTextFieldTableViewCell
            emailCell.formQuestion = questionModel
            emailCell.inputType = .email
            emailCell.delegate = self
            self.formQuestionCells.append(emailCell)
            return emailCell
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

//MARK: Tableview Delegate
extension SegmentedFormViewController:FormItemViewDelegate {
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
