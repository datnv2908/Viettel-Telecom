//
//  HomeCountryContainerConfiguration.swift
//  5dmax
//
//  Created by Hoang on 3/23/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class FilmContainerConfiguration: NSObject {

    class func initContainer(_ type: FilmType) -> FilmContainerViewController {

        let viewController = FilmContainerViewController.initWithNib()
        let presenter = HomeCountryContainerPresenter()

        let viewModel = HomeCountryContainerViewModel()
        viewModel.title = type.stringValue()

        let hightlightCategory = CategoryModel(.filmHot)
        viewModel.highlightsFilmVC = MoreContentViewController(hightlightCategory, fromNoti: false)

        viewModel.listCategoryVC = ListCategoryViewController.initWithType(type)

        let countryCategory = CategoryModel(.filmNational)
        viewModel.filmOfCountryVC = MoreContentViewController(countryCategory, fromNoti: false)

        presenter.viewModel = viewModel
        viewController.presenter = presenter
        return viewController
    }
}
