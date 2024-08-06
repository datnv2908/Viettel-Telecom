//
//  TutorialViewController.swift
//  5dmax
//
//  Created by Admin on 3/16/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol PopupPromotionViewDelegate {
    func registerPromotionAppFinish(message : String)
}

class TutorialViewController: BaseViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var overButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var indexView2: UIView!
    @IBOutlet weak var indexView1: UIView!
    @IBOutlet weak var indexView3: UIView!
    
    var delegate: PopupPromotionViewDelegate!

    var tutorialPageViewController: TutorialPageViewController? {
        didSet {
            tutorialPageViewController?.tutorialDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        pageControl.addTarget(self,
                              action: #selector(TutorialViewController.didChangePageControlValue),
                              for: .valueChanged)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        if let user = DataManager.getCurrentMemberModel() {
//            if (user.isShowPromotionAPP == 0){
//                if pageControl.currentPage == 2 {
//                    nextButton.setTitle(String.bat_dau, for: .normal)
//                } else {
//                    nextButton.setTitle(String.tiep_theo, for: .normal)
//                }
//            }else{
//                nextButton.setTitle("DÙNG THỬ 1 THÁNG MIỄN PHÍ", for: .normal)
//            }
//        } else {
        self.overButton.setTitle(String.bo_qua, for: .normal)
            if pageControl.currentPage == 2 {
                nextButton.setTitle(String.bat_dau, for: .normal)
            } else {
                nextButton.setTitle(String.tiep_theo, for: .normal)
            }
//        }
    }
    
    @IBAction func didTapRegisterPromotion(_ sender: Any) {
//        if DataManager.isLoggedIn() {
//            if let user = DataManager.getCurrentMemberModel() {
//                if (user.isShowPromotionAPP == 1){
//                    self.showHud();
//                    let service = UserService()
//                    service.registerPromotionApp({ (result) in
//                        switch result {
//                        case .success(let message):
//                            DataManager.save(boolValue: true, forKey: Constants.didShowTutorialPage)
//                            Constants.appDelegate.showHomePage()
//                            self.delegate?.registerPromotionAppFinish(message: message as! String)
//                        case .failure(let error):
//                            self.toast(error.localizedDescription)
//                        }
//
//                        self.hideHude()
//
//                    })
//                }else{
//                    if pageControl.currentPage == 2 {
//                        DataManager.save(boolValue: true, forKey: Constants.didShowTutorialPage)
//                        Constants.appDelegate.showHomePage()
//                    } else {
//                        tutorialPageViewController?.scrollToNextViewController()
//                    }
//                }
//            }else{
                if pageControl.currentPage == 2 {
                    DataManager.save(boolValue: true, forKey: Constants.didShowTutorialPage)
                    Constants.appDelegate.showHomePage()
                } else {
                    tutorialPageViewController?.scrollToNextViewController()
                }
//            }
//        } else {
//            LoginViewController.performLogin(fromViewController: self)
//        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialPageViewController = segue.destination as? TutorialPageViewController {
            self.tutorialPageViewController = tutorialPageViewController
        }
    }
    override class func initWithNib() -> TutorialViewController {
        let storyboard = UIStoryboard(name: "TutorialViewController", bundle: nil)
        if Constants.screenHeight == 480 {
            let viewController = storyboard.instantiateViewController(
                withIdentifier :"TutorialViewControllerIphone4") as! TutorialViewController
            return viewController
        } else {
            let viewController = storyboard.instantiateViewController(
                withIdentifier :"TutorialViewController") as! TutorialViewController
            return viewController
        }
    }

    @IBAction func didTapIgnoreButton(_ sender: Any) {
        DataManager.save(boolValue: true, forKey: Constants.didShowTutorialPage)
        Constants.appDelegate.showHomePage()
    }
    /**
     Fired when the user taps on the pageControl to change its current page.
     */
    @objc func didChangePageControlValue() {
        tutorialPageViewController?.scrollToViewController(index: pageControl.currentPage)
        
    }
}

extension TutorialViewController: TutorialPageViewControllerDelegate {

    func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
        
//        if let user = DataManager.getCurrentMemberModel() {
//            if (user.isShowPromotionAPP == 0){
                if pageControl.currentPage == 2 {
                    nextButton.setTitle(String.bat_dau, for: .normal)
                } else {
                    nextButton.setTitle(String.tiep_theo, for: .normal)
                }
//            }
//        }
    }

    func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
//        if let user = DataManager.getCurrentMemberModel() {
//            if (user.isShowPromotionAPP == 0){
                if pageControl.currentPage == 0 {
                    nextButton.setTitle(String.tiep_theo, for: .normal)
                } else if pageControl.currentPage == 1 {
                    nextButton.setTitle(String.tiep_theo, for: .normal)
                } else {
                    nextButton.setTitle(String.bat_dau, for: .normal)
                }
//            }
//        }
    }

}
