//
//  ManagerCommentViewController.swift
//  MeuClip
//
//  Created by mac on 21/10/2021.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit

class ManagerCommentViewController: BaseViewController,UITextViewDelegate {
   
   //MARK: - @IBOutlet
   @IBOutlet weak var chooseStatusBt: UIButton!
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var growingTextView: RSKGrowingTextView!
   @IBOutlet weak var commentView: UIView!
   @IBOutlet weak var bottomSpacing: NSLayoutConstraint!
   @IBOutlet weak var avatarUserImage: UIImageView!
   @IBOutlet weak var navigationView: UIView!
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var navBg: UIView!
   
   //MARK: - Properties
   var presenter: ManagerCommentControllerOutPut?
   var viewModel: ManagerCommentViewModelOutput?
   private var isVisibleKeyboard = true
   var approveCell = ApprovedCommentCell()
   var  transportData : (() -> Void)?
   // MARK: - LifeCycle
   override func viewDidLoad() {
      super.viewDidLoad()
      presenter?.viewDidLoad()
      self.setUpUI()
      
   }
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      presenter?.viewDidAppear(animated)
      tableView.reloadData()
   }
   
   override func dismissKeyboard() {
      super.dismissKeyboard()
      commentView.isHidden = true
   }
   
   //MARK: - SetUp UI
   private func setUpUI() {
      growingTextView.delegate = self
      self.view.backgroundColor = UIColor.setViewColor()
      self.navBg.backgroundColor = UIColor.setViewColor()
      self.titleLabel.text = String.manage_Comment
      self.titleLabel.textColor = UIColor.settitleColor()
      self.navigationView.backgroundColor = UIColor.setViewColor()
      self.growingTextView.backgroundColor = UIColor.setViewColor()
      if let image = UIImage(named: "iconDownGray"){
         self.chooseStatusBt.addRightIcon(image: image)
      }
      let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
      tap.cancelsTouchesInView = false
      self.tableView.addGestureRecognizer(tap)
      commentView.isHidden = true
      let str = String.viet_binh_luan
      let placehoder = str as NSString
      growingTextView.placeholder = placehoder
      commentView.backgroundColor = UIColor.setViewColor()
      self.tableView.delegate = self
      self.tableView.dataSource = self
      self.tableView.register(UINib(nibName: "ApprovedCommentCell", bundle: nil), forCellReuseIdentifier: "ApprovedCommentCell")
      self.tableView.register(UINib(nibName: "WaitAprroveCommentCell", bundle: nil), forCellReuseIdentifier: "WaitAprroveCommentCell")
      self.tableView.register(UINib(nibName: "RejectCommentCell", bundle: nil), forCellReuseIdentifier: "RejectCommentCell")
      self.tableView.register(UINib(nibName: "HeaderInforVideo", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderInforVideo")
      if let avatarImage = DataManager.getCurrentMemberModel()?.avatarImage {
         let url = URL(string: avatarImage)
         avatarUserImage.kf.setImage(with: url)
      }
      self.view.backgroundColor = UIColor.setViewColor()
      self.tableView.backgroundColor = UIColor.setViewColor()
   }
   func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
     //300 chars restriction
     return textView.text.count + (text.count - range.length) < 1000
 }
   //MARK: - IBAction
   
   @IBAction func onBack(_ sender: Any) {
      self.transportData?()
      presenter?.onBack(sender)
      
   }
   
   @IBAction func onChooseStatus(_ sender: Any) {
      self.presenter?.presentBottomSheet()
   }
   
   @IBAction func CommentAction(_ sender: Any) {
      presenter?.doUpDateComment(comment: growingTextView.text, index: (viewModel?.indexSelectedComment)!)
   }
   
}

//MARK: - UITableView Delegate and Datasource
extension ManagerCommentViewController : UITableViewDelegate,UITableViewDataSource {
   
