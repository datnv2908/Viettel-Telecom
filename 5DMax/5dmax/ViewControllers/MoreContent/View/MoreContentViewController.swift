//
//  MoreContentViewController.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/16/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class MoreContentViewController: BaseCollectionViewController {

    @IBOutlet weak var headerNavigationConstant: NSLayoutConstraint!
    private var model: CategoryModel
    @IBOutlet weak var titleNavi: UILabel!
    var service = FilmService()
    var isFromMenu : Bool = false
    var presentFrom : Bool = false
    var isCollection : Bool = false
    var movieType = HomeType.normalHome
    init(_ type: GroupType ,  fromNoti : Bool) {
        model = CategoryModel(type)
        super.init(nibName: "MoreContentViewController", bundle: Bundle.main)
        self.fromNoti = fromNoti
        
    }

    init(_ category: CategoryModel ,fromNoti : Bool) {
        model = category
        super.init(nibName: "MoreContentViewController", bundle: Bundle.main)
        self.fromNoti = fromNoti
       
    }
    init(_ category: CategoryModel ,fromNoti : Bool,presentFrom : Bool,isCollection : Bool) {
        model = category
        super.init(nibName: "MoreContentViewController", bundle: Bundle.main)
        self.fromNoti = fromNoti
        self.presentFrom = presentFrom
        self.isCollection = isCollection
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = model.name
        if presentFrom{
            self.headerNavigationConstant.constant = 45
        }else{
            self.headerNavigationConstant.constant = 0
        }
        if isFromMenu  {
            let backButton =  UIButton()
            backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
            backButton.setImage(UIImage(named: "back"), for: .normal)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        }else{
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.menuBarItem(target: self,
                                                                            btnAction: #selector(menuButtonAction(_:)))
        }
        // Do any additional setup after loading the view.
    }
    @objc func backAction(){
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
        if isCollection {
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
                self.titleNavi.text = model?.name
                self.title =  model?.name
                self.view.layoutIfNeeded()
            }
        }
        }else{
            service.getMoreContent(id: model.getMoreContentId, offset: offset, limit: limit) {(model, error) in
                if error != nil {
                    completion(Result.failure(error!))
                } else {
                    completion(Result.success(model!))
                    self.titleNavi.text = model?.name
                    self.title =  model?.name
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func perfromUpdateCategory(_ category: CategoryModel) {

        model = category
        self.refreshData()
    }

    deinit {
    }
}
