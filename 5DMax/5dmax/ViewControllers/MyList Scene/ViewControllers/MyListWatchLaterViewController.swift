//
//  MyListWatchLaterViewController.swift
//  5dmax
//
//  Created by Huy Nguyen on 4/18/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class MyListWatchLaterViewController: BaseCollectionViewController {

    private var model: CategoryModel
    var service = FilmService()

    init(_ type: GroupType) {
        model = CategoryModel(type)
        super.init(nibName: "MyListWatchLaterViewController", bundle: Bundle.main)
    }

    init(_ category: CategoryModel) {
        model = category
        super.init(nibName: "MyListWatchLaterViewController", bundle: Bundle.main)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(MyListWatchLaterViewController.refreshData),
                                               name: NSNotification.Name(rawValue: "DismissDetailFilm"), object: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.menuBarItem(target: self,
                                                                            btnAction: #selector(menuButtonAction(_:)))
    }

    override func doSomethingOnload() {
        super.doSomethingOnload()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func getData(offset: Int, limit: Int, _ completion: @escaping (Result<Any>) -> Void) {
        service.getMoreContent(id: model.getMoreContentId, offset: offset, limit: limit) {(model, error) in
            if error != nil {
                completion(Result.failure(error!))
            } else {
                completion(Result.success(model!))
            }
        }
    }
}
