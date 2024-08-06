//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: BaseViewController {
    var presenter: SearchViewControllerOutput?
    var viewModel: SearchViewModelOutput?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var SearchBgView: UIView!
    var fromVC: BaseViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        self.searchTextField.placeholder = String.vui_long_nhap_noi_dung_tim_kiem
        updateView()
        if #available(iOS 10.0, *) {
            voiceButton.isHidden = false
        } else {
            voiceButton.isHidden = true
        }
        logScreen(GoogleAnalyticKeys.search.rawValue)
      tableView.backgroundColor = UIColor.setViewColor()
      self.view.backgroundColor = UIColor.setViewColor()
        SearchBgView.backgroundColor = UIColor.setViewColor()
        addScrollToLoadMore()
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: String.searchPlaceHolder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func addScrollToLoadMore() {
        weak var wself = self
        tableView?.addInfiniteScrolling(actionHandler: {
            if wself?.viewModel?.searchType == .searchSuggest {
                wself?.presenter?.getNextSuggestPage()
            }else if wself?.viewModel?.searchType == .search {
                wself?.presenter?.getNextPage()
            }
        })
        tableView?.showsInfiniteScrolling = false
    }
    
    
    @IBAction func onClickBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickVoiceButton(_ sender: Any) {
        if #available(iOS 10.0, *) {
            NotificationCenter.default.post(name: .kShouldPausePlayer, object: nil)
            weak var searchVoiceVC = SearchVoiceViewController.initWithNib()
            searchVoiceVC?.delegate = self
            present(searchVoiceVC!, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func onClickCancelButton(_ sender: Any) {
        searchTextField.text = ""
        searchTextField.becomeFirstResponder()
        viewModel?.currentKeyword = ""
        presenter?.didSelectCancelButton()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
        self.navigationController?.isNavigationBarHidden = true
//        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        //UIApplication.shared.statusBarStyle = .lightContent
//        if let model = DataManager.getCurrentAccountSettingsModel() {
//            if(model.event == "20-10"){
//                UIApplication.shared.statusBarStyle = .default
//            }else if(model.event == "aff-cup"){
//                UIApplication.shared.statusBarStyle = .lightContent
//            }
//            else{
//                UIApplication.shared.statusBarStyle = .default
//            }
//        }else{
//            UIApplication.shared.statusBarStyle = .default
//        }
    }
    
    override func setupView() {
        self.navigationItem.title = viewModel?.getTitle()
        searchTextField.addTarget(self,
                            action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchTextField.becomeFirstResponder()
        automaticallyAdjustsScrollViewInsets = false
    }
    
    func reloadView() {
        var rowCount = 0
        for section in (viewModel?.data)! {
            for item in section.rows {
                tableView.register(UINib(nibName: item.identifier, bundle: nil),
                                   forCellReuseIdentifier: item.identifier)
                rowCount += 1
            }
        }
        for section in (viewModel?.data)! where section.header.identifier != nil {
            tableView.register(UINib(nibName: section.header.identifier!, bundle: nil),
                               forHeaderFooterViewReuseIdentifier: section.header.identifier!)
        }
        if (viewModel?.data.isEmpty)! {
            tableView.addNoDataLabel(String.noData)
        } else {
            tableView.removeNoDataLabel()
        }
        tableView.reloadData()
    }
    
    deinit {
        DLog("")
    }
}

extension SearchViewController: SearchViewControllerInput {
    func updateView() {
        reloadView()
        if (viewModel?.currentKeyword.isEmpty)! {
            if #available(iOS 10, *) {
                voiceButton.isHidden = false
            } else {
                voiceButton.isHidden = true
            }
            cancelButton.isHidden = true
        } else {
            voiceButton.isHidden = true
            cancelButton.isHidden = false
        }
    }
    
    func stopAnimating() {
        self.tableView.infiniteScrollingView.stopAnimating()
    }
    
    func showsInfiniteScrolling(enable: Bool) {
        self.tableView?.showsInfiniteScrolling = enable
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        if text.isEmpty {
            if #available(iOS 10, *) {
                voiceButton.isHidden = false
            } else {
                voiceButton.isHidden = true
            }
        } else {
            cancelButton.isHidden = false
            voiceButton.isHidden = true
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        presenter?.onTextChange(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == UIReturnKeyType.search {
            presenter?.onSearchClicked(textField)
            return true
        }
        return false
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return (viewModel?.data.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = viewModel?.data[section]
        return (section?.rows.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel?.data[indexPath.section].rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: (model?.identifier)!,
                                                 for: indexPath) as! BaseTableViewCell
        cell.bindingWithModel(model!)
        if let videoCell = cell as? VideoSmallImageTableViewCell {
            videoCell.delegate = self
        }
        if let cell = cell as? LoadMoreTableViewCell {
            cell.delegate = self
        }
        if let cell = cell as? SearchTableViewCell {
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderAt indexPath: IndexPath) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
        guard let model = viewModel else {
            return 0.01
        }
        let sectionModel = model.data[section]
        if sectionModel.header.identifier != nil {
            return UITableView.automaticDimension
        } else {
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let model = viewModel else {
            return nil
        }
        let sectionModel = model.data[section]
        if let identifier = sectionModel.header.identifier {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
                as! BaseTableHeaderView
            view.bindingWithModel(sectionModel.header, section: section)
            return view
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        presenter?.didSelectItem(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let _ = cell as? SearchTableViewCell {
            let model = viewModel?.listSearchHistory[indexPath.row]
            if let rowModel = model {
                if editingStyle == .delete{
//                    let dialog = DialogViewController(title: String.xoa_lich_su_tim_kiem,
//                                                      message: String.confirmClearHistorySearch,
//                                                      confirmTitle: String.dong_y,
//                                                      cancelTitle: String.huy_bo)
//                    dialog.confirmDialog = {(sender) in
//                        self.presenter?.onEditTableCell(rowModel)
//                        self.viewModel?.data[indexPath.section].rows.remove(at: indexPath.row)
//                        tableView.deleteRows(at: [indexPath], with: .none)
//                    }
//                    presentDialog(dialog, animated: true, completion: nil)
                    
                    showAlert(title: String.xoa_lich_su_tim_kiem, message: String.confirmClearHistorySearch, okTitle: String.okString, onOk: { (action) in
                        self.presenter?.onEditTableCell(rowModel)
                        self.viewModel?.data[indexPath.section].rows.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .none)
                    })
                }
            }
        } 
    }
}

extension SearchViewController: SearchTableViewCellDelegate {
    func searchTableViewCell(_ cell: SearchTableViewCell, didSelectFillButton sender: UIButton) {
        if let indexPath = tableView.indexPath(for: cell) {
            self.presenter?.didSelectFillButton(at: indexPath)
        }
    }
}

extension SearchViewController: VideoSmallTableViewCellDelegate {
    func videoSmallImageTableViewCell(_ cell: VideoSmallImageTableViewCell, didSelectActionButton sender: UIButton) {
        if let path = tableView.indexPath(for: cell) {
            self.view.endEditing(true)
            presenter?.onSelectActionButton(at: path)
        }
    }
}

extension SearchViewController: PassVoiceResultProtocol {
    func passVoiceResult(textField: UITextField) {
        presenter?.onSearchClicked(textField)
        self.searchTextField.text = textField.text
    }
}

extension SearchViewController: LoadMoreTableViewCellDelegate {
    func loadMoreTableViewCell(_ cell: LoadMoreTableViewCell, didSelectLoadMore sender: UIButton) {
        //presenter?.didSelectLoadMoreButton()
        if let indexPath = self.tableView.indexPath(for: cell) {
            presenter?.didSelectLoadMoreButton(section: indexPath.section)
        }
    }
}
