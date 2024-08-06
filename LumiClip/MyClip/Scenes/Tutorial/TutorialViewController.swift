//
//  TutorialViewController.swift
//  MyClip
//
//  Created by ThuongPV-iOS on 10/31/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class TutorialViewController: BaseViewController {
    let pageVC: UIPageViewController = UIPageViewController(transitionStyle: .scroll,
                                                             navigationOrientation: .horizontal,
                                                             options: nil)
    var vc1: ItemTutorialViewController?
    var vc2: ItemTutorialViewController?
    var vc3: ItemTutorialViewController?
    
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Constants.isIpad {
            vc1 = ItemTutorialViewController.init(#imageLiteral(resourceName: "welcome1-ipad"), title: String.welcome1Title)
            vc2 = ItemTutorialViewController.init(#imageLiteral(resourceName: "welcome2-ipad"), title: String.welcome2Title)
            vc3 = ItemTutorialViewController.init(#imageLiteral(resourceName: "welcome3-ipad"), title: String.welcome3Title)
        } else {
            vc1 = ItemTutorialViewController.init(#imageLiteral(resourceName: "img_lunch"), title: String.welcome1Title)
            vc2 = ItemTutorialViewController.init(#imageLiteral(resourceName: "img_slide1"), title: String.welcome2Title)
            vc3 = ItemTutorialViewController.init(#imageLiteral(resourceName: "img_slide_2"), title: String.welcome3Title)
        }
        
        beginButton.setTitle(String.bat_dau, for: .normal)
        pageControl.currentPage = 0
        pageVC.delegate = self
        pageVC.dataSource = self
        pageVC.setViewControllers([vc1!], direction: .forward, animated: true, completion: nil)
        addChild(pageVC)
        containerView.addSubview(pageVC.view)
        pageVC.view.snp.makeConstraints { (constraintMaker) in
            constraintMaker.edges.equalToSuperview()
        }
        pageVC.didMove(toParent: self)
        view.sendSubviewToBack(containerView)
        // Do any additional setup after loading the view.
        
        UIApplication.shared.setStatusBarOrientation(.portrait, animated: false)
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
    }

    @IBAction func onClickStartButton(_ sender: Any) {
        DataManager.setHiddenTutorial()
        Constants.appDelegate.showHomePage()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    override var shouldAutorotate: Bool {
        get {
            return true
        }
    }
    
}

extension TutorialViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController == vc2 {
            return vc1
        } else if viewController == vc3 {
            return vc2
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController == vc1 {
            return vc2
        } else if viewController == vc2 {
            return vc3
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed {
            if let currentVC = pageViewController.viewControllers?.last {
                if currentVC == vc1 {
                    pageControl.currentPage = 0
                } else if currentVC == vc2 {
                    pageControl.currentPage = 1
                } else if currentVC == vc3 {
                    pageControl.currentPage = 2
                }
            }
        }
    }
}
