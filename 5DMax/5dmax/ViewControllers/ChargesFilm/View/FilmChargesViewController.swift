//
//  FilmChargesViewController.swift
//  5dmax
//
//  Created by admin on 8/20/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class FilmChargesViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    private var homeContext = 1
    fileprivate var viewsModel: HomeViewModel = HomeViewModel()
    fileprivate var groups = [GroupModel]()
    fileprivate var storedOffset: [Int: CGPoint] = [:]
    let service: FilmService = FilmService()
    let refreshControl = UIRefreshControl()
    var isLoading: Bool = false
    var currenOffset = kDefaultOffset
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //reloadData()
        setNavigation()
    }
    
    func setNavigation() {
        self.navigationItem.title = String.cho_thue_noi_dung
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuBarItem(target: self, btnAction: #selector(menuButtonAction(_:)))
    }
    
    func setupView() {
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(getData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func getData() {
        showHud()
        service.cancelAllRequests()
        service.getChargesFilm { (result, error) in
            if error == nil {
                self.groups = result
                self.viewsModel = HomeViewModel(result, isShowPrice: true)
                self.reloadData()
            } else {
                self.toast((error?.localizedDescription)!)
            }
            self.refreshControl.endRefreshing()
            self.hideHude()
        }
    }
    
    func getMoreData(offset: Int, limit: Int) {
        DLog("getMoreData")
    }
    
    func reloadData() {
        for section in (viewsModel.sections) {
            tableView.register(UINib(nibName: section.identifier, bundle: Bundle.main),
                               forCellReuseIdentifier: section.identifier)
        }
        storedOffset.removeAll()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension FilmChargesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewsModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: (viewsModel.sections[indexPath.section].identifier), for: indexPath) as! CollectionTableViewCell
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let sectionModel = viewsModel.sections[indexPath.section]
        (cell as! CollectionTableViewCell).delegate = self
        (cell as! CollectionTableViewCell).bindingWith(sectionModel)
        if sectionModel.blockType == .film , sectionModel.blockType == .series {
            if let offset = storedOffset[indexPath.section] {
                (cell as! CollectionTableViewCell).setCollectionViewOffset(offset)
            } else {
                (cell as! CollectionTableViewCell).setCollectionViewOffset(CGPoint.zero)
            }
        }
    }
}

extension FilmChargesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionModel = viewsModel.sections[indexPath.section]
        return sectionModel.sizeForSection().height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionModel = viewsModel.sections[section]
        let view = SectionHeaderView.dequeueReuseHeaderWithNib(in: tableView, reuseIdentifier: SectionHeaderView.nibName())
        view.bindingWithCharges(sectionModel)
        return view
    }
}

extension FilmChargesViewController: CollectionTableViewCellDelegate {
    func collectionTableViewCell(_ cell: CollectionTableViewCell, didSelectAddSeeLate index: Int) {
        
    }
    
    func collectionTableViewCell(_ cell: CollectionTableViewCell, playTrailer index: Int) {
        
    }
    
    func collectionTableViewCell(_ cell: CollectionTableViewCell, setVolume index: Int) {
        
    }
    
    func collectionTableViewCell(_ cell: CollectionTableViewCell, didSelectViewInfoItemAtIndex index: Int, film: FilmModel?) {
        if let filmModel = film {
            FilmDetailWireFrame.presentFilmDetailModule(self, film: filmModel, noti: false, sendView: false)
        }
    }
    
    func collectionTableViewCell(_ cell: CollectionTableViewCell, didSelectItemAtIndex index: Int, film: FilmModel?) {
        if let mFilm = film {
            FilmDetailWireFrame.presentFilmDetailModule(self, film: mFilm, noti: false, sendView: false)
        }
    }
    
    func collectionTableViewCell(_ cell: CollectionTableViewCell, didScroll scrollView: UIScrollView) {
        let indexPath = tableView.indexPath(for: cell)
        if let path = indexPath {
            storedOffset[path.section] = scrollView.contentOffset
        }
        weak var wself = self
        tableView.addInfiniteScrolling {
            let offset = (wself?.currenOffset)! + kDefaultLimit
            wself?.getMoreData(offset: offset, limit: kDefaultLimit)
        }
        tableView.showsInfiniteScrolling = false
    }
}
