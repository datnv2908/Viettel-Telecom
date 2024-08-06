//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//
import UIKit

class SearchConfigurator: NSObject {
    
    class func viewController() -> SearchViewController {
        let view = SearchViewController.initWithNib()
        let presenter = SearchPresenter()
        let viewModel = SearchViewModel()
        let wireFrame = SearchWireFrame()
        let interactor = SearchInteractor()
        
        presenter.viewModel = viewModel
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        presenter.view = view
        
        wireFrame.viewController = view
        view.presenter = presenter
        view.viewModel = viewModel
        
        interactor.presenter = presenter
        wireFrame.presenter = presenter
        return view
    }
}

//===================== VIEW ============================
//=======================================================
// MARK:
// MARK: VIEW
protocol SearchViewControllerInput: class {
    func updateView()
    func stopAnimating()
    func showsInfiniteScrolling(enable: Bool)
}

protocol SearchViewControllerOutput: class {
    
    func viewDidLoad()
    func viewWillAppear()
    func textFieldDidBeginEditing(_ textField: UITextField)
    func onTextChange(_ textField: UITextField)
    func onSearchClicked(_ textField: UITextField)
    func didSelectItem(at index: IndexPath)
    func onLoadMore(_ sender: UITableView)
    func onSelectActionButton(at indexPath: IndexPath)
    func didSelectLoadMoreButton(section: Int)
    func didSelectCancelButton()
    func didSelectFillButton(at indexpath: IndexPath)
    func onEditTableCell(_ object: SearchRealmModel)
    func getNextPage()
    func getNextSuggestPage()
}

//========================= VIEW MODEL =================
//=======================================================
// MARK:
// MARK: VIEW MODEL
protocol SearchViewModelInput: class {
    func updateWithHistoriesSearch(data: [SearchRealmModel])
    func updateWithSearchResult(data: [GroupModel])
    func updateWithKeyword(data: [String])
    func updateWithSearchSuggest(data: [SearchGroupModel])
    func doUpdateWithLoadMore(at groupIndex: Int)
}

protocol SearchViewModelOutput: class {
    var isShowAllChannel: Bool {get set}
    var data: [SectionModel] {get set}
    var currentKeyword: String {get set}
    var searchType: SearchType {get set}
    var listSearchHistory: [SearchRealmModel] {get set}
    var listKeyword: [String] {get set}
    var listSearchSuggest: [SearchGroupModel] {get set}
    var listSearchResult: [GroupModel] {get set}
    func getTitle() -> String?
}

//==================== INTERACTOR =======================
//=======================================================
// MARK:
// MARK: INTERACTOR
protocol SearchInteractorInput: class {
    func getHistorySearch(keyword: String) -> [SearchRealmModel]
    func deleteHistorySearch(_ object: SearchRealmModel)
    func deleteAllHistorySearch()
    func getKeyword(completion: @escaping (Result<APIResponse<[String]>>) -> Void)
    func searchSuggest(query: String, completion: @escaping (Result<APIResponse<[SearchGroupModel]>>) -> Void)
    func search(query: String, completion: @escaping (Result<APIResponse<[GroupModel]>>) -> Void)
    func getMoreDataSearch(query: String, pager: Pager, completion: @escaping (Result<APIResponse<[GroupModel]>>) -> Void)
    func getMoreDataSearchSuggest(query: String, pager: Pager, completion: @escaping (Result<APIResponse<[SearchGroupModel]>>) -> Void)
}

protocol SearchInteractorOutput: class {
    
}

//==================== WIRE FRAME =======================
//=======================================================
// MARK:
// MARK: WIRE FRAME
protocol SearchWireFrameInput: class {
    func doShowVideoDetail(model: ContentModel)
    func doShowChannelDetail(model: ChannelModel)
    func doShowActionMore(model: ContentModel)
}

protocol SearchWireFrameOutput: class {
    
}
