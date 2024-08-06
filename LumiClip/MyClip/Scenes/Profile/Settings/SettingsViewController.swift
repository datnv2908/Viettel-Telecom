//
//  TableViewController.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/8/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var qualityLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var onlyPlayHDOnWifi: UISwitch!
    
    @IBOutlet weak var settingQualityLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var reviewAppLabel: UILabel!
    @IBOutlet weak var notifyLabel: UILabel!
    @IBOutlet weak var historyFindLabel: UILabel!
    @IBOutlet weak var historyViewLabel: UILabel!
    @IBOutlet weak var onlyWifiLabel: UILabel!
   @IBOutlet weak var swichStatusbar: UISwitch!
    @IBOutlet var cellTableView: [UITableViewCell]!
    @IBOutlet weak var darkLb: UILabel!
    @IBOutlet var arrLineView: [UIView]!
    @IBOutlet weak var typeBg: UIView!
    
    @IBOutlet var tableSettingView: UITableView!
    
    var viewModel = SettingsViewModel()
    let service = AppService()
    let interactor = SearchInteractor()
    let videoService = VideoServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.title
        settingQualityLabel.textColor = UIColor.settitleColor()
        typeBg.backgroundColor = UIColor.setViewColor()
        versionLabel.textColor = UIColor.settitleColor()
        reviewAppLabel.textColor = UIColor.settitleColor()
        notifyLabel.textColor = UIColor.settitleColor()
        historyFindLabel.textColor = UIColor.settitleColor()
        historyViewLabel.textColor = UIColor.settitleColor()
        onlyWifiLabel.textColor = UIColor.settitleColor()
        darkLb.textColor = UIColor.settitleColor()
        tableSettingView.backgroundColor = UIColor.setViewColor()
        settingQualityLabel.text = String.cai_dat_chat_luong_video;
        versionLabel.text = String.phien_ban_ung_dung;
        darkLb.text = String.darkMode
        reviewAppLabel.text = String.danh_gia_ung_dung;
        notifyLabel.text = String.cai_dat_thong_bao;
        historyFindLabel.text = String.xoa_lich_su_tim_kiem;
        historyViewLabel.text = String.xoa_lich_su_xem;
        onlyWifiLabel.text = String.chi_phat_hd_tren_wifi;
        for item in arrLineView {
            item.backgroundColor = UIColor.setViewColor()
        }
        for item in cellTableView {
            item.backgroundColor = UIColor.setViewColor()
        }
        qualityLabel.text = viewModel.defaultQuality
      appVersionLabel.text = viewModel.appVersion
      notificationSwitch.isOn = viewModel.isNotification
      onlyPlayHDOnWifi.isOn = UserDefaults.standard.bool(forKey: Constants.kDefaultOnlyPlayHD)
      let style =  DataManager.getStatusbarVaule()
         if style {
            swichStatusbar.isOn = false
         }else{
            swichStatusbar.isOn = true
            
         }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(qualityLabel.text ?? "", forKey: Constants.kDefaultQuality)
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func onDefaultQualityButton(_ sender: UIButton) {
        let actionController = ActionSheetViewController()
        actionController.addSection(Section())
        let qualities = ["360p", "480p", "720p", String.auto]
        let selectedQuality: String = UserDefaults.standard.object(forKey: "Constants.kDefaultQuality") as? String ?? String.auto
        for item in qualities {
            let actionData = selectedQuality == item ? ActionData(title: item, image: #imageLiteral(resourceName: "tick")) : ActionData(title: item)
            let action = Action(actionData, style: .default, handler: { (_) in
                self.qualityLabel.text = item
                UserDefaults.standard.set(item, forKey: Constants.kDefaultQuality)
                UserDefaults.standard.synchronize()
            })
            actionController.addAction(action)
        }
        present(actionController, animated: true, completion: nil)
    }
    
    @IBAction func toggleNotificationSettings(_ sender: Any) {
        if DataManager.isLoggedIn() {
            showHud()
            service.getSettingsNotification({ (result) in
                switch result {
                case .success(let response):
                    self.toast(response.message)
                case .failure(let error):
                    self.toast(error.localizedDescription)
                }
                self.hideHude()
            })
        } else {
            presentLoginController()
        }
    }
    
    @IBAction func toggleDarkMode(_ sender: UISwitch) {
      if #available(iOS 13.0, *) {
         
           let appDelegate = UIApplication.shared.windows.first
               if sender.isOn {
                  appDelegate?.overrideUserInterfaceStyle = .dark
                  DataManager.saveStatusBarStyle(styleBarStatus: UIStatusBarStyle.lightContent.rawValue)
                  self.sentTheme(isLight: true)
                  if let model = DataManager.getCurrentMemberModel() {
                     model.themeUser = 1
                     DataManager.saveMemberModel(model)
                  }
                  UIApplication.shared.statusBarStyle =  .lightContent
                  DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                     self.navigationController?.popViewController(animated: true)
                  }
                    return
               }
         DataManager.saveStatusBarStyle(styleBarStatus: UIStatusBarStyle.darkContent.rawValue)
         if let model = DataManager.getCurrentMemberModel() {
            model.themeUser = 0
            DataManager.saveMemberModel(model)
            
         }
         self.sentTheme(isLight: false)
         UIApplication.shared.statusBarStyle =  .darkContent
           appDelegate?.overrideUserInterfaceStyle = .light
         DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.navigationController?.popViewController(animated: true)
         }
         return
      }
     
      }
   func sentTheme(isLight : Bool) {
      service.sentThemeForApp(isLight: isLight) { (result) in
         switch result {
         case .success(let json) :
            
         break
         case .failure(let err) :
            
         break
         }
      }
   }
    @IBAction func toggleOnlyPlayHDOnWifi(_ sender: Any) {
        UserDefaults.standard.set(onlyPlayHDOnWifi.isOn, forKey: Constants.kDefaultOnlyPlayHD)
        UserDefaults.standard.synchronize()
    }
    
    func presentLoginController() {
        let viewController = LoginConfigurator.viewController()
        let nav = BaseNavigationController(rootViewController: viewController)
        nav.modalPresentationStyle = .overCurrentContext
        present(nav, animated: true, completion: nil)
    }
}
extension SettingsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 2 {
//            guard let url = URL(string: Constants.kRatingUrl) else {return}
//            UIApplication.shared.openURL(url)
        }
        
        if indexPath.row == 4 {
            deleteSearchHistory()
        }
        
        if indexPath.row == 5 {
            deleteWatchedVideos()
        }
    }
    
    func deleteSearchHistory() { // delete all search history
//        let dialog = DialogViewController(title: String.xoa_lich_su_tim_kiem,
//                                          message: String.confirmClearAllHistorySearch,
//                                          confirmTitle: String.dong_y,
//                                          cancelTitle: String.cancelPackage)
//        dialog.confirmDialog = {(sender) in
//            self.interactor.deleteAllHistorySearch()
//            self.toast(String.thanh_cong)
//        }
//        presentDialog(dialog, animated: true, completion: nil)
        
        self.showAlert(title: String.xoa_lich_su_tim_kiem, message: String.confirmClearAllHistorySearch, okTitle: String.dong_y, onOk: { _ in
            self.interactor.deleteAllHistorySearch()
            self.toast(String.thanh_cong)
        }, cancelTitle: String.cancelPackage)
    }
    
    func deleteWatchedVideos() { // delete all watched videos
//        let dialog = DialogViewController(title: String.xoa_lich_su_xem,
//                                          message: String.confirmClearHistory,
//                                          confirmTitle: String.dong_y,
//                                          cancelTitle: String.huy)
//
//        dialog.confirmDialog = {(sender) in
//            self.videoService.clearVideoHistory(ids: "all", completion: { (result) in
//                switch result {
//                case .success(let message):
//                    if let value = message as? String {
//                        self.toast(value)
//                    }
//                case .failure(let error):
//                    self.toast(error.localizedDescription)
//                }
//            })
//        }
//
//        presentDialog(dialog, animated: true, completion: nil)
        
        self.showAlert(title: String.xoa_lich_su_xem, message: String.confirmClearHistory, okTitle: String.dong_y, onOk: { _ in
            self.videoService.clearVideoHistory(ids: "all", completion: { (result) in
                switch result {
                case .success(let message):
                    if let value = message as? String {
                        self.toast(value)
                    }
                case .failure(let error):
                    self.toast(error.localizedDescription)
                }
            })
        })
    }
}
