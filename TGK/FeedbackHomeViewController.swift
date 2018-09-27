//
//  FeedbackHomeViewController.swift
//  TGK
//
//  Created by Jay Park on 9/26/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

class FeedbackHomeViewController: UITableViewController {

    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            self.submitButton.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.endEditing))
        self.view.addGestureRecognizer(tapRecognizer)
        
        self.textView.delegate = self
        self.styleView()
    }
    
    private func styleView() {
        self.mainTitleLabel.font = UIFont.tgkTitle
        self.mainTitleLabel.textColor = UIColor.tgkOrange
        
        self.descriptionLabel.font = UIFont.tgkBody
        self.descriptionLabel.textColor = UIColor.tgkBlue
        
        self.submitButton.titleLabel?.font = UIFont.tgkNavigation
        self.submitButton.backgroundColor = UIColor.tgkGray
        
        self.textView.layer.borderColor = UIColor.tgkBlue.cgColor
        self.textView.layer.borderWidth = 1
        self.textView.font = UIFont.tgkBody
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        let formQuestionAnswer = FormQuestionAnswerModel(wufooFieldID:"Field1", userAnswer:self.textView.text)
        ServiceManager.sharedInstace.submitAnswersToForm("z11e77nq1xzi5uf", withAnswers: [formQuestionAnswer]) { (success, error, errorModels) in
            if success == true {
                let successModal = UIAlertController(title: "Success!", message: "Thank you! Your feedback is greatly appreciated ✨🧡👊", preferredStyle: .alert)
                let doneAction = UIAlertAction(title: "Awesome!", style: .default, handler: { (action) in
                })
                successModal.addAction(doneAction)
                DispatchQueue.main.async {
                    self.present(successModal, animated:true)
                    self.textView.text = ""
                    self.textViewDidChange(self.textView)
                }
            }
            else {
                let errorModal = UIAlertController(title: "Error Submitting", message: "There was an error submitting feedback. Please check your submission and try again", preferredStyle: .alert)
                let doneAction = UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                })
                errorModal.addAction(doneAction)
                DispatchQueue.main.async {
                    self.present(errorModal, animated:true)
                }
            }
        }
    }
}

extension FeedbackHomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.size.height
    }
}

extension FeedbackHomeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if self.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.submitButton.isEnabled = false
            self.submitButton.backgroundColor = UIColor.tgkGray
        }
        else {
            self.submitButton.isEnabled = true
            self.submitButton.backgroundColor = UIColor.tgkOrange
        }
    }
}
