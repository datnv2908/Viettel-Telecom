
//
//  SelectChannelViewController.swift
//  MyClip
//
//  Created by Os on 8/30/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import RAReorderableLayout

class SelectChannelViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel = SelectChannelViewModel()
    let service = UserService()
    var completionBlock: CompletionBlock?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        getData()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onClickDismissButton(_ sender: Any) {
        
        if viewModel.checkChange > 0 {
//            let dialog = DialogViewController(title: String.notification,
//                                              message: String.saveConfirm,
//                                              confirmTitle: String.dong_y,
//                                              cancelTitle: String.huy)
//            dialog.confirmDialog = { button in
//                self.followMultiChannel()
//            }
//            dialog.cancelDialog = { button in
//                self.dismiss(animated: true, completion: nil)
//            }
//            present(dialog, animated: true, completion: nil)
            
            self.showAlert(title: String.notification, message: String.saveConfirm, okTitle: String.dong_y, onOk: { [weak self] _ in
                self?.followMultiChannel()
            })
        } else {
            self.dismiss(animated: true) {
                self.completionBlock?(CompletionBlockResult(isCancelled: true, isSuccess: false))
            }
        }
    }
    
    @IBAction func onClickSaveButton(_ sender: Any) {
        followMultiChannel()
    }
    
    override func setupView() {
        navigationItem.title = String.chon_noi_dung
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconEscape"), style: .plain, target: self, action: #selector(onClickDismissButton(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: String.luu, style: .plain, target: self, action: #selector(onClickSaveButton(_:)))
        navigationItem.rightBarButtonItem?.tintColor = AppColor.deepSkyBlue90()
        reloadData()
    }
    
    func reloadData() {
        for section in viewModel.data {
            for row in section.rows {
                collectionView.register(UINib(nibName: row.identifier, bundle: Bundle.main), forCellWithReuseIdentifier: row.identifier)
            }
            collectionView.register(UINib(nibName: section.header.identifier!, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: section.header.identifier!)
        }
        self.collectionView.reloadData()
    }
    
    func followMultiChannel() {
        var tmp = ""
        let followSection = viewModel.data[0]
        let ids = followSection.rows.map({$0.objectID})
        tmp = ids.joined(separator: ",")
        showHud()
        service.followMultiChannel(ids: tmp, status: 1, notificationType: 2) { (result) in
            self.hideHude()
            switch result {
            case .success(_):
                NotificationCenter.default.post(name: .kNotificationShouldReloadFollow, object: nil, userInfo: nil)
                self.dismiss(animated: true, completion: {
                    self.completionBlock?(CompletionBlockResult(isCancelled: false, isSuccess: true))
                })
            case .failure(let error):
                self.handleError(error as NSError, completion: { (result) in
                    if result.isSuccess {
                        self.followMultiChannel()
                    }
                })
            }
        }
    }
    
    func getData() {
        showHud()
        service.getFollowContent { (result) in
            switch result {
            case .success(let response):
                self.viewModel = SelectChannelViewModel(response.data)
                self.reloadData()
                break
            case .failure(let error):
                self.toast(error.localizedDescription)
                break
            }
            self.hideHude()
        }
    }
}

extension SelectChannelViewController: RAReorderableLayoutDelegate, RAReorderableLayoutDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data[section].rows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rowModel = viewModel.data[indexPath.section].rows[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (rowModel.identifier), for: indexPath) as! BaseCollectionViewCell
        cell.bindingWithModel(rowModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionModel = viewModel.data[indexPath.section]
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionModel.header.identifier!, for: indexPath) as! ChannelHeaderView
            reusableview.bindingWithModel(sectionModel.header.title)
            if indexPath.section == 0 {
                reusableview.descLabel.text = String.keo_tha_de_sap_xep_vi_tri_hien_thi_noi_dung
            } else {
                reusableview.descLabel.text = String.chon_noi_dung_yeu_thich_ben_duoi
            }
            return reusableview
        default:  fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var model = viewModel.data[indexPath.section].rows[indexPath.row] as! ChannelRowModel
        if model.isSelected {
            model.isSelected = false
            viewModel.data[0].rows.remove(at: indexPath.row)
            viewModel.data[1].rows.insert(model, at: 0)
        } else {
            model.isSelected = true
            viewModel.data[1].rows.remove(at: indexPath.row)
            viewModel.data[0].rows.insert(model, at: 0)
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, allowMoveAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return true
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, at: IndexPath, willMoveTo toIndexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, at atIndexPath: IndexPath, didMoveTo toIndexPath: IndexPath) {
        var channel: ChannelRowModel?
        if (atIndexPath as NSIndexPath).section == 0 {
            channel = viewModel.data[0].rows.remove(at: (atIndexPath as NSIndexPath).item) as? ChannelRowModel
        }
        
        if (toIndexPath as NSIndexPath).section == 0 {
            viewModel.data[0].rows.insert(channel!,
                                          at: (toIndexPath as NSIndexPath).item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, at: IndexPath, canMoveTo: IndexPath) -> Bool {
        if canMoveTo.section == 1 {
            return false
        }
        return true
    }
    
    func scrollTrigerEdgeInsetsInCollectionView(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsets(top: 100.0, left: 100.0, bottom: 100.0, right: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, reorderingItemAlphaInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else {
            return 0.3
        }
    }
    
    func scrollTrigerPaddingInCollectionView(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionView.contentInset.top, left: 0, bottom: collectionView.contentInset.bottom, right: 0)
    }
    
    //delegate flow layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: CGFloat(Constants.kDefaultMargin),
                            left: CGFloat(Constants.kDefaultMargin),
                            bottom: CGFloat(Constants.kDefaultMargin),
                            right: CGFloat(Constants.kDefaultMargin))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthItem = floor((Constants.screenWidth - 15.0*2.0 - 20.0*3.0)/4.0)
        // margin left,right:8 ; spacing title: 10, title: 16, 1/2 check icon : 8
        let heightItem = widthItem - 8.0*2.0 + 10.0 + 16.0 + 8.0
        return CGSize(width: widthItem, height: heightItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if section == 0 {
//            return CGSize(width: Constants.screenWidth, height: 60)
//        } else {
//            return CGSize(width: Constants.screenWidth, height: 70)
//        }
        return CGSize(width: Constants.screenWidth, height: 70)
    }
}
