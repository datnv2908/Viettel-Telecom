//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//
import Foundation
import UIKit
import RealmSwift
import FirebasePerformance

class SearchPresenter: NSObject {
    var view: SearchViewControllerInput?
    var viewModel: SearchViewModel?
    var interactor: SearchInteractorInput?
    var wireFrame: SearchWireFrameInput?
    var currentOffset = Constants.kFirstOffset
    var currentLimit = Constants.kDefaultLimit
}

// MARK: 
// MARK: VIEW
extension SearchPresenter: SearchViewControllerOutput {
    func viewDidLoad() {
        if DataManager.checkShowKeywordSearch() {
            interactor?.getKeyword(completion: { (result) in
                switch result {
                case .success(let response):
                    DataManager.setHiddenKeywordSearch()
                    self.viewModel?.updateWithKeyword(data: response.data)
                    self.view?.updateView()
                    break
                case .failure(_):
                    break
                }
            })
        } else {
            let models = interactor?.getHistorySearch(keyword: "")
            viewModel?.updateWithHistoriesSearch(data: models!)
            view?.updateView()
        }
    }

    func viewWillAppear() {

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func onEditTableCell(_ object: SearchRealmModel) {
        interactor?.deleteHistorySearch(object)
    }
    
    func onTextChange(_ textField: UITextField) {
        var text = textField.text ?? ""
        text = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if text.isEmpty {
            let models = interactor?.getHistorySearch(keyword: "")
            viewModel?.updateWithHistoriesSearch(data: models!)
            self.view?.showsInfiniteScrolling(enable: false)
            view?.updateView()
        } else {
            self.currentOffset = Constants.kFirstOffset
            let trace = Performance.startTrace(name:"SearchSuggestion")
            viewModel?.currentKeyword = text
            interactor?.searchSuggest(query: text, completion: { (result) in
                switch result {
                case .success(let response):
                    self.viewModel?.updateWithSearchSuggest(data: response.data)
                    // change enable Infinite Scrolling
                    let data:[SearchGroupModel] = response.data
                    if data.count > 0 {
                        let item = data[0]
                        if self.currentOffset == 0 && self.currentLimit == 0 {
                            // offset and limit = zero when this view is not needed to have paging feature
                            // infinite Scrolling will not be appeared
                        } else {
                            if item.contents.count < Constants.kDefaultLimit {
                                self.view?.showsInfiniteScrolling(enable: false)
                            } else {
                                self.view?.showsInfiniteScrolling(enable: true)
                            }
                        }
                    }
                    self.view?.updateView()
                    break
                case .failure(let error):
                    (self.view as? SearchViewController)?.toast(error.localizedDescription)
                    break
                }
                trace?.stop()
            })
        }
    }
    
    func onSearchClicked(_ textField: UITextField) {
        var text = textField.text ?? ""
        text = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if text.isEmpty {
            let fromViewController = view as! BaseViewController
            fromViewController.toast(String.vui_long_nhap_noi_dung_tim_kiem)
            textField.text = ""
            return
        }
        
        LoggingRecommend.searchAction(keyword: textField.text!)
        let trace = Performance.startTrace(name:"DoSearch")
        
        viewModel?.currentKeyword = text
        //realm
        saveToRealm(text)
        //Search result
        self.currentOffset = Constants.kFirstOffset
        interactor?.search(query: text, completion: { (result) in
            switch result {
            case .success(let response):
                self.viewModel?.updateWithSearchResult(data: response.data)
                // change enable Infinite Scrolling
                let data:[GroupModel] = response.data
                if data.count > 0 {
                    let item = data[0]
                    if self.currentOffset == 0 && self.currentLimit == 0 {
                        // offset and limit = zero when this view is not needed to have paging feature
                        // infinite Scrolling will not be appeared
                    } else {
                        if item.videos.count < Constants.kDefaultLimit {
                            self.view?.showsInfiniteScrolling(enable: false)
                        } else {
                            self.view?.showsInfiniteScrolling(enable: true)
                        }
                    }
                }
                self.view?.updateView()
                break
            case .failure(let error):
                (self.view as? SearchViewController)?.toast(error.localizedDescription)
                break
            }
            trace?.stop()
        })
        textField.resignFirstResponder()
    }
    
    func didSelectItem(at index: IndexPath) {
        if viewModel?.searchType == .history {
            let keyword = (viewModel?.listSearchHistory[index.row].keyword)!
            if keyword.isEmpty {
                return
            } else {
                viewModel?.currentKeyword = keyword
                interactor?.search(query: (viewModel?.listSearchHistory[index.row].keyword)!, completion: { (result) in
                    switch result {
                    case .success(let response):
                        self.viewModel?.updateWithSearchResult(data: response.data)
                        (self.view as? SearchViewController)?.searchTextField.text = (self.viewModel?.listSearchHistory[index.row].keyword)!
                        // change enable Infinite Scrolling
                        let data:[GroupModel] = response.data
                        if data.count > 0 {
                            let item = data[0]
                            if self.currentOffset == 0 && self.currentLimit == 0 {
                                // offset and limit = zero when this view is not needed to have paging feature
                                // infinite Scrolling will not be appeared
                            } else {
                                if item.videos.count < Constants.kDefaultLimit {
                                    self.view?.showsInfiniteScrolling(enable: false)
                                } else {
                                    self.view?.showsInfiniteScrolling(enable: true)
                                }
                            }
                        }
                        self.view?.updateView()
                        self.saveToRealm((self.viewModel?.listSearchHistory[index.row].keyword)!)
                        (self.view as? SearchViewController)?.searchTextField.resignFirstResponder()
                        break
                    case .failure(_):
                        break
                    }
                })
            }
        } else if viewModel?.searchType == .keyword {
            interactor?.search(query: (viewModel?.listKeyword[index.row])!, completion: { (result) in
                switch result {
                case .success(let response):
                    self.viewModel?.updateWithSearchResult(data: response.data)
                    (self.view as? SearchViewController)?.searchTextField.text = (self.viewModel?.listKeyword[index.row])!
                    self.view?.updateView()
                    self.saveToRealm((self.viewModel?.listKeyword[index.row])!)
                    (self.view as? SearchViewController)?.searchTextField.resignFirstResponder()
                    break
                case .failure(_):
                    break
                }
            })
        } else if viewModel?.searchType == .searchSuggest {
            let section = viewModel?.listSearchSuggest[index.section]
            if section?.type == GroupType.video.rawValue {
                if let model = section?.contents[index.row] {
                    self.wireFrame?.doShowVideoDetail(model: model)
                    saveToRealm(model.name)
                }
            } else if section?.type == GroupType.channel.rawValue {
                let model = section?.contents[index.row]
               self.wireFrame?.doShowChannelDetail(model: ChannelModel(id: (model?.id)!, name: (model?.name)!,numFollow: 0, numVideo: 0, viewCount: 0))
                saveToRealm((model?.name)!)
            } else if section?.type == GroupType.search.rawValue { // trs: for ////search-suggestion-v2////
                if let model = section?.contents[index.row] {
                    if model.type == ContentType.channel.rawValue {
                     self.wireFrame?.doShowChannelDetail(model: ChannelModel(id: model.id, name: model.name, numFollow: 0, numVideo: 0, viewCount: 0))
                        saveToRealm(model.name)
                    }else if model.type == ContentType.video.rawValue {
                        self.wireFrame?.doShowVideoDetail(model: model)
                        saveToRealm(model.name)
                    }
                }
            }
            (self.view as? SearchViewController)?.searchTextField.resignFirstResponder()
        } else {
            let section = viewModel?.listSearchResult[index.section]
            if section?.type == GroupType.video.rawValue {
                if let model = section?.videos[index.row] {
                    self.wireFrame?.doShowVideoDetail(model: model)
                }
            } else if section?.type == GroupType.channel.rawValue {
                if let model = section?.channels[index.row] {
                    self.wireFrame?.doShowChannelDetail(model: model)
                }
            } else if section?.type == GroupType.search.rawValue { // trs: for ////search-suggestion-v2////
                if let model = section?.videos[index.row] {
                    if model.type == ContentType.channel.rawValue {
                     self.wireFrame?.doShowChannelDetail(model: ChannelModel(id: model.id, name: model.name,numFollow: 0, numVideo: 0, viewCount: 0))
                        saveToRealm(model.name)
                    }else if model.type == ContentType.video.rawValue {
                        self.wireFrame?.doShowVideoDetail(model: model)
                        saveToRealm(model.name)
                    }
                }
            }
            (self.view as? SearchViewController)?.searchTextField.resignFirstResponder()
        }
    }
    
    func onLoadMore(_ sender: UITableView) {
        
    }
    
    func onSelectActionButton(at indexPath: IndexPath) {
        if viewModel?.searchType == .searchSuggest {
            let model = viewModel?.listSearchSuggest[indexPath.section].contents[indexPath.row]
            self.wireFrame?.doShowActionMore(model: model!)
        } else if viewModel?.searchType == .search {
            let model = viewModel?.listSearchResult[indexPath.section].videos[indexPath.row]
            self.wireFrame?.doShowActionMore(model: model!)
        }
    }
    
    func saveToRealm(_ keyword: String) {
        let realm = try! Realm()
        let objects =
            realm.objects(SearchRealmModel.self).filter("keyword == %@", keyword)
        if !objects.isEmpty {
            try! realm.write {
                let searchRealm = objects.first
                searchRealm?.date = Date()
                realm.add(searchRealm!, update: true)
            }
        } else {
            try! realm.write {
                let searchRealm = SearchRealmModel()
                searchRealm.keyword = keyword
                realm.add(searchRealm)
            }
        }
    }
    
    func didSelectCancelButton() {
        let models = interactor?.getHistorySearch(keyword: "")
        viewModel?.updateWithHistoriesSearch(data: models!)
        view?.updateView()
    }
    
    func didSelectLoadMoreButton(section: Int) {
        viewModel?.doUpdateWithLoadMore(at: section)
        view?.updateView()
    }
    
    func getNextPage() {
        let pager = Pager(offset: currentOffset + currentLimit, limit: currentLimit)
        if let text = viewModel?.currentKeyword {
            let trace = Performance.startTrace(name:"DoSearch")
            interactor?.getMoreDataSearch(query: text , pager: pager, completion: { (result) in
                switch result {
                case .success(let response):
                    self.viewModel?.updateWithSearchMoreResult(data: response.data)
                    
                    // change enable Infinite Scrolling
                    let data:[GroupModel] = response.data
                    if data.count > 0 {
                        let item = data[0]
                        if self.currentOffset == 0 && self.currentLimit == 0 {
                            // offset and limit = zero when this view is not needed to have paging feature
                            // infinite Scrolling will not be appeared
                        } else {
                            if item.videos.count < Constants.kDefaultLimit {
                                self.view?.showsInfiniteScrolling(enable: false)
                            } else {
                                self.view?.showsInfiniteScrolling(enable: true)
                            }
                        }
                    }
                    self.currentOffset = pager.offset // update the current page
                    self.view?.updateView()
                    break
                case .failure(let error):
                    (self.view as? SearchViewController)?.toast(error.localizedDescription)
                    break
                }
                trace?.stop()
                self.view?.stopAnimating()
            })
        }
    }
    
    func getNextSuggestPage() {
        let pager = Pager(offset: currentOffset + currentLimit, limit: currentLimit)
        if let text = viewModel?.currentKeyword {
            let trace = Performance.startTrace(name:"SearchSuggestion")
            interactor?.getMoreDataSearchSuggest(query: text , pager: pager, completion: { (result) in
                switch result {
                case .success(let response):
                    self.viewModel?.updateWithSearchMoreSuggest(data: response.data)
                    
                    // change enable Infinite Scrolling
                    let data:[SearchGroupModel] = response.data
                    if data.count > 0 {
                        let item = data[0]
                        if self.currentOffset == 0 && self.currentLimit == 0 {
                            // offset and limit = zero when this view is not needed to have paging feature
                            // infinite Scrolling will not be appeared
                        } else {
                            if item.contents.count < Constants.kDefaultLimit {
                                self.view?.showsInfiniteScrolling(enable: false)
                            } else {
                                self.view?.showsInfiniteScrolling(enable: true)
                            }
                        }
                    }
                    self.currentOffset = pager.offset // update the current page
                    self.view?.updateView()
                    break
                case .failure(_):
                    //                    (self.view as? SearchViewController)?.toast(error.localizedDescription)
                    break
                }
                trace?.stop()
                self.view?.stopAnimating()
            })
        }
    }
    
    func didSelectFillButton(at indexpath: IndexPath) {
        let model = self.viewModel?.data[indexpath.section].rows[indexpath.row]
        self.viewModel?.currentKeyword = (model?.title)!
        (self.view as? SearchViewController)?.searchTextField.text = (model?.title)!
        interactor?.searchSuggest(query: (model?.title)!, completion: { (result) in
            switch result {
            case .success(let response):
                self.viewModel?.updateWithSearchSuggest(data: response.data)
                // change enable Infinite Scrolling
                let data:[SearchGroupModel] = response.data
                if data.count > 0 {
                    let item = data[0]
                    if self.currentOffset == 0 && self.currentLimit == 0 {
                        // offset and limit = zero when this view is not needed to have paging feature
                        // infinite Scrolling will not be appeared
                    } else {
                        if item.contents.count < Constants.kDefaultLimit {
                            self.view?.showsInfiniteScrolling(enable: false)
                        } else {
                            self.view?.showsInfiniteScrolling(enable: true)
                        }
                    }
                }
                self.view?.updateView()
                break
            case .failure(let error):
                (self.view as? SearchViewController)?.toast(error.localizedDescription)
                break
            }
        })
    }
}

// MARK: 
// MARK: INTERACTOR
extension SearchPresenter: SearchInteractorOutput {

}

// MARK: 
// MARK: WIRE FRAME
extension SearchPresenter: SearchWireFrameOutput {

}
