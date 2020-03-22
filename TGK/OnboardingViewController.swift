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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var onboardingModels:[OnboardingContentModel] = [] {
        didSet {
            guard self.isViewLoaded else {
                return
            }
            self.collectionView.reloadData()
            let currentPage = Int(self.collectionView.contentOffset.x / self.collectionView.frame.width)
            let onboardingModel = self.onboardingModels[currentPage]
            self.titleLabel.text = onboardingModel.title
            self.descriptionLabel.text = onboardingModel.description
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
        self.titleLabel.font = UIFont.tgkTitle
        self.titleLabel.textColor = UIColor.tgkOrange
        
        self.descriptionLabel.font = UIFont.tgkBody
        self.descriptionLabel.textColor = UIColor.tgkGray
        
        self.pageControl.pageIndicatorTintColor = UIColor.tgkBackgroundGray
        self.pageControl.currentPageIndicatorTintColor = UIColor.tgkGray
    }
    
    private func setupCollectionViewData() {
        let onboardingWelcomeModel = OnboardingContentModel(title:"Welcome!", description:"Thanks for supporting Giving Kitchen! You can request assistance for food service workers in crisis, see upcoming events that benefit GK and join our forces - all through this app.", heroImage:UIImage(named:"onboardingWelcomeHero"))
        let onboardingAssistanceModel = OnboardingContentModel(title:"Assistance", description:"Request assistance for yourself or a food service worker in crisis. Just fill out our ask for help form, and one of our team members will contact you.", heroImage:UIImage(named:"onboardingAssistanceHero"))
        let onboardingSafetyNetModel = OnboardingContentModel(title:"Stability Network", description:"We also have a Stability Network program to connect food service workers to community resources throughout Georgia and the United States.", heroImage:UIImage(named:"onboardingSafetyNetHero"))
        let onboardingEventsModel = OnboardingContentModel(title:"Events", description:"Get info about upcoming events, and sign up to get alerts about volunteer opportunities.", heroImage:UIImage(named:"onboardingEventsHero"))
        
        self.onboardingModels = [onboardingWelcomeModel,
                                onboardingAssistanceModel,
                                onboardingSafetyNetModel,
                                onboardingEventsModel]
        
        self.pageControl.numberOfPages = self.onboardingModels.count
    }
    
    func updateNavigationBarButtonItems() {
        guard self.onboardingModels.count > 0,
            self.pageControl.currentPage < self.onboardingModels.count else {
                return
        }
        
        if self.pageControl.currentPage < self.onboardingModels.count - 1 {
            let nextBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(self.advanceOnboardingPage))
            nextBarButtonItem.setTitleTextAttributes([.font:UIFont.tgkBody], for: .normal)
            nextBarButtonItem.setTitleTextAttributes([.font:UIFont.tgkBody], for: .disabled)
            self.navigationItem.rightBarButtonItem = nextBarButtonItem
        }
        else {
            //last page
            let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.finishOnboarding))
            doneBarButtonItem.setTitleTextAttributes([.font:UIFont.tgkBody], for: .normal)
            doneBarButtonItem.setTitleTextAttributes([.font:UIFont.tgkBody], for: .disabled)
            self.navigationItem.rightBarButtonItem = doneBarButtonItem
        }
        
        if self.pageControl.currentPage == 0 {
            self.navigationItem.leftBarButtonItem = nil
        }
        else {
            let backBarButtonItem = UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(self.decrementOnboardingPage))
            backBarButtonItem.setTitleTextAttributes([.font:UIFont.tgkBody], for: .normal)
            backBarButtonItem.setTitleTextAttributes([.font:UIFont.tgkBody], for: .disabled)
            self.navigationItem.leftBarButtonItem = backBarButtonItem
        }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = !self.collectionView.isDragging
        self.navigationItem.leftBarButtonItem?.isEnabled = !self.collectionView.isDragging
    }
    
    @objc func advanceOnboardingPage() {
        self.collectionView.scrollToItem(at: IndexPath(row: self.pageControl.currentPage + 1, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @objc func decrementOnboardingPage() {
        self.collectionView.scrollToItem(at: IndexPath(row: self.pageControl.currentPage - 1, section: 0), at: .centeredHorizontally, animated: true)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
        guard currentPage < self.onboardingModels.count else {
            return
        }
        
        self.pageControl.currentPage = currentPage
        let onboardingModel = self.onboardingModels[currentPage]
        
        let lowerBoundContentOffset = CGFloat(self.pageControl.currentPage) * self.collectionView.frame.size.width
        
        let relativeContentOffset = self.collectionView.contentOffset.x - lowerBoundContentOffset
        let midpointContentOffset = self.collectionView.frame.size.width / 2.0
        
        let distanceFromMidpoint = relativeContentOffset - midpointContentOffset
        let percentDistanceFromMidpoint = abs(distanceFromMidpoint)/midpointContentOffset
        self.titleLabel.alpha = percentDistanceFromMidpoint
        self.descriptionLabel.alpha = percentDistanceFromMidpoint
        
        self.titleLabel.text = onboardingModel.title
        self.descriptionLabel.text = onboardingModel.description
        
        self.updateNavigationBarButtonItems()
        
        //If we're not on the last page, and we're on the latter half of scrolling between pages
        guard currentPage < self.onboardingModels.count - 1,
            distanceFromMidpoint > 0 else {
            return
        }
        
        let nextOnboardingModel = self.onboardingModels[currentPage + 1]
        self.pageControl.currentPage = currentPage + 1
        self.titleLabel.text = nextOnboardingModel.title
        self.descriptionLabel.text = nextOnboardingModel.description
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.updateNavigationBarButtonItems()
        
//        self.navigationItem.leftBarButtonItem?.isEnabled = true
//        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
}
