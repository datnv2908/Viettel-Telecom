//
//  GetMoreCollectionViewController.swift
//  5dmax
//
//  Created by Toan on 6/3/21.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit
import SVPullToRefresh

class GetMoreCollectionViewController: BaseCollectionViewController {
    
    private var model: CategoryModel
    var service = FilmService()
    var nameCollection : String!
    var movieType = HomeType.normalHome
    
    init(_ type: GroupType) {
        model = CategoryModel(type)
        super.init(nibName: "MoreContentViewController", bundle: Bundle.main)
        
    }
    
    init(_ category: CategoryModel , fromNoti : Bool) {
        model = category
        super.init(nibName: "MoreContentViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = nameCollection
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.backBarItem(target: self,
                                                                            btnAction: #selector(back))
        // Do any additional setup after loading the view.
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    override func doSomethingOnload() {
        super.doSomethingOnload()
        self.refreshData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func getData(offset: Int, limit: Int, _ completion: @escaping (Result<Any>) -> Void) {
        
        var isSeries: Bool?
        if movieType == .seariesFilm {
            isSeries = true
        } else if movieType == .oddFilm {
            isSeries = false
        }
        
        service.getCollectionMoreContent(id: model.categoryId, offset: offset, limit: limit, isSeries: isSeries) { (model, error) in
            if error != nil {
                completion(Result.failure(error!))
            }else{
                completion(Result.success(model!))
            }
        }
    }
    
    func perfromUpdateCategory(_ category: CategoryModel) {
        
        model = category
        self.refreshData()
    }
    
    deinit {
    }
}
