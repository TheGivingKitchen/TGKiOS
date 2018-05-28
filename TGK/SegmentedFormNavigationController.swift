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
        self.setupFormPages()
        self.styleNavigationBar()
    }
    
    private func styleNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    //MARK: Paging logic
    private func setupFormPages() {
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
    
    fileprivate func nextFormPageAfter(_ formPageViewController:SegmentedFormViewController) -> SegmentedFormViewController? {
        guard let index = self.segmentedFormViewControllers.index(where:  {$0 == formPageViewController}) else {return nil}
        
        let nextIndex = index + 1
        if nextIndex >= self.segmentedFormViewControllers.count {return nil}
        
        return self.segmentedFormViewControllers[nextIndex]
    }
    
    fileprivate func checkIfFormPageIsLastPage(_ formPageVC:SegmentedFormViewController) -> Bool {
        guard self.segmentedFormViewControllers.count > 0 else {
            return false
        }
        if formPageVC == self.segmentedFormViewControllers[self.segmentedFormViewControllers.count - 1] {
            return true
        }
        return false
    }
    
    //MARK: User Answer Management Logic
    fileprivate func storeNewAnswers(_ answers:[FormQuestionAnswerModel]) {
        //If the user has made edits to the form, replace the old answers with new ones
        let arrayOfNewAnswerWufooIds:[String] = answers.map { (formQuestionAnswer) -> String in
            return formQuestionAnswer.wufooFieldID
        }
        //Filter out answers that are about to be replaced
        let existingQuestionsWithAnswersRemoved = self.formAnswers.filter { (formQuestionAnswer) -> Bool in
            return !arrayOfNewAnswerWufooIds.contains(formQuestionAnswer.wufooFieldID)
        }
        let newAnswers = existingQuestionsWithAnswersRemoved + answers
        self.formAnswers = newAnswers
    }
    
    fileprivate func submitFormAnswers() {
        ServiceManager.sharedInstace.submitAnswersToForm(self.segmentedFormModel.id, withAnswers: self.formAnswers) { (success, error, formFieldErrorModels) in
            
            if success == true {
                self.dismiss(animated: true)
            }
            else {
                if let fieldErrors = formFieldErrorModels {
                    var firstSegmentedForWithErrors:SegmentedFormViewController?
                    for segmentedFormVC in self.segmentedFormViewControllers {
                        let hasErrors = segmentedFormVC.showFormFieldErrors(fieldErrors)
                        if hasErrors && firstSegmentedForWithErrors == nil {
                            firstSegmentedForWithErrors = segmentedFormVC
                        }
                    }
                    if let firstSegmentedForWithErrors = firstSegmentedForWithErrors {
                        self.popToViewController(firstSegmentedForWithErrors, animated: true)
                    }
                }
                //other error cases where there is failure but not with fields. maybe present an alert or banner
            }
        }
    }
}

//MARK: SegmentedFormViewControllerDelegate
extension SegmentedFormNavigationController:SegmentedFormViewControllerDelegate {
    func segmentedFormViewController(_ segmentedFormViewController: SegmentedFormViewController, didAdvanceWithAnswers answers: [FormQuestionAnswerModel]) {
        
        self.storeNewAnswers(answers)
        
        //Push the next form on the stack from memory to preserve preexisting answers. Submit if you're on the last page
        if let nextFormPageVC = self.nextFormPageAfter(segmentedFormViewController) {
            nextFormPageVC.isLastPageInForm = self.checkIfFormPageIsLastPage(nextFormPageVC)
            self.pushViewController(nextFormPageVC, animated: true)
        }
        //Submit if we're on the last page
        else if segmentedFormViewController.isLastPageInForm {
            self.submitFormAnswers()
        }
    }
    
    func segmentedFormViewControllerDidPressCancel(_ segmentedFormViewController: SegmentedFormViewController) {
        self.dismiss(animated: true)
    }
}
