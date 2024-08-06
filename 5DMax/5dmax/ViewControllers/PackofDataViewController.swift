//
//  PackofDataViewController.swift
//  5dmax
//
//  Created by admin on 8/15/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import MessageUI

protocol PackofDataViewControllerProtocol {
    func refreshView()
    func showSMSConfirm(message: String, number: String, smsContent: String)
}

class PackofDataViewController: BaseViewController, PackofDataViewControllerProtocol,MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnHoTro: UIButton!
    @IBOutlet weak var btnQuyenRiengTu: UIButton!
    @IBOutlet weak var btnDieuKhoan: UIButton!
    @IBOutlet weak var bannerView: UIImageView!
    @IBOutlet weak var bannerCenterConstraint: NSLayoutConstraint!
    
    var presenter: ListPricePresenter? = ListPricePresenter()
    var refreshControl: UIRefreshControl? = UIRefreshControl()
    var isBack: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewData()
        refreshView()
        presenter?.performGetListPrice()
        
        btnHoTro.setTitle(String.ho_tro, for: .normal)
        btnDieuKhoan.setTitle(String.dieu_khoan, for: .normal)
        btnQuyenRiengTu.setTitle(String.quyen_rieng_tu, for: .normal)
        
        bannerCenterConstraint.constant = Constants.appDelegate.hasTopNotch ? -16 : 0
        bannerView.image = UIImage(named: RTLocalizationSystem.rtGetLanguage() == "es" ? "suscripcion_Spanish" : "suscripcion_En")
        
        let setting = DataManager.getDefaultSetting()
        bannerView.isHidden = (setting?.isShowBannerSub ?? "0") == "0"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.viewWillAppear()
        logViewEvent(Constants.fire_base_package, Constants.fire_base_package_event)
    }
    
    //MARK : METHODS
    func setupViewData() {
        presenter?.view = self
        self.navigationController?.navigationBar.barTintColor = .black
        if self.navigationController?.viewControllers.count == 1 {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.menuBarItem(target: self, btnAction: #selector(menuButtonAction(_:)))
        }
        self.navigationItem.title = presenter?.viewModel?.title
        collectionView.register(UINib.init(nibName: PackofDataCollectionViewCell.nibName(), bundle: nil), forCellWithReuseIdentifier: PackofDataCollectionViewCell.nibName())
        refreshControl?.addTarget(presenter, action: #selector(presenter?.performGetListPrice), for: .valueChanged)
        refreshControl?.tintColor = .black
        collectionView.addSubview(refreshControl!)
    }

    func registerPackofData(_ index: Int) {
        if let userModel = DataManager.getCurrentMemberModel() {
            if userModel.msisdn.isEmpty {
                AuthorizeLinkAccountViewController.performLinkPhoneNumber(fromViewController: self)
            } else {
                if let list = presenter?.viewModel?.listPackage, list.indices.contains(index) {
                    let package = list[index]
//                    if package.popUp.count > 0 {
                        showConfirmPopup(package, at: 0)
//                    }
                }
            }
        } else {
            LoginViewController.performLogin(fromViewController: self)
        }
    }
    
    private func showConfirmPopup(_ package: PackageModel, at index: Int) {
        if package.status {
            self.presenter?.performRegisterPackage(package, isConfirmSMS: false)
            return
        }
        
        if((presenter?.viewModel?.isRegisterFast)!) {
            self.presenter?.performRegisterPackage(package, isConfirmSMS: (presenter?.viewModel?.isConfirmSMS)!)
        } else {
            if ((presenter?.viewModel?.isConfirmSMS)!) {
                if (package.popUp.count < 1) {
                    self.presenter?.performRegisterPackage(package, isConfirmSMS: (presenter?.viewModel?.isConfirmSMS)!)
                } else {
                    let title = package.status == true ? String.unregisterSubTitle : String.registerSubTitle
                    let message = package.popUp[index]
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: String.mua, style: .default) { (_) in
                        self.presenter?.performRegisterPackage(package, isConfirmSMS: (self.presenter?.viewModel?.isConfirmSMS)!)
                    }
                    let cancelAction = UIAlertAction(title: String.cancel, style: .cancel, handler: nil)
                    alertController.addAction(okAction)
                    alertController.addAction(cancelAction)
                    present(alertController, animated: true, completion: nil)
                }
            } else {
                let title = package.status == true ? String.unregisterSubTitle : String.registerSubTitle
                if index >= package.popUp.count {
                    self.presenter?.performRegisterPackage(package, isConfirmSMS: (presenter?.viewModel?.isConfirmSMS)!)
                    return
                }
                let message = package.popUp[index]
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: (index + 1) >= package.popUp.count ? String.dong_y : String.mua, style: .default) { (_) in
                    let nextIndex = index + 1
                    self.showConfirmPopup(package, at: nextIndex)
                }
                let cancelAction = UIAlertAction(title: String.cancel, style: .cancel, handler: nil)
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                present(alertController, animated: true, completion: nil)
            }
        }
        
//        if(presenter?.viewModel?.isConfirmSMS == false){
//            let title = package.status == true ? String.unregisterSubTitle : String.registerSubTitle
//            if index >= package.popUp.count {
//                self.presenter?.performRegisterPackage(package)
//                return
//            }
//            let message = package.popUp[index]
//            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            let okAction = UIAlertAction(title: String.okString, style: .default) { (_) in
//                let nextIndex = index + 1
//                self.showConfirmPopup(package, at: nextIndex)
//            }
//            let cancelAction = UIAlertAction(title: String.ignore, style: .cancel, handler: nil)
//            alertController.addAction(okAction)
//            alertController.addAction(cancelAction)
//            present(alertController, animated: true, completion: nil)
//        } else {
//            self.presenter?.performRegisterPackage(package)
//        }
    }
    
    //MARK: PROTOCOL
    func refreshView() {
        self.collectionView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    func showSMSConfirm(message: String, number: String, smsContent: String) {
        let fromViewController = ListPricePopupViewController.init(title: String.register, message: String.cancel)
        fromViewController.view.backgroundColor = .clear
        fromViewController.desLabel.attributedText = message.convertHtml()
        fromViewController.desLabel.textColor = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
        fromViewController.desLabel.font = AppFont.museoSanFont(style: .regular, size: 15.0)
        fromViewController.confirmDialog = {(_) in
            if MFMessageComposeViewController.canSendText() == true {
                let recipients:[String] = [number]
                let messageController = MFMessageComposeViewController()
                messageController.messageComposeDelegate  = self
                messageController.recipients = recipients
                messageController.body = smsContent
                
                DispatchQueue.main.async {
                    self.present(messageController, animated: true, completion: nil)
                }
            } else {
                self.toast(String.thiet_bi_khong_ho_tro_nhan_tin)
            }
        }
        self.present(fromViewController, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: IBFUNCTION
    @IBAction func btnRulesPressed(_ sender: Any) {
        let setting = DataManager.getDefaultSetting()
        let htmlContent = setting?.getHTMLWithType(contenType: .termCondition)
        let viewController = ViewHTMLViewController.initWithHTML(html: htmlContent, title: String.dieu_khoan)
        viewController.isBack = isBack
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnSecurityPressed(_ sender: Any) {
        let setting = DataManager.getDefaultSetting()
        let htmlContent = setting?.getHTMLWithType(contenType: .privacy)
        let viewController = ViewHTMLViewController.initWithHTML(html: htmlContent, title: String.quyen_rieng_tu)
        viewController.isBack = isBack
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnHelpPressed(_ sender: Any) {
        let setting = DataManager.getDefaultSetting()
        let htmlContent = setting?.getHTMLWithType(contenType: .contact)
        let viewController = ViewHTMLViewController.initWithHTML(html: htmlContent, title: String.ho_tro)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PackofDataViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let model = presenter?.viewModel {
            pageControl.numberOfPages = model.getNumberRowInSection(section)
            return model.getNumberRowInSection(section)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PackofDataCollectionViewCell.nibName(), for: indexPath) as! PackofDataCollectionViewCell
        if let model = presenter?.viewModel?.getPackageAtIndexPath(indexPath) {
            cell.bindingWithData(model: model)
        }
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.performSelectAtIndexPath(indexPath)
        refreshView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 60, height: collectionView.bounds.height - 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        pageControl?.currentPage = Int(roundedIndex)
    }
}

extension PackofDataViewController: PackofDataCollectionViewCellDelegate {
    func didRegisterPrice(cell: PackofDataCollectionViewCell, sender: UIButton) {
        if let indexPath = self.collectionView.indexPath(for: cell) {
            self.registerPackofData(indexPath.row)
        }
    }
}
