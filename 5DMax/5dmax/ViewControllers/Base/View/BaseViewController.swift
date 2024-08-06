//
//  BaseViewController.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/8/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import WYPopoverController
import GoogleCast

class BaseViewController: BaseCastViewController {

    var popOverVC: WYPopoverController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.blackBackgroundColor()
//        self.settingAnimation()
    }
    
    func settingAnimation() {
        self.view.makeItSnow(withFlakesCount: 160, animationDurationMin: 15.0, animationDurationMax: 30.0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIViewController.attemptRotationToDeviceOrientation()
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    class func initWithDefautlStoryboardWithID(storyboardId: String!) -> Self {
        let className = String(describing: self)
        return instantiateFromStoryboardHelper(storyboardName: className, storyboardId: storyboardId)
    }

    class func initWithNib() -> Self {
        let bundle = Bundle.main
        let fileManege = FileManager.default
        let nibName = String(describing: self)

        if let pathXib = Bundle.main.path(forResource: nibName, ofType: "nib") {
            if fileManege.fileExists(atPath: pathXib) {
                return initWithNibTemplate()
            }
        }

        if let pathStoryboard = bundle.path(forResource: nibName, ofType: "storyboardc") {
            if fileManege.fileExists(atPath: pathStoryboard) {
                return initWithDefautlStoryboard()
            }
        }

        return initWithNibTemplate()
    }

    // MARK: 
    @objc func menuButtonAction(_ sender: UIButton) {
        // todo:
        self.mm_drawerController.toggle(.left, animated: true, completion: nil)
    }

    @objc func searchButtonAction(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            let viewcontroller = SearchViewController.initWithNib()
            let nav = BaseNavigationViewController(rootViewController: viewcontroller)
            nav.modalPresentationStyle = .overCurrentContext
            self.present(nav, animated: true, completion: nil)
        } else {
            toast("Version bigger 10.0")
        }
    }
    
    @objc func castButtonAction(_ sender: UIButton) {
        // todo:
    }

    // MARK: 
    // MARK: 
    private class func initWithDefautlStoryboard() -> Self {
        var className = String(describing: self)
        if Constants.isIpad {
            if let pathXib = Bundle.main.path(forResource: "\(className)_\(Constants.iPad)", ofType: "storyboardc") {
                if FileManager.default.fileExists(atPath: pathXib) {
                    className = "\(className)_\(Constants.iPad)"
                }
            }
        }
        let storyboardId = className
        return instantiateFromStoryboardHelper(storyboardName: className, storyboardId: storyboardId)
    }

    private class func instantiateFromStoryboardHelper<T>(storyboardName: String, storyboardId: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        return controller
    }

    deinit {
        popOverVC?.delegate = nil
        popOverVC = nil
    }
}

extension BaseViewController: WYPopoverControllerDelegate {
    class func loadFromNib<T: UIViewController>() -> T {
         return T(nibName: String(describing: self), bundle: nil)
    }
    func presentPopOverVC(viewController: UIViewController!, sender: UIView?, style: WYPopoverArrowDirection) {
        if let popOver = self.popOverVC {
            if popOver.isPopoverVisible {
                popOver.dismissPopover(animated: true, options: WYPopoverAnimationOptions.fade, completion: {
                    self.popOverVC?.delegate = nil
                    self.popOverVC = nil
                })

            } else {
                self.popOverVC?.delegate = nil
                self.popOverVC = nil
                self.popOverVC = WYPopoverController(contentViewController: viewController)
                self.popOverVC?.delegate = self
                self.popOverVC?.popoverLayoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                self.popOverVC?.wantsDefaultContentAppearance = false

                if let button = sender {
                    self.popOverVC?.presentPopover(from: button.bounds,
                                                   in: button,
                                                   permittedArrowDirections: style,
                                                   animated: true)

                } else {
                    self.popOverVC?.presentPopoverAsDialog(animated: true)
                }
            }

        } else {
            self.popOverVC = WYPopoverController(contentViewController: viewController)
            self.popOverVC?.delegate = self
            self.popOverVC?.popoverLayoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            self.popOverVC?.wantsDefaultContentAppearance = false

            if let button = sender {
                self.popOverVC?.presentPopover(from: button.bounds,
                                               in: button,
                                               permittedArrowDirections: style,
                                               animated: true)
            } else {
                self.popOverVC?.presentPopover(from: CGRect.zero,
                                               in: self.view,
                                               permittedArrowDirections: style,
                                               animated: true,
                                               options: WYPopoverAnimationOptions.fade,
                                               completion: nil)
            }
        }
    }
    
    func presentPopOverDailog(viewController: UIViewController) {
        if let popOver = self.popOverVC {
            if popOver.isPopoverVisible {
                popOver.dismissPopover(animated: true, options: WYPopoverAnimationOptions.fade, completion: {
                    self.popOverVC?.delegate = nil
                    self.popOverVC = nil
                })
                
            } else {
                self.popOverVC?.delegate = nil
                self.popOverVC = nil
                self.popOverVC = WYPopoverController(contentViewController: viewController)
                self.popOverVC?.delegate = self
                self.popOverVC?.popoverLayoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                self.popOverVC?.wantsDefaultContentAppearance = false
                
                self.popOverVC?.presentPopover(from: CGRect.zero,
                                               in: self.view,
                                               permittedArrowDirections: WYPopoverArrowDirection.none,
                                               animated: true,
                                               options: WYPopoverAnimationOptions.fade,
                                               completion: nil)
            }
            
        } else {
            self.popOverVC = WYPopoverController(contentViewController: viewController)
            self.popOverVC?.delegate = self
            self.popOverVC?.popoverLayoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            self.popOverVC?.wantsDefaultContentAppearance = false
            
            self.popOverVC?.presentPopover(from: CGRect.zero,
                                           in: self.view,
                                           permittedArrowDirections: WYPopoverArrowDirection.none,
                                           animated: true,
                                           options: WYPopoverAnimationOptions.fade,
                                           completion: nil)
        }
    }

    func dismissPopOver() {
        if let popOver = self.popOverVC {
            if popOver.isPopoverVisible {
                popOver.dismissPopover(animated: true, options: WYPopoverAnimationOptions.fade, completion: {
                    self.popOverVC?.delegate = nil
                    self.popOverVC = nil
                })

            } else {
                self.popOverVC?.delegate = nil
                self.popOverVC = nil
            }
        }
    }

    func popoverControllerDidDismissPopover(_ popoverController: WYPopoverController!) {
        self.popOverVC?.delegate = nil
        self.popOverVC = nil
    }
}
