//
//  OnboardingViewController.swift
//  TGK
//
//  Created by Jay Park on 9/30/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit
import Foundation

protocol OnboardingViewControllerDelegate:class {
    func onboardingViewControllerDidFinish(viewController: OnboardingViewController)
}
class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var onboardingModels:[OnboardingContentModel] = [] {
        didSet {
            guard self.isViewLoaded else {
                return
            }
            self.collectionView.reloadData()
        }
    }
    
    weak var delegate:OnboardingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.styleView()
        self.styleNavigationBar()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.setupCollectionViewData()
        
        self.updateNavigationBarButtonItems()
    }
    
    private func styleNavigationBar() {
        guard let navVC = self.navigationController else {
            return
        }
        navVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navVC.navigationBar.shadowImage = UIImage()
    }
    
    private func styleView() {
        self.pageControl.pageIndicatorTintColor = UIColor.tgkBackgroundGray
        self.pageControl.currentPageIndicatorTintColor = UIColor.tgkGray
    }
    
    private func setupCollectionViewData() {
        let onboardingWelcomeModel = OnboardingContentModel(title:"Welcome!", description:"Thanks for supporting The Giving Kitchen! Request assistance for restaurant workers in need, view and voltuneer for upcoming events, and join our forces - all through the app.", heroImage:UIImage(named:"onboardingDonateHero"))
        let onboardingAssistanceModel = OnboardingContentModel(title:"Assistance", description:"Request assistance for yourself or a restaurant worker in need. Just fill out a form and one of our team members will contact you as soon as possible.", heroImage:UIImage(named:"onboardingAssistanceHero"))
        let onboardingSafetyNetModel = OnboardingContentModel(title:"SafetyNet", description:"We've also created a referral program to serve as a connection to social services for restaurant workers called SafetyNet.", heroImage:UIImage(named:"onboardingSafetyNetHero"))
        let onboardingEventsModel = OnboardingContentModel(title:"Events", description:"Get info about new upcoming events. Sign up through the app to get alerts about new volunteer opportunities.", heroImage:UIImage(named:"onboardingEventsHero"))
        
        self.onboardingModels = [onboardingWelcomeModel,
                                onboardingAssistanceModel,
                                onboardingSafetyNetModel,
                                onboardingEventsModel]
        
        self.pageControl.numberOfPages = self.onboardingModels.count
    }
    
    func updateNavigationBarButtonItems() {
        if self.pageControl.currentPage < self.onboardingModels.count - 1 {
            let nextBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(self.advanceOnboardingPage))
            self.navigationItem.rightBarButtonItem = nextBarButtonItem
        }
        else {
            //last page
            let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.finishOnboarding))
            self.navigationItem.rightBarButtonItem = doneBarButtonItem
        }
        
        if self.pageControl.currentPage == 0 {
            self.navigationItem.leftBarButtonItem = nil
        }
        else {
            let backBarButtonItem = UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(self.decrementOnboardingPage))
            self.navigationItem.leftBarButtonItem = backBarButtonItem
        }
    }
    
    @objc func advanceOnboardingPage() {
        self.collectionView.scrollToItem(at: IndexPath(row: self.pageControl.currentPage + 1, section: 0), at: .centeredHorizontally, animated: true)
        self.pageControl.currentPage = self.pageControl.currentPage + 1
        self.updateNavigationBarButtonItems()
    }
    
    @objc func decrementOnboardingPage() {
        self.collectionView.scrollToItem(at: IndexPath(row: self.pageControl.currentPage - 1, section: 0), at: .centeredHorizontally, animated: true)
        self.pageControl.currentPage = self.pageControl.currentPage - 1
        self.updateNavigationBarButtonItems()
    }
    
    @objc func finishOnboarding() {
        AppDataStore.hasFinishedOnboarding = true
        self.delegate?.onboardingViewControllerDidFinish(viewController: self)
    }
}

extension OnboardingViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.onboardingModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onboardingCollectionViewCellId", for: indexPath) as! OnboardingCollectionViewCell
        let onboardingModel = self.onboardingModels[indexPath.row]
        cell.configureWith(onboardingContentModel: onboardingModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width, height: self.collectionView.frame.size.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        pageControl.currentPage = currentPage
        self.updateNavigationBarButtonItems()
    }
    
}
