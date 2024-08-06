//
//  HomeCountryContainerViewController.swift
//  5dmax
//
//  Created by Hoang on 3/22/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SnapKit

class FilmContainerViewController: BaseViewController {

    var presenter: HomeCountryContainerPresenter?
    let pageVC: UIPageViewController =
        UIPageViewController(transitionStyle: .scroll,
                             navigationOrientation: UIPageViewController.NavigationOrientation.horizontal,
                                                            options: nil)

    @IBOutlet weak var menuView: MenuTabBarView!
    @IBOutlet weak var mainView: UIView!

    class func initWithType(_ type: FilmType) -> FilmContainerViewController {

        let viewController = FilmContainerViewController.initWithNib()
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: 
    // MARK: 
    func setUpView() {
        self.navigationItem.leftBarButtonItem =
            UIBarButtonItem.menuBarItem(target: self, btnAction: #selector(menuButtonAction(_:)))
        let search = UIBarButtonItem.searchBarItem(target: self, btnAction: #selector(searchButtonAction(_:)))
        self.navigationItem.rightBarButtonItems = [search]
        self.addChild(pageVC)
        mainView.addSubview(pageVC.view)
        pageVC.didMove(toParent: self)
        pageVC.view.snp.makeConstraints { (constraintMaker) in
            constraintMaker.edges.equalToSuperview()
        }

        pageVC.dataSource = self
        pageVC.delegate = self
        pageVC.setViewControllers([(presenter?.viewModel?.highlightsFilmVC)!],
                                  direction: UIPageViewController.NavigationDirection.forward,
                                  animated: false,
                                  completion: nil)

        menuView.menuTabBarDelegate = self
    }

    func setUpData() {

        self.navigationItem.title = presenter?.viewModel?.title

        if let vc = self.presenter?.viewModel?.listCategoryVC {
            vc.delegate = self
        }

        if let menu = presenter?.viewModel?.getListMenuTitle() {
            menuView.perfromReloadMenuData(menu: menu)
        }
    }

    deinit {

    }
}

extension FilmContainerViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {

        if viewController == presenter?.viewModel?.highlightsFilmVC {

            return nil
        }

        if viewController == presenter?.viewModel?.listCategoryVC {

            return presenter?.viewModel?.highlightsFilmVC
        }

        if viewController == presenter?.viewModel?.filmOfCountryVC {

            return presenter?.viewModel?.listCategoryVC
        }

        return nil
    }

    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerAfter viewController: UIViewController) -> UIViewController? {

        if viewController == presenter?.viewModel?.highlightsFilmVC {

            return presenter?.viewModel?.listCategoryVC
        }

        if viewController == presenter?.viewModel?.listCategoryVC {

            if presenter?.viewModel?.selectedCategory != nil {

                return presenter?.viewModel?.filmOfCountryVC
            }
        }

        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {

        if completed {

            if let currentVC = pageViewController.viewControllers?.last {

                if let currentIndex = presenter?.viewModel?.getIndexOfView(currentVC: currentVC) {
                    menuView.perfromSetCurrentIndex(currentIndex: currentIndex)
                }
            }
        }
    }
}

// MARK: 
// MARK: 
extension FilmContainerViewController: ListCategoryViewControllerDelegate {
    func didSelectCountry(viewController: ListCategoryViewController, category: CategoryModel) {

        presenter?.viewModel?.selectedCategory = category
        presenter?.viewModel?.filmOfCountryVC?.perfromUpdateCategory(category)

        if let menu = presenter?.viewModel?.getListMenuTitle() {
            menuView.perfromReloadMenuData(menu: menu)
            menuView.perfromSetCurrentIndex(currentIndex: 2)
        }

        pageVC.setViewControllers([(presenter?.viewModel?.filmOfCountryVC)!],
                                  direction: UIPageViewController.NavigationDirection.forward,
                                  animated: true,
                                  completion: nil)
    }
}

extension FilmContainerViewController: MenuTabBarViewDelegate {

    func menuBarDidSelect(menuBar: MenuTabBarView, index: IndexPath) {

        if let currentVC = pageVC.viewControllers?.last {

            if let currentIndex = presenter?.viewModel?.getIndexOfView(currentVC: currentVC) {

                if let vc = presenter?.viewModel?.getViewAtIndex(index: index.row) {

                    if index.row > currentIndex {

                        pageVC.setViewControllers([vc],
                                                  direction: UIPageViewController.NavigationDirection.forward,
                                                  animated: true,
                                                  completion: nil)

                    } else if index.row < currentIndex {

                        pageVC.setViewControllers([vc],
                                                  direction: UIPageViewController.NavigationDirection.reverse,
                                                  animated: true,
                                                  completion: nil)
                    }

                    menuView.perfromSetCurrentIndex(currentIndex: index.row)
                }
            }
        }
    }
}