   func numberOfSections(in tableView: UITableView) -> Int {
      
      return (viewModel?.listVideoComment.count)!
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return (viewModel?.listVideoComment[section].listComment.count)!
   }
   func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
      return 0.01
   }
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderInforVideo") as! HeaderInforVideo
      header.tapHeader = { [weak self] model in
         if let weakSelf = self {
            weakSelf.dismiss(animated: true, completion: nil)
            weakSelf.showVideoDetails(model)
         }
      }
      header.blindModel(model: (viewModel?.listVideoComment[section])!)
      return header
   }
   
   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 70
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
      if let viewModel =  self.viewModel {
         let model = viewModel.listVideoComment[indexPath.section].listComment[indexPath.row]
         switch viewModel.getCurrentStatus() {
         case .approvedComment:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ApprovedCommentCell", for: indexPath) as! ApprovedCommentCell
            cell.bindingWithModel(model)
            cell.selectionStyle = .none
            cell.commentActionIndex = { [weak self] cell in
               if let weakSelf = self {
                  weakSelf.viewModel?.indexSelectedComment = indexPath
                  weakSelf.presenter?.showComment()
                  weakSelf.approveCell  = cell
               }
            }
            cell.moreCommentActionIndex = {   [weak self] cell in
               if let weakSelf = self {
                  let vc = DisplayCommentViewController(index: indexPath, isAproved: true,listComment: weakSelf.viewModel!.listVideoComment)
                  vc.transportData = { [weak self] model in
                     if let weakSelf = self {
                        weakSelf.viewModel?.listVideoComment = model
                        weakSelf.tableView.reloadData()
                     }
                  }
                  vc.titleNavigation = String.All_comment
                  vc.commentID = self?.viewModel?.listVideoComment[indexPath.section].id ?? ""
                  vc.modalPresentationStyle = .fullScreen
                  weakSelf.present(vc, animated: true, completion: nil)
               }
            }
            cell.onLikeActionIndex = { [weak self] in
               if let weakSelf = self {
                  weakSelf.viewModel?.doUpdateWithToggleLikeComment(at: indexPath)
                  weakSelf.presenter?.sendLikeAndDislikeComment(isLike: true, index: indexPath)
                  weakSelf.tableView.reloadData()
               }
            }
            cell.dissLikeActionIndex = { [weak self] cell in
               if let weakSelf = self {
                  weakSelf.viewModel?.doUpdateWithToggleDisLikeComment(at: indexPath)
                  weakSelf.presenter?.sendLikeAndDislikeComment(isLike: false, index: indexPath)
                  weakSelf.tableView.reloadData()
               }
            }
            cell.rejectComment = { [weak self] in
               if let weakSelf = self {
                  weakSelf.presenter?.sendApproveComment(isApprove: false, index: indexPath)
               }
            }
            
            return cell
         case .rejectComment :
            let cell = tableView.dequeueReusableCell(withIdentifier: "RejectCommentCell", for: indexPath) as! RejectCommentCell
            cell.selectionStyle = .none
            cell.bindingWithModel(model)
            cell.onClickApproved = { [weak self] in
               if let weakSelf = self {
                  weakSelf.presenter?.sendApproveComment(isApprove: true, index: indexPath)
               }
               
            }
            return cell
         case .waitApprove :
            let cell = tableView.dequeueReusableCell(withIdentifier: "WaitAprroveCommentCell", for: indexPath) as! WaitAprroveCommentCell
            cell.bindingWithModel((self.viewModel?.listVideoComment[indexPath.section].listComment[indexPath.row])!)
            cell.selectionStyle = .none
            cell.moreSubComment = { [weak self] in
               if let weakSelf = self {
                  let vc = DisplayCommentViewController(index: indexPath, isAproved: false,listComment: weakSelf.viewModel!.listVideoComment)
                  vc.transportData = { [weak self] model in
                     if let weakSelf = self {
                        weakSelf.viewModel?.listVideoComment = model
                        weakSelf.tableView.reloadData()
                     }
                  }
                  vc.titleNavigation = String.All_comment
                  vc.modalPresentationStyle = .fullScreen
                  weakSelf.present(vc, animated: true, completion: nil)
               }
            }
            
            cell.approveComment = {[weak self]  in
               if let weakSelf = self{
                  weakSelf.presenter?.sendApproveComment(isApprove: true, index: indexPath)
               }
               
            }
            
            cell.rejectComment = { [weak self]  in
               if let weakSelf = self{
                  weakSelf.presenter?.sendApproveComment(isApprove: false, index: indexPath)
               }
            }
            
            return cell
         case .all:
            if model.status == CommentStatus.approvedComment.getId() {
               let cell = tableView.dequeueReusableCell(withIdentifier: "ApprovedCommentCell", for: indexPath) as! ApprovedCommentCell
               cell.bindingWithModel(model)
               cell.selectionStyle = .none
               cell.commentActionIndex = { [weak self] cell in
                  if let weakSelf = self {
                     self?.viewModel?.indexSelectedComment = indexPath
                     weakSelf.presenter?.showComment()
                     weakSelf.approveCell  = cell
                  }
                  
                  
               }
               cell.moreCommentActionIndex = {   [weak self] cell in
                  if let weakSelf = self {
                     let vc = DisplayCommentViewController(index: indexPath, isAproved: true,listComment: weakSelf.viewModel!.listVideoComment)
                     vc.transportData = { [weak self] model in
                        if let weakSelf = self {
                           weakSelf.viewModel?.listVideoComment = model
                           weakSelf.tableView.reloadData()
                        }
                     }
                     vc.titleNavigation = String.All_comment
                     vc.commentID = self?.viewModel?.listVideoComment[indexPath.section].id ?? ""
                     vc.modalPresentationStyle = .fullScreen
                     weakSelf.present(vc, animated: true, completion: nil)
                  }
               }
               
               cell.onLikeActionIndex = { [weak self] in
                  if let weakSelf = self {
                     weakSelf.viewModel?.doUpdateWithToggleLikeComment(at: indexPath)
                     weakSelf.presenter?.sendLikeAndDislikeComment(isLike: true, index: indexPath)
                     weakSelf.tableView.reloadData()
                  }
               }
               
               cell.dissLikeActionIndex = { [weak self] cell in
                  if let weakSelf = self {
                     weakSelf.viewModel?.doUpdateWithToggleDisLikeComment(at: indexPath)
                     weakSelf.presenter?.sendLikeAndDislikeComment(isLike: false, index: indexPath)
                     weakSelf.tableView.reloadData()
                  }
               }
               
               cell.rejectComment = { [weak self] in
                  if let weakSelf = self {
                     weakSelf.presenter?.sendApproveComment(isApprove: false, index: indexPath)
                  }
               }
               
               return cell
            }else if model.status == CommentStatus.waitApprove.getId(){
               let cell = tableView.dequeueReusableCell(withIdentifier: "WaitAprroveCommentCell", for: indexPath) as! WaitAprroveCommentCell
               cell.bindingWithModel((self.viewModel?.listVideoComment[indexPath.section].listComment[indexPath.row])!)
               cell.selectionStyle = .none
               cell.moreSubComment = { [weak self] in
                  if let weakSelf = self {
                     let vc = DisplayCommentViewController(index: indexPath, isAproved: false,listComment: weakSelf.viewModel!.listVideoComment)
                     vc.transportData = { [weak self] model in
                        if let weakSelf = self {
                           weakSelf.viewModel?.listVideoComment = model
                           weakSelf.tableView.reloadData()
                        }
                     }
                     vc.titleNavigation = String.All_comment
                     vc.modalPresentationStyle = .fullScreen
                     weakSelf.present(vc, animated: true, completion: nil)
                  }
               }
               
               cell.approveComment = {[weak self]  in
                  if let weakSelf = self{
                     weakSelf.presenter?.sendApproveComment(isApprove: true, index: indexPath)
                  }
                  
               }
               return cell
            }else{
               let cell = tableView.dequeueReusableCell(withIdentifier: "RejectCommentCell", for: indexPath) as! RejectCommentCell
               cell.selectionStyle = .none
               cell.bindingWithModel(model)
               cell.onClickApproved = { [weak self] in
                  if let weakSelf = self {
                     weakSelf.presenter?.sendApproveComment(isApprove: true, index: indexPath)
                  }
                  
               }
               return cell
            }
         }
      }else{
         return UITableViewCell()
      }
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return UITableView.automaticDimension
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: false)
   }
   
}
