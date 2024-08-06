//
//  MyListViewController.swift
//  5dmax
//
//  Created by Gem on 4/11/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class MyListViewController: BaseViewController {

    let viewModel: MyListViewModel = MyListViewModel()
    let pageVC: UIPageViewController =
        UIPageViewController(transitionStyle: .scroll,
                             navigationOrientation: UIPageViewController.NavigationOrientation.horizontal,
                             options: nil)
    @IBOutlet weak var menuView: MenuTabBarView!
    @IBOutlet weak var mainView: UIView!
    var mylistVC: MyListWatchLaterViewController!
    var watchingVC: MyListWatchingViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpData()
    }

    func setUpView() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.menuBarItem(target: self,
                                                                            btnAction: #selector(menuButtonAction(_:)))
        self.addChild(pageVC)
        mainView.addSubview(pageVC.view)
        pageVC.didMove(toParent: self)
        pageVC.view.snp.makeConstraints { (constraintMaker) in
            constraintMaker.edges.equalToSuperview()
        }
        pageVC.dataSource = self
        pageVC.delegate = self

        self.mylistVC = MyListWatchLaterViewController(CategoryModel(.myList))
        self.watchingVC = MyListWatchingViewController(CategoryModel(.filmHistoryView))

        pageVC.setViewControllers([self.mylistVC],
                                  direction: UIPageViewController.NavigationDirection.forward,
                                  animated: false,
                                  completion: nil)
        menuView.menuTabBarDelegate = self
    }

    func updateBarButton(_ currentIndex: Int) {
        if currentIndex == MyList.later.rawValue {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            self.navigationItem.rightBarButtonItem =
                UIBarButtonItem.composeBarButton(target: self, action: #selector(onEdit))
        }
    }

    func setUpData() {
        self.viewModel.view = self
        self.navigationItem.title = self.viewModel.title
        menuView.perfromReloadMenuData(menu: self.viewModel.listMenuTitle)
    }

    @objc func onEdit() {
        self.watchingVC.onEdit()
    }
}

extension MyListViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController == self.watchingVC {
            return self.mylistVC
        }
        return nil
    }

    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController == self.mylistVC {
            return self.watchingVC
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool, previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed {
            if let currentVC = pageViewController.viewControllers?.last {
                let currentVCIndex = self.viewModel.currentIndex(ofVC: currentVC)
                menuView.perfromSetCurrentIndex(currentIndex: currentVCIndex)
                updateBarButton(currentVCIndex)
            }
        }
    }
}

extension MyListViewController: MenuTabBarViewDelegate {

    func menuBarDidSelect(menuBar: MenuTabBarView, index: IndexPath) {

        if let currentVC = pageVC.viewControllers?.last {
            let currentVCIndex = self.viewModel.currentIndex(ofVC: currentVC)

            if let vc = self.viewModel.viewAtIndex(index.row) {
                if index.row > currentVCIndex {
                    pageVC.setViewControllers([vc],
                                              direction: UIPageViewController.NavigationDirection.forward,
                                              animated: true,
                                              completion: nil)
                } else if index.row < currentVCIndex {
                    pageVC.setViewControllers([vc],
                                              direction: UIPageViewController.NavigationDirection.reverse,
                                              animated: true,
                                              completion: nil)
                }
                menuView.perfromSetCurrentIndex(currentIndex: index.row)
                updateBarButton(index.row)
            }
        }
    }
}
