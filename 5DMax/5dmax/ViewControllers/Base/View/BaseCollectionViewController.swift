//
//  BaseCollectionViewController.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/8/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SVPullToRefresh

class BaseCollectionViewController: BaseViewController {

    var viewModel = CollectionViewModel()
    var groupModel: GroupModel?
    var fromNoti : Bool = false
    var sendNoti : Bool = false
    @IBOutlet weak var collectionView: UICollectionView?
    fileprivate var refreshControl = UIRefreshControl()
    var offset = kDefaultOffset
    var limit = kDefaultLimit

    override func viewDidLoad() {
        super.viewDidLoad()
        doSomethingOnload()
    }

    func doSomethingOnload() {
        // register nib
        for row in viewModel.section.rows {
            collectionView?.register(UINib(nibName: row.identifier, bundle: Bundle.main),
                                     forCellWithReuseIdentifier: row.identifier)
        }
        // add pull to refresh
        collectionView?.alwaysBounceVertical = true
        refreshControl.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.white
        collectionView?.addSubview(refreshControl)
        // add scroll to load more
        weak var wself = self
        collectionView?.addInfiniteScrolling(actionHandler: {
            wself?.getNextPage()
        })
//        collectionView?.showsInfiniteScrolling = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func reloadData() {
        for row in viewModel.section.rows {
            collectionView?.register(UINib(nibName: row.identifier, bundle: Bundle.main),
                                     forCellWithReuseIdentifier: row.identifier)
        }
        if viewModel.section.rows.isEmpty {
            collectionView?.addNoDataLabel(String.dataNotFound)
        } else {
            collectionView?.removeNoDataLabel()
        }
        refreshControl.endRefreshing()
        collectionView?.infiniteScrollingView.stopAnimating()
        collectionView?.reloadData()
        self.hideHude()
    }

    //mark: -- IBActions
    @objc func refreshData() {
        self.collectionView?.contentOffset = CGPoint.zero
        showHud()
        getData(offset: kDefaultOffset, limit: kDefaultLimit) { (_ result: Result<Any>) in
            switch result {
            case .success(let data):
                self.groupModel = data as? GroupModel
                self.viewModel = CollectionViewModel(self.groupModel!)

                self.offset = kDefaultOffset // update the current offset
                if self.offset == 0 && self.limit == 0 {
                    // offset and limit = zero when this view is not needed to have paging feature
                    if self.collectionView?.showsInfiniteScrolling == true {
                        self.collectionView?.showsInfiniteScrolling = false
                    }
                } else {
                    if self.groupModel!.content.count < kDefaultLimit {
                        if self.collectionView?.showsInfiniteScrolling == true {
                            self.collectionView?.showsInfiniteScrolling = false
                        }
                    } else {
                        if self.collectionView?.showsInfiniteScrolling == false {
                            self.collectionView?.showsInfiniteScrolling = true
                        }
                    }
                }
                self.reloadData()
                break
            case .failure(let error):
                DLog(error.localizedDescription)
                break
            }
            self.hideHude()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            if Int((self.collectionView?.infiniteScrollingView.state)!) == SVInfiniteScrollingStateLoading {
                self.collectionView?.infiniteScrollingView.stopAnimating()
            }
        }
    }

    func getNextPage() {
        let newOffset = offset + kDefaultLimit
        showHud()
        getData(offset: newOffset, limit: kDefaultLimit) { (_ result: Result<Any>) in
            switch result {
            case .success(let data):
                let model = data as! GroupModel
                self.groupModel?.content.append(contentsOf: model.content)
                self.viewModel.appendContent(model.content)

                self.offset = newOffset // update the current offset
                if model.content.count < kDefaultLimit {
                    if self.collectionView?.showsInfiniteScrolling == true {
                        self.collectionView?.showsInfiniteScrolling = false
                    }
                } else {
                    if self.collectionView?.showsInfiniteScrolling == false {
                        self.collectionView?.showsInfiniteScrolling = true
                    }
                }
                self.reloadData()
                break
            case .failure(let error):
                self.toast(error.localizedDescription)
                break
            }
            self.hideHude()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            if Int((self.collectionView?.infiniteScrollingView.state)!) == SVInfiniteScrollingStateLoading {
                self.collectionView?.infiniteScrollingView.stopAnimating()
            }
        }
    }

    func getData(offset: Int, limit: Int, _ completion: @escaping (Result<Any>) -> Void) {
        //mark: should be override in subclasses
//        fatalError("Must override in subclasses")
    }
}

extension BaseCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.section.rows.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rowModel = viewModel.section.rows[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: rowModel.identifier,
                                                      for: indexPath) as! BaseCollectionViewCell
        cell.bindingWithModel(rowModel)
        return cell
    }
}

extension BaseCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return viewModel.section.moreContentType.insetForSection()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.section.moreContentType.lineSpacing()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.section.moreContentType.itemSpacing()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.section.moreContentType.sizeForItem()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = self.groupModel {
            let filmModel = model.content[indexPath.item]
            FilmDetailWireFrame.presentFilmDetailModule(self, film: filmModel, noti: fromNoti, sendView: sendNoti)
        }
    }
}
