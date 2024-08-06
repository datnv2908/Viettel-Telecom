//
//  SearchViewController.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SnapKit
import Speech

@available(iOS 10.0, *)
@available(iOS 10.0, *)
@available(iOS 10.0, *)
@available(iOS 10.0, *)
class SearchViewController: BaseCollectionViewController {

    fileprivate var searchBar = UISearchBar()
    fileprivate let service = FilmService()
    fileprivate let setingService = SettingService()
    fileprivate var trendingModel: TrendingViewModel?
    var suggestionModel = CollectionViewModel()
    var searchServices = SearchServices()
    var objectModel = SearchHistoryObject()
    var searchModel: [SearchHistoryModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var voicetextLabel: UILabel!
    @IBOutlet var voiceView: UIView!
    @IBOutlet weak var microphoneButton: UIButton!
    @objc fileprivate var searchKeyword: String = ""
    var fadedView: UIView = UIView()
    
    @IBOutlet weak var nodataLabel: UILabel!
    @IBOutlet weak var recommendLabel: UILabel!
    @IBOutlet weak var nodataView: UIView!
    @IBOutlet weak var collectionViewTop: NSLayoutConstraint?
    @IBOutlet weak var collectionViewNoData: NSLayoutConstraint?
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let cancelItem = UIBarButtonItem(title: String.cancel, style: .plain, target: self, action: #selector(onBack))
        let voiceItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icVoice"), style: .plain, target: self, action: #selector(onVoiceSearch(_:)))
        self.navigationItem.rightBarButtonItems = [cancelItem]

        let searchField = searchBar.value(forKey: "searchField") as! UITextField
        searchField.backgroundColor = AppColor.searchBarBackgroundColor()
        searchField.textColor = AppColor.graySearchBar()
        searchBar.layer.cornerRadius = 4
        searchBar.barStyle = .black
        searchBar.placeholder = String.tim_kiem
        searchBar.delegate = self
        searchBar.frame.size.height = 30.0
        self.navigationItem.titleView = searchBar
        self.offset = 0
        self.limit = 0
        self.nodataLabel.text = ""
        self.recommendLabel.text = ""
        setupView()
        searchBar.becomeFirstResponder()
    }
    
    func setupView() {
        voiceView.layer.cornerRadius = 10
        voiceView.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        Constants.appDelegate.rootViewController.drawerController.openDrawerGestureModeMask = .custom
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Constants.appDelegate.rootViewController.drawerController.openDrawerGestureModeMask = .bezelPanningCenterView
    }

    override func doSomethingOnload() {
        super.doSomethingOnload()

        if searchServices.getSearchHistory().count > 0 {
            self.searchServices.getSearchHistory()
        }

        self.addObserver(self,
                         forKeyPath: #keyPath(SearchViewController.searchKeyword),
                         options: [.initial, .new, .old],
                         context: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func getData(offset: Int, limit: Int, _ completion: @escaping (Result<Any>) -> Void) {
        self.nodataLabel.text = ""
        self.recommendLabel.text = ""
        self.nodataView.isHidden = true
        if (searchKeyword.count < 3) {
            self.hideHude()
            viewModel.section.rows.removeAll()
            self.collectionView?.reloadData()
            self.collectionView?.addNoDataLabel(String.khong_tim_thay_ket_qua)
            self.historyTableView.isHidden = true
            self.tableView.isHidden = true
            completion(Result.failure(NSError.errorWith(code: 0, message: String.khong_tim_thay_ket_qua)))
            return
        }
        service.search(keyword: searchKeyword) { (model, error) in
            self.historyTableView.isHidden = true
            self.tableView.isHidden = true
            if error != nil {
                if (error?.code == 888888) {
                    self.collectionViewNoData?.priority = UILayoutPriority(rawValue: 750)
                    self.collectionViewTop?.priority = UILayoutPriority(rawValue: 250)
                    self.nodataLabel.text = String.khong_tim_thay_ket_qua_cho_tu_khoa + " \"\(self.searchKeyword)\""
                    self.recommendLabel.text = String.goi_y_ket_qua
                    self.nodataView.isHidden = false
                    completion(Result.success(model!))
                    if model!.content.count > 0 {
                        self.collectionView?.backgroundView = nil
                    } else {
                        self.collectionView?.addNoDataLabel(String.khong_tim_thay_ket_qua)
                    }
                } else {
                    completion(Result.failure(error!))
                    if let errMsg = error?.localizedDescription, errMsg.count > 0 {
                        self.collectionView?.addNoDataLabel(errMsg)
                    } else {
                        self.collectionView?.addNoDataLabel(String.khong_tim_thay_ket_qua)
                    }
                }
            } else {
                self.collectionViewNoData?.priority = UILayoutPriority(rawValue: 250)
                self.collectionViewTop?.priority = UILayoutPriority(rawValue: 750)
                self.nodataLabel.text = ""
                self.recommendLabel.text = ""
                self.nodataView.isHidden = true
                completion(Result.success(model!))
                if model!.content.count > 0 {
                    self.collectionView?.backgroundView = nil
                } else {
                    self.collectionView?.addNoDataLabel(String.khong_tim_thay_ket_qua)
                }
            }
        }
    }
    
    func getSuggestion(_ keySearch: String,_ completion: @escaping(Result<Any>) -> Void) {
        self.tableView.removeNoDataLabel()
        setingService.searchSuggestion(search: keySearch) { (model, error) in
            if error != nil {
                completion(Result.failure(error!))
            } else {
                completion(Result.success(model))
//                if model!.content.count > 0 {
                    self.tableView.reloadData()
//                    self.tableView.removeNoDataLabel()
//                } else {
//                    self.tableView.addNoDataLabel(String.khong_tim_thay_ket_qua)
//                    self.tableView.reloadData()
//                }
            }
        }
    }
    
    func requestSuggestionAPI() {
        self.tableView.reloadData()
        self.getSuggestion(searchBar.text!) { (result) in
            
            switch result {
            case .success(let response):
                self.groupModel = response as? GroupModel
                self.viewModel = CollectionViewModel(self.groupModel!)
                self.historyTableView.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
                break
            case .failure(let error):
                DLog(error.localizedDescription)
                break
            }
        }
    }
    
    func requestSuggestionRealm() {
        self.tableView.reloadData()
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(SearchViewController.searchKeyword) {
            if searchKeyword.isEmpty {
                collectionView?.isHidden = true
            } else {
                collectionView?.isHidden = false
                if !searchKeyword.trimmingCharacters(in: .whitespaces).isEmpty {
                    let searchhistoryModel = SearchHistoryModel(keyID: searchKeyword.getDateTimeCurrent(), search: searchKeyword)
                    self.searchModel.append(searchhistoryModel)
                    self.searchServices.saveHistorySearch(model: searchhistoryModel)
                }
            }
            self.searchBar.text = searchKeyword
            
        } else {
            super.observeValue(forKeyPath: keyPath, of: self, change: change, context: context)
        }
    }
    
    //mark: -- IBActions
    @objc func onBack() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    func onSearch(_ keyword: String) {
        searchBar.resignFirstResponder()
        self.setValue(keyword, forKeyPath: #keyPath(SearchViewController.searchKeyword))
        if !keyword.isEmpty {
            self.historyTableView.isHidden = true
            self.tableView.isHidden = true
            self.refreshData()
        }
    }
    
    @objc func onVoiceSearch(_ sender: UIButton) {
        searchBar.resignFirstResponder()
        
        let status = AppPermission.statusMicrophone
        switch status {
        case .notDetermined:
            AppPermission.requestMicrophone { (permisstion) in
                self.doGoVoiceSearchScreen()
            }
            return
            
        case .denied:
            self.alertView(nil, message: String.vui_long_cho_phep_quyen_su_dung_MicroPhone_de_tiep_tuc)
            return
        case .authorized:
            self.doGoVoiceSearchScreen()
            return
        }
    }
    
    func doGoVoiceSearchScreen() {
//        DispatchQueue.main.async {
//            let vc = VoiceRecordToTextViewController()
//            vc.modalPresentationStyle = .custom
//            vc.modalTransitionStyle = .crossDissolve
//            vc.delegate = self
//            self.navigationController?.present(vc, animated: true, completion: nil)
//        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fadedView.removeFromSuperview()
        voiceView.removeFromSuperview()
    }
    
    //MARK: --IBFunctions
    deinit {
        service.cancelAllRequests()
        self.removeObserver(self, forKeyPath: #keyPath(SearchViewController.searchKeyword))
    }
}

@available(iOS 10.0, *)
extension SearchViewController: SearchTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) {
        self.onSearch(textField.text!)
    }
}

@available(iOS 10.0, *)
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let keyword = searchBar.text ?? ""
        self.setValue(keyword, forKeyPath: #keyPath(SearchViewController.searchKeyword))
        if !keyword.isEmpty {
            self.tableView.isHidden = true
            self.historyTableView.isHidden = true
            self.refreshData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.setValue(searchText, forKeyPath: #keyPath(SearchViewController.searchKeyword))
            if searchServices.getSearchHistory().count > 0 {
                //self.tableView.reloadData()
                self.historyTableView.reloadData()
                self.tableView.isHidden = true
                self.historyTableView.isHidden = false
            } else {
                self.tableView.isHidden = true
            }
        } else if (searchText.count > 2) {
            self.requestSuggestionAPI()
        }
    }
}

@available(iOS 10.0, *)
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return viewModel.section.rows.count
        }else {
            return searchServices.getSearchHistory().count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let cell = SearchSuggestionTableViewCell.dequeueReuseCellWithNib(in: tableView, reuseIdentifier: SearchSuggestionTableViewCell.nibName())
            for i in searchServices.getSearchHistory() {
                if i.keySearch == searchBar.text {
                    if indexPath.row == 0 {
                        cell.bindingData(title: i.keySearch)
                    }
                }
            }
            
            cell.delegate = self
            cell.bindingWithModel(viewModel.section.rows[indexPath.row])
            return cell
        } else {
            let cell = HistorySearchTableViewCell.dequeueReuseCellWithNib(in: tableView, reuseIdentifier: HistorySearchTableViewCell.nibName())
            
            cell.delegate = self
            cell.bindingWithModelObject(searchServices.getSearchHistory()[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            self.onSearch(viewModel.section.rows[indexPath.row].title)
        } else {
            self.onSearch((searchServices.getSearchHistory()[indexPath.row].keySearch))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

@available(iOS 10.0, *)
extension SearchViewController: SearchSuggestionTableViewCellDelegate {
    func didSelectSearchRow(cell: SearchSuggestionTableViewCell, sender: Any) {
        if let path = tableView.indexPath(for: cell) {
            searchBar.text = viewModel.section.rows[path.row].title
            self.requestSuggestionAPI()
        }
    }
}

@available(iOS 10.0, *)
extension SearchViewController: HistorySearchTableViewCellDelegate {
    
    func didSelectRow(cell: HistorySearchTableViewCell, sender: Any) {
        if let path = historyTableView.indexPath(for: cell) {
            searchBar.text = searchServices.getSearchHistory()[path.row].keySearch
            self.requestSuggestionAPI()
        }
    }
    
    func didDeleteRow(cell: HistorySearchTableViewCell, sender: Any) {
        if let path = historyTableView.indexPath(for: cell) {
            let item = searchServices.getSearchHistory()[path.row]
            searchServices.deleteHistorySearch(item.keyID)
            self.historyTableView.reloadData()
        }
    }
}
