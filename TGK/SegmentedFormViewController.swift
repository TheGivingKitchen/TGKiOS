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

class SegmentedFormViewController: UITableViewController {

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
        
        self.informationlabel.font = UIFont.tgkH2
        self.informationlabel.textColor = UIColor.tgkNavy
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let headerView = tableView.tableHeaderView else {
            return
        }
        let size = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableView.tableHeaderView = headerView
            tableView.layoutIfNeeded()
        }
    }
    
    fileprivate func configureView() {
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
            rightBarButtonItem.tintColor = UIColor.tgkPeach
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
        self.tableView.endEditing(true)
    }

    @objc func advancePageOrSubmit(_ sender: Any) {
        
        var questionAnswers = [FormQuestionAnswerModel]()
        for index in 0..<self.formQuestionCells.count {
            guard let castedCell = self.formQuestionCells[index] as? FormItemView else {
                continue
            }
            
            questionAnswers.append(contentsOf: castedCell.formItemOutputValue)
        }
        
        if let delegate = self.delegate {
            delegate.segmentedFormViewController(self, didAdvanceWithAnswers: questionAnswers)
        }
    }
    
    //Returns true if 1 or more fields on the page had an error field that matched the @param errors
    func showFormFieldErrors(_ errors:[FormFieldErrorModel]) -> Bool {
        var foundMatchingErrorField = false
        for formQuestionCell in self.formQuestionCells {
            guard let castedCell = formQuestionCell as? FormItemView else {
                continue
            }
            for fieldError in errors {
                if castedCell.formQuestion.id == fieldError.wufooFieldId {
                    castedCell.showError(fieldError)
                    foundMatchingErrorField = true
                }
            }
            
        }
        return foundMatchingErrorField
    }
}

//MARK: Tableview Datasource
extension SegmentedFormViewController {
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
            let listSelectCell = Bundle.main.loadNibNamed("FormListSelectTableViewCell", owner: self, options: [:])?.first as! FormListSelectTableViewCell
            self.formQuestionCells.append(listSelectCell)
            listSelectCell.formQuestion = questionModel
            listSelectCell.selectionType = .single
            listSelectCell.delegate = self
            return listSelectCell
        case .select:
            let dropDownCell = Bundle.main.loadNibNamed("FormPickerTableViewCell", owner: self, options: [:])?.first as! FormPickerTableViewCell
            self.formQuestionCells.append(dropDownCell)
            dropDownCell.formQuestion = questionModel
            dropDownCell.delegate = self
            return dropDownCell
        case .listSingleSelect:
            let listSelectCell = Bundle.main.loadNibNamed("FormListSelectTableViewCell", owner: self, options: [:])?.first as! FormListSelectTableViewCell
            self.formQuestionCells.append(listSelectCell)
            listSelectCell.formQuestion = questionModel
            listSelectCell.selectionType = .single
            listSelectCell.delegate = self
            return listSelectCell
        case .textView:
            let textViewCell = Bundle.main.loadNibNamed("FormTextViewTableViewCell", owner: self, options: [:])?.first as! FormTextViewTableViewCell
            self.formQuestionCells.append(textViewCell)
            textViewCell.formQuestion = questionModel
            textViewCell.delegate = self
            return textViewCell
        case .listMultipleSelect: //not in use yet
            let listSelectCell = Bundle.main.loadNibNamed("FormListSelectTableViewCell", owner: self, options: [:])?.first as! FormListSelectTableViewCell
            self.formQuestionCells.append(listSelectCell)
            listSelectCell.formQuestion = questionModel
            listSelectCell.selectionType = .multiple
            listSelectCell.delegate = self
            return listSelectCell
        case .shortName:
            let shortNameCell = Bundle.main.loadNibNamed("FormShortNameTableViewCell", owner: self, options: [:])?.first as! FormShortNameTableViewCell
            self.formQuestionCells.append(shortNameCell)
            shortNameCell.formQuestion = questionModel
            shortNameCell.delegate = self
            return shortNameCell
        case .address:
            let addressCell = Bundle.main.loadNibNamed("FormAddressTableViewCell", owner: self, options: [:])?.first as! FormAddressTableViewCell
            self.formQuestionCells.append(addressCell)
            addressCell.formQuestion = questionModel
            addressCell.delegate = self
            return addressCell
        case .date:
            let dateCell = Bundle.main.loadNibNamed("FormDateTableViewCell", owner: self, options: [:])?.first as! FormDateTableViewCell
            self.formQuestionCells.append(dateCell)
            dateCell.formQuestion = questionModel
            dateCell.delegate = self
            return dateCell
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
    //Advance to the next form's main input. If you can't, end editing
    func formItemViewDidPressReturn(_ formItemView: FormItemView) {
        guard let castedFormCell = formItemView as? UITableViewCell else {
            return
        }
        guard let indexOfCell = self.formQuestionCells.index(of: castedFormCell) else {
            return
        }
        //if we're on the last input cell on the page, dismiss the keyboard and we're done
        let nextIndex = indexOfCell + 1
        guard self.formQuestionCells.count > nextIndex else {
            self.endEditingInTableView()
            return
        }
        guard let nextCellAsFormItem = self.formQuestionCells[nextIndex] as? FormItemView else {
            return
        }
        nextCellAsFormItem.mainInputControl.becomeFirstResponder()
    }
    
    func formItemViewRequestTableViewUpdates(_ view: FormItemView) {
        //Notify our tableview that it needs to update
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}
