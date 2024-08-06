//
//  TutorialPageViewController.swift
//  5dmax
//
//  Created by Admin on 3/16/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController {

    weak var tutorialDelegate: TutorialPageViewControllerDelegate?

    fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
        // The view controllers will be shown in this order
        if Constants.screenHeight == 480 {
    
            return [self.newColoredViewController("Welcome1Iphone4", title: String.mien_phi_n_hoan_toan_Data_3G_4G_n_toc_do_cao),
                    self.newColoredViewController("Welcome2Iphone4", title: String.khong_bo_lo_n_phim_chau_A_an_khach_voi_n_hang_ty_luot_xem),
                    self.newColoredViewController("Welcome3Iphone4", title: String.hang_ngan_gio_phim_n_dac_sac_tu_FOX_WBros_n_Universal_MBC_TVB)]
        } else {
            return [self.newColoredViewController("Welcome1", title: String.mien_phi_n_hoan_toan_Data_3G_4G_n_toc_do_cao),
                    self.newColoredViewController("Welcome2", title: String.khong_bo_lo_n_phim_chau_A_an_khach_voi_n_hang_ty_luot_xem),
                    self.newColoredViewController("Welcome3", title: String.hang_ngan_gio_phim_n_dac_sac_tu_FOX_WBros_n_Universal_MBC_TVB)]
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

        if let initialViewController = orderedViewControllers.first {
            scrollToViewController(initialViewController)
        }
        tutorialDelegate?.tutorialPageViewController(self,
                                                     didUpdatePageCount: orderedViewControllers.count)
    }

    /**
     Scrolls to the next view controller.
     */
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first,
            let nextViewController = pageViewController(self,
                                                        viewControllerAfter: visibleViewController) {
            scrollToViewController(nextViewController)
        }
    }

    /**
     Scrolls to the view controller at the given index. Automatically calculates
     the direction.
     
     - parameter newIndex: the new index to scroll to
     */
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
            let currentIndex = orderedViewControllers.index(of: firstViewController) {
            let direction: UIPageViewController.NavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            let nextViewController = orderedViewControllers[newIndex]
            scrollToViewController(nextViewController, direction: direction)
        }
    }

    fileprivate func newColoredViewController(_ welcome: String, title: String) -> UIViewController {
        let vc = UIStoryboard(name: "TutorialViewController", bundle: nil).instantiateViewController(withIdentifier: "\(welcome)ViewController") as! SubTutorialViewController
        vc.text = title
        return vc as UIViewController
    }

    /**
     Scrolls to the given 'viewController' page.
     
     - parameter viewController: the view controller to show.
     */
    fileprivate func scrollToViewController(_ viewController: UIViewController,
                                            direction: UIPageViewController.NavigationDirection = .forward) {
        setViewControllers([viewController],
                           direction: direction,
                           animated: true,
                           completion: { (_) -> Void in
                            // Setting the view controller programmatically does not fire
                            // any delegate methods, so we have to manually notify the
                            // 'tutorialDelegate' of the new index.
                            self.notifyTutorialDelegateOfNewIndex()
        })
    }

    /**
     Notifies '_tutorialDelegate' that the current page index was updated.
     */
    fileprivate func notifyTutorialDelegateOfNewIndex() {
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.index(of: firstViewController) {
            tutorialDelegate?.tutorialPageViewController(self,
                                                         didUpdatePageIndex: index)
        }
    }

}

// MARK: UIPageViewControllerDataSource

extension TutorialPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }

        var previousIndex = viewControllerIndex - 1

        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        if previousIndex < 0 {
            previousIndex = 0
            return nil
        }

        return orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }

        var nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        if nextIndex >= orderedViewControllersCount {
            nextIndex = orderedViewControllersCount
            return nil
        }

        return orderedViewControllers[nextIndex]
    }

}

extension TutorialPageViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        notifyTutorialDelegateOfNewIndex()
    }

}

protocol TutorialPageViewControllerDelegate: class {

    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageCount count: Int)

    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageIndex index: Int)

}
