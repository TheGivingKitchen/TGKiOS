//
//  SegmentedFormNavigationController.swift
//  WufooPOC
//
//  Created by Jay Park on 4/19/18.
//  Copyright © 2018 ThoughtSeize. All rights reserved.
//

import UIKit

class SegmentedFormNavigationController: UINavigationController {
    
    var segmentedFormModel:SegmentedFormModel! {
        didSet {
            guard segmentedFormModel != nil else {return}
            self.setupFormPages()
        }
    }
    var segmentedFormViewControllers = [SegmentedFormViewController]()
    
    var formAnswers = [FormQuestionAnswerModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
    }
    
    func fetchData() {
        //call this earlier in the navigation controller's parent view controller
        ServiceManager.sharedInstace.getTestSegmentedForm { (segmentedFormModel, error) in
            if let segmentedFormModel = segmentedFormModel {
                self.segmentedFormModel = segmentedFormModel
            }
        }
    }
    
    func setupFormPages() {
        guard let formModel = self.segmentedFormModel else {
            return
        }
        self.popToRootViewController(animated: false)
        var allPageViewControllers = [SegmentedFormViewController]()
        for page in formModel.pages {
            let segmentedFormVC = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormViewControllerId") as! SegmentedFormViewController
            segmentedFormVC.formPage = page
            segmentedFormVC.delegate = self
            allPageViewControllers.append(segmentedFormVC)
        }
        self.segmentedFormViewControllers = allPageViewControllers
        
        if let firstPage = self.segmentedFormViewControllers.first {
            firstPage.isFirstPageInForm = true
            self.viewControllers = [firstPage]
        }
    }
}


//MARK: SegmentedFormViewControllerDelegate
extension SegmentedFormNavigationController:SegmentedFormViewControllerDelegate {
    func segmentedFormViewController(_ segmentedFormViewController: SegmentedFormViewController, didAdvanceWithAnswers answers: [FormQuestionAnswerModel]) {
        
        //If the user has made edits to the form, replace the answers
        let arrayOfExistingAnswerWufooIds:[String] = answers.map { (formQuestionAnswer) -> String in
            return formQuestionAnswer.wufooFieldID
        }
        let existingQuestionsWithAnswersRemoved = self.formAnswers.filter { (formQuestionAnswer) -> Bool in
            return !arrayOfExistingAnswerWufooIds.contains(formQuestionAnswer.wufooFieldID)
        }
        let newAnswers = existingQuestionsWithAnswersRemoved + answers
        self.formAnswers = newAnswers
        
        //Push the next form on the stack from memory to preserve preexisting answers. Submit if you're on the last page
        guard let index = self.segmentedFormViewControllers.index(where:  {$0 == segmentedFormViewController}) else {return}
        
        let nextIndex = index + 1
        if self.segmentedFormViewControllers.count > nextIndex {
            let nextPageVC = self.segmentedFormViewControllers[nextIndex]
            
            if self.segmentedFormViewControllers.count - 1 == nextIndex {
                nextPageVC.isLastPageInForm = true
            }
            self.pushViewController(nextPageVC, animated: true)
        }
        else {
            ServiceManager.sharedInstace.submitAnswersToForm(self.segmentedFormModel.id, withAnswers: self.formAnswers) { (success, error, formFieldErrorModels) in
                
            }
        }
    }
    
    func segmentedFormViewControllerDidPressCancel(_ segmentedFormViewController: SegmentedFormViewController) {
        self.dismiss(animated: true)
    }
}
