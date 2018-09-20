//
//  SegmentedFormNavigationController.swift
//  WufooPOC
//
//  Created by Jay Park on 4/19/18.
//  Copyright © 2018 ThoughtSeize. All rights reserved.
//

import UIKit
import Firebase

protocol SegmentedFormNavigationControllerDelegate:class {
    func segmentedFormNavigationControllerDidFinish(viewController:SegmentedFormNavigationController)
}

class SegmentedFormNavigationController: UINavigationController {
    
    //dependencies
    weak var formDelegate:SegmentedFormNavigationControllerDelegate?
    var segmentedFormModel:SegmentedFormModel! {
        didSet {
            guard segmentedFormModel != nil else {return}
            self.setupFormPages()
        }
    }
    //end dependencies
    
    var formPageViewControllers = [FormPageViewController]()
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
        var allPageViewControllers = [FormPageViewController]()
        for page in formModel.pages {
            let formPageVC = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "FormPageViewControllerId") as! FormPageViewController
            formPageVC.formPage = page
            formPageVC.delegate = self
            allPageViewControllers.append(formPageVC)
        }
        self.formPageViewControllers = allPageViewControllers
        
        //set a form info view controller as the landing page
        let formInfoVC = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormInfoViewControllerId") as! SegmentedFormInfoViewController
        formInfoVC.segmentedFormModel = self.segmentedFormModel
        formInfoVC.delegate = self    
        self.viewControllers = [formInfoVC]
        
    }
    
    fileprivate func nextFormPageAfter(_ formPageViewController:FormPageViewController) -> FormPageViewController? {
        guard let index = self.formPageViewControllers.index(where:  {$0 == formPageViewController}) else {return nil}
        
        let nextIndex = index + 1
        if nextIndex >= self.formPageViewControllers.count {return nil}
        
        return self.formPageViewControllers[nextIndex]
    }
    
    fileprivate func checkIfFormPageIsLastPage(_ formPageVC:FormPageViewController) -> Bool {
        guard self.formPageViewControllers.count > 0 else {
            return false
        }
        if formPageVC == self.formPageViewControllers[self.formPageViewControllers.count - 1] {
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
        //Add default answers to the list before submitting
        self.storeNewAnswers(segmentedFormModel.defaultAnswers)
        
        ServiceManager.sharedInstace.submitAnswersToForm(self.segmentedFormModel.id, withAnswers: self.formAnswers) { (success, error, formFieldErrorModels) in
            
            if success == true {
                self.formDelegate?.segmentedFormNavigationControllerDidFinish(viewController: self)
            }
            else if let fieldErrors = formFieldErrorModels {
                var firstformPageWithErrors:FormPageViewController?
                for formPageVC in self.formPageViewControllers {
                    let hasErrors = formPageVC.showFormFieldErrors(fieldErrors)
                    if hasErrors && firstformPageWithErrors == nil {
                        firstformPageWithErrors = formPageVC
                    }
                }
                if let firstSegmentedForWithErrors = firstformPageWithErrors {
                    self.popToViewController(firstSegmentedForWithErrors, animated: true)
                }
            }
            else if let error = error {
                //Catch any unexptected errors
                let alertController = UIAlertController(title: "Oh no!", message: error.localizedDescription, preferredStyle: .alert)
                self.present(alertController, animated: true)
            }
        }
    }
}

//MARK: FormPageViewControllerDelegate
extension SegmentedFormNavigationController:FormPageViewControllerDelegate {
    func formPageViewController(_ formPageViewController: FormPageViewController, didAdvanceWithAnswers answers: [FormQuestionAnswerModel]) {
        
        self.storeNewAnswers(answers)
        
        //Push the next form on the stack from memory to preserve preexisting answers. Submit if you're on the last page
        if let nextFormPageVC = self.nextFormPageAfter(formPageViewController) {
            nextFormPageVC.isLastPageInForm = self.checkIfFormPageIsLastPage(nextFormPageVC)
            self.pushViewController(nextFormPageVC, animated: true)
        }
        //Submit if we're on the last page
        else if formPageViewController.isLastPageInForm {
            self.submitFormAnswers()
        }
    }
}

extension SegmentedFormNavigationController:SegmentedFormInfoViewControllerDelegate {
    func segmentedFormInfoViewControllerDidPressCancel(segmentedFormInfoViewController: SegmentedFormInfoViewController) {
        segmentedFormInfoViewController.dismiss(animated: true)
    }
    
    func segmentedFormInfoViewControllerDidPressContinue(segmentedFormInfoViewController: SegmentedFormInfoViewController) {
        if let firstPageVC = self.formPageViewControllers.first {
            self.pushViewController(firstPageVC, animated: true)
        }
        Analytics.logEvent(customName: .formStarted, parameters: [.formName: self.segmentedFormModel.title,
                                                                                   .formId: self.segmentedFormModel.id])
    }
}
