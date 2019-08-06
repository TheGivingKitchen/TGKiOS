//
//  ScrollableBottomSheetViewController.swift
//  BottomDragDrawer
//
//  Created by Jay Park on 7/30/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

class ScrollableBottomSheetViewController: UIViewController {
    
    /* in viewController
     override func viewDidLoad() {
     super.viewDidLoad()
     
     }
     override func viewDidAppear(_ animated: Bool) {
     super.viewDidAppear(animated)
     addBottomSheetView()
     }
     
     func addBottomSheetView(scrollable: Bool? = true) {
     let bottomSheetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScrollableBottomSheetViewControllerId") as! ScrollableBottomSheetViewController
     
     self.addChild(bottomSheetVC)
     self.view.addSubview(bottomSheetVC.view)
     bottomSheetVC.didMove(toParent: self)
     
     let height = view.frame.height
     let width  = view.frame.width
     bottomSheetVC.view.frame = CGRect(x: 0, y: bottomSheetVC.bottomStickyPoint, width: width, height: height)
     }
     */
    
    @IBOutlet weak var tableView: UITableView!
    
    let topStickyPoint: CGFloat = 100
    var bottomStickyPoint: CGFloat {
        return UIScreen.main.bounds.height - 150
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DefaultTableViewCell", bundle: nil), forCellReuseIdentifier: "default")
        
        
        let viewPanGesture = UIPanGestureRecognizer.init(target: self, action: #selector(ScrollableBottomSheetViewController.panGesture))
        viewPanGesture.delegate = self
        view.addGestureRecognizer(viewPanGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        print(velocity)
        
        let currentY = self.view.frame.minY

        self.view.frame = CGRect(x: 0, y: currentY + translation.y, width: view.frame.width, height: view.frame.height)
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        if recognizer.state == .ended {
            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.0, options: [.allowUserInteraction], animations: {[weak self] in
                if let unwrappedSelf = self {
                    
                    //the point at which the velocity of the movement combined with the "ended" recognition state counts as a user flicking. values are arbitrary
                    let downWardFlickThreshold:CGFloat = 1400.0
                    let upwardFlickThreshold:CGFloat = -1400.0
                    let midpoint = (unwrappedSelf.topStickyPoint + unwrappedSelf.bottomStickyPoint) / 2.0
                    var targetY:CGFloat = 0
                    
                    switch velocity.y {
                    case _ where velocity.y > downWardFlickThreshold:
                        targetY = unwrappedSelf.bottomStickyPoint
                        break
                    case _ where velocity.y < upwardFlickThreshold:
                        targetY = unwrappedSelf.topStickyPoint
                        break
                    default:
                        targetY = unwrappedSelf.view.frame.minY > midpoint ? unwrappedSelf.bottomStickyPoint : unwrappedSelf.topStickyPoint
                        break
                    }
                    
                    unwrappedSelf.view.frame = CGRect(x: 0, y: targetY, width: unwrappedSelf.view.frame.width, height: unwrappedSelf.view.frame.height)
                }
            }, completion: { [weak self] _ in
                if ( velocity.y < 0 ) {
                    self?.tableView.isScrollEnabled = true
                }
            })
        }
    }
    
    
    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        view.insertSubview(bluredView, at: 0)
    }
    
}

extension ScrollableBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(style: .default, reuseIdentifier: "defa")
    }
}

extension ScrollableBottomSheetViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y
        
        let y = view.frame.minY
        if (y == topStickyPoint && tableView.contentOffset.y == 0 && direction > 0) || (y == bottomStickyPoint) {
            tableView.isScrollEnabled = false
        } else {
            tableView.isScrollEnabled = true
        }
        
        return false
    }
}

