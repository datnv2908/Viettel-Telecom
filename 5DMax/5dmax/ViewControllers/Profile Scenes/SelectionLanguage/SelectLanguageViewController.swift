//
//  SelectLanguageViewController.swift
//  5dmax
//
//  Created by Đào Văn Nghiên on 3/4/19.
//  Copyright © 2019 Huy Nguyen. All rights reserved.
//

import UIKit

class SelectLanguageViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var currentLanguage: String = ""
    let mAppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpView() {
        self.navigationItem.title = String.chon_ngon_ngu
        self.navigationItem.leftBarButtonItem =
            UIBarButtonItem.menuBarItem(target: self,
                                        btnAction: #selector(menuButtonAction(_:)))
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
        view.backgroundColor = AppColor.grayBackgroundColor()
    }
    
    func setUpData() {
//        let lang_arr = DataManager.objectForKey("AppleLanguages") as! NSArray
//        currentLanguage = lang_arr[0] as! String
        currentLanguage = RTLocalizationSystem.rtGetLanguage()
    }
}

extension SelectLanguageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .white
        cell.textLabel?.textColor = AppColor.untCharcoalGrey()
        cell.textLabel?.font = AppFont.museoSanFont(style: .regular, size: 17)
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        var lang = String.tieng_viet
        var shortLang = "vi"
        
        switch indexPath.row {
        case 0:
            lang = String.tieng_tay_ban_nha
            shortLang = "es"
        case 1:
            lang = String.tieng_anh
            shortLang = "en"
        default:
            lang = String.tieng_viet
            shortLang = "vi"
        }
        
        cell.textLabel?.text = lang
        
        if indexPath.row == 2 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10000)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        }
        
        if shortLang == currentLanguage {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var lang = String.tieng_viet
        var shortLang = "vi"
        
        switch indexPath.row {
        case 0:
            lang = String.tieng_tay_ban_nha
            shortLang = "es"
        case 1:
            lang = String.tieng_anh
            shortLang = "en"
        default:
            lang = String.tieng_viet
            shortLang = "vi"
        }
        
        if shortLang == currentLanguage {
            return
        }
        
        let alertController = UIAlertController(title: String.thong_bao, message: String(format: String.yeu_cau_khoi_dong_lai_app, lang), preferredStyle: .alert)
        let okAction = UIAlertAction(title: String.dong_y, style: .default) { (_) in
            DataManager.save(object: [shortLang], forKey: "AppleLanguages")
            RTLocalizationSystem.rtSetLanguage(shortLang)
            self.mAppDelegate.exitApp()
        }
        let cancelAction = UIAlertAction(title: String.huy_bo, style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
}
