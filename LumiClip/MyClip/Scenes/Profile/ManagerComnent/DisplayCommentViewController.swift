//
//  DisplayCommentViewController.swift
//  MeuClip
//
//  Created by mac on 24/10/2021.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit

protocol DisplayCommentViewControllerDelegate: AnyObject {
   func displayCommentViewController(_ viewController: DisplayCommentViewController, didSelectLikeComment sender: UIButton, at indexPath: IndexPath)
}

class DisplayCommentViewController: BaseViewController ,UITextViewDelegate{
   
   //MARK:  - IBOutlet
   @IBOutlet weak var backBtn: UIButton!
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var titleNav: UILabel!
   @IBOutlet weak var growingTextView: RSKGrowingTextView!
   @IBOutlet weak var commentView: UIView!
   @IBOutlet weak var bottomSpacing: NSLayoutConstraint!
   @IBOutlet weak var avatarUserImage: UIImageView!
    @IBOutlet weak var navView: UIView!
    
   //MARK: - Properties
   private var isVisibleKeyboard = true
   let service = VideoServices()
   let commentService = CommentServices()
   var commentID = ""
   var isAproved : Bool = false
   var transportData : (([CommentModelDisplay]) -> Void)?
   var viewModel = ManagerCommentViewModel()
   var titleNavigation = ""
   //MARK: - LifeCycle
   override func viewDidLoad() {
      super.viewDidLoad()
      self.setupUI ()
   }
   init(index : IndexPath, isAproved : Bool , listComment : [CommentModelDisplay]) {
      super.init(nibName: "DisplayCommentViewController", bundle: nil)
      self.isAproved = isAproved
      viewModel.doUpdateWithChildComment(index: index, isAproved: isAproved,listComment: listComment)
      
   }
   
   required init(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   // MARK: -SetUpUI
   func setupUI (){
      self.navView.backgroundColor = UIColor.setViewColor()
      self.tableView.backgroundColor = UIColor.setViewColor()
      self.growingTextView.backgroundColor = UIColor.settitleColor()
      let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
      tap.cancelsTouchesInView = false
      self.tableView.addGestureRecognizer(tap)
      commentView.isHidden = true
      self.titleNav.text = titleNavigation
      growingTextView.delegate = self
      tableView.delegate = self
      tableView.dataSource = self
      tableView.register(UINib(nibName: ApprovedSubCommentCell.nibName(), bundle: nil), forCellReuseIdentifier: ApprovedSubCommentCell.nibName())
      tableView.register(UINib(nibName: RootCommentTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: RootCommentTableViewCell.nibName())
      tableView.register(UINib(nibName: WaitAprroveCommentCell.nibName(), bundle: nil), forCellReuseIdentifier: WaitAprroveCommentCell.nibName())
      tableView.register(UINib(nibName: RootCommentForWatingCell.nibName(), bundle: nil), forCellReuseIdentifier: RootCommentForWatingCell.nibName())
      tableView.register(UINib(nibName: RejectCommentCell.nibName(), bundle: nil), forCellReuseIdentifier: RejectCommentCell.nibName())
      if let avatarImage = DataManager.getCurrentMemberModel()?.avatarImage {
         let url = URL(string: avatarImage)
         avatarUserImage.kf.setImage(with: url)
      }
      tableView.tableFooterView = UIView()
      commentView.backgroundColor = UIColor.setViewColor()
      growingTextView.backgroundColor = UIColor.setViewColor()
      let str = String.viet_binh_luan
      let placehoder = str as NSString
      growingTextView.placeholder = placehoder
   }
   func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
     //300 chars restriction
     return textView.text.count + (text.count - range.length) < 1000
 }
   
   override func viewDidAppear(_ animated: Bool) {
      self.registerForKeyboardNotifications()
   }
   
   //MARK: - Setup CommentVIew
   private func registerForKeyboardNotifications() {
      weak var wself = self
      self.rsk_subscribeKeyboardWith(beforeWillShowOrHideAnimation: nil,
                                     willShowOrHideAnimation: { (keyboardRectEnd, duration, isShowing) -> Void in
                                        wself?.isVisibleKeyboard = isShowing
                                        wself?.adjustContent(for: keyboardRectEnd)
                                     }, onComplete: { (finished, isShown) -> Void in
                                       self.isVisibleKeyboard = isShown
                                       if (self.isVisibleKeyboard) {
                                          if (self.viewModel.isShowCommentView) == true {
                                             self.commentView.isHidden = false
                                          }
                                       } else {
                                          self.viewModel.isShowCommentView = false
                                          self.commentView.isHidden = true
                                          self.growingTextView.resignFirstResponder()
                                       }
                                     })
      
      self.rsk_subscribeKeyboard(willChangeFrameAnimation: { [unowned self] (keyboardRectEnd, duration) -> Void in
         self.adjustContent(for: keyboardRectEnd)
      }, onComplete: nil)
   }
   
   private func adjustContent(for keyboardRect: CGRect) {
      let keyboardHeight = keyboardRect.height
      // fix bug keyboard
      let offset: CGFloat = Constants.hasSafeArea ? 35 : 0
      
      let keyboardYPosition = self.isVisibleKeyboard ? keyboardHeight - offset : 0.0;
      self.bottomSpacing.constant = keyboardYPosition
      self.view.layoutIfNeeded()
   }
   
   override func dismissKeyboard() {
      super.dismissKeyboard()
      commentView.isHidden = true
   }
   
   func doUpDateComment( comment: String ) {
      if let user = DataManager.getCurrentMemberModel() {
         if let selectIndex = viewModel.indexSelectedComment {
            let parentID = viewModel.listVideoComment[selectIndex.section].listComment[selectIndex.row]
            commentService.getPostComment(contentId: self.commentID, comment: comment, parent_id: parentID.id) { [weak self] result in
               switch result {
               case .success (let respond):
                  let childComment = respond.data
                  self?.viewModel.doUpdateSubComment(index: selectIndex, model: childComment)
                  self?.tableView.reloadData()
                  self?.transportData?((self?.viewModel.listVideoComment)!)
               case .failure:
                  print("err")
               }
            }
         }
      }
   }
   
   func sendApproveComment(isApprove: Bool , index: IndexPath){
      let model = viewModel.listchildComment[index.row - 1]
      commentService.sendApproveComment(isApprove: isApprove, id: model.id ) { [weak self] result  in
         if let weakSelf = self {
            switch result {
            case .success:
               weakSelf.viewModel.removeSubComment(index: index ,isAprove: isApprove)
               weakSelf.transportData?(weakSelf.viewModel.listVideoComment)
               weakSelf.tableView.reloadData()
            case.failure(let err ):
               self?.toast(err.localizedDescription)
            }
            
         }
      }
   }
   
   func sendLikeAndDislikeComment(isLike: Bool, idVideo : String , model: CommentDisPlay) {
      commentService.likeAnDislikeComment(isLike: isLike, idComment: model.id, idVideo: (idVideo), completion: { [weak self] result in
         if let weakSelf = self {
            switch result {
            case .success(let content):
               self?.toast(content.message)
            case.failure(let err ):
               weakSelf.view?.toast(err.localizedDescription)
            }
         }
      }
      )
   }
   
   @IBAction func onBack(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
   }
   @IBAction func onClickSendComment(_ sender: Any) {
      self.doUpDateComment( comment: growingTextView.text)
      growingTextView.text = ""
      growingTextView.resignFirstResponder()
   }
   
}

//MARK: - UITableViewDelegate
extension DisplayCommentViewController : UITableViewDelegate , UITableViewDataSource {
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  viewModel.data.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let model = viewModel.data[indexPath.row] as! CommentInfoRowModel
      let cell = tableView.dequeueReusableCell(withIdentifier: model.identifier, for: indexPath) as! BaseTableViewCell
      cell.bindingWithModel(model)
      if let cell = cell as? ApprovedSubCommentCell {
         cell.rejectComment = { [weak self]  in
            if let weakSelf = self{
               weakSelf.sendApproveComment(isApprove: false, index: indexPath)
            }
         }
         cell.likeComment = { [weak self]  in
            if let weakSelf = self{
               weakSelf.viewModel.doUpdateWithToggleLikeSubComment(at: indexPath)
               if let indexSelection = weakSelf.viewModel.indexSelectedComment {
                  let model =   weakSelf.viewModel.listVideoComment[indexSelection.section].listComment[indexSelection.row].childcomment[indexPath.row - 1]
                  weakSelf.sendLikeAndDislikeComment(isLike: true ,idVideo: weakSelf.viewModel.listVideoComment[indexSelection.section].id,model: model)
                  weakSelf.tableView.reloadData()
               }
               tableView.reloadData()
            }
         }
         cell.disLikeComment = { [weak self]  in
            if let weakSelf = self{
               weakSelf.viewModel.doUpdateWithToggleDisLikeSubComment(at: indexPath)
               if let indexSelection = weakSelf.viewModel.indexSelectedComment {
                  let model =   weakSelf.viewModel.listVideoComment[indexSelection.section].listComment[indexSelection.row].childcomment[indexPath.row - 1]
                  weakSelf.sendLikeAndDislikeComment(isLike: false ,idVideo: weakSelf.viewModel.listVideoComment[indexSelection.section].id,model: model)
                  weakSelf.tableView.reloadData()
               }

            }
            }
      }
      if let cell = cell as? RejectCommentCell {
         cell.onClickApproved = {
            self.sendApproveComment(isApprove: true, index: indexPath)
         }
      }
      if let cell = cell as? RootCommentTableViewCell {
         cell.commentButton.isHidden = true
         cell.delegate = self
      }
      
      if let cell = cell as? WaitAprroveCommentCell {
         cell.dateLb.text = model.postedAt
         cell.approveComment = {[weak self]  in
            if let weakSelf = self{
               weakSelf.sendApproveComment(isApprove: true, index: indexPath)
            }
         }
         
         cell.rejectComment = { [weak self]  in
            if let weakSelf = self{
               weakSelf.sendApproveComment(isApprove: false, index: indexPath)
            }
         }
      }
      
      if let cell = cell as? RootCommentForWatingCell {
      }
      return cell
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return UITableView.automaticDimension
   }
}
//
////MARK:  - CommentInfoTableViewCellDelegate
//extension DisplayCommentViewController: CommentInfoTableViewCellDelegate {
//
//   func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell, didClickLike sender: UIButton) {
//      if let indexCell = tableView.indexPath(for: cell) {
//         viewModel.doUpdateWithToggleLikeSubComment(at: indexCell)
//         if let indexSelection = viewModel.indexSelectedComment {
//            let model =   viewModel.listVideoComment[indexSelection.section].listComment[indexSelection.row].childcomment[indexCell.row - 1]
//            self.sendLikeAndDislikeComment(isLike: true ,idVideo: viewModel.listVideoComment[indexSelection.section].id,model: model)
//            self.tableView.reloadData()
//         }
//         tableView.reloadData()
//
//
//      }
//   }
//   func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell, onSelectRejectComment sender: UIButton) {
//
//   }
//   func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell, didClickComment sender: UIButton) {
//
//   }
//
//   func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell, didSelectEdit sender: UIButton) {
//
//   }
//
//   func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell, onSelectShowSubComment sender: UIButton) {
//
//   }
//
//   func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell, didClickDisLike sender: UIButton) {
//      if let indexCell = tableView.indexPath(for: cell) {
//         viewModel.doUpdateWithToggleDisLikeSubComment(at: indexCell)
//         if let indexSelection = viewModel.indexSelectedComment {
//            let model =   viewModel.listVideoComment[indexSelection.section].listComment[indexSelection.row].childcomment[indexCell.row - 1]
//            self.sendLikeAndDislikeComment(isLike: false ,idVideo: viewModel.listVideoComment[indexSelection.section].id,model: model)
//            self.tableView.reloadData()
//         }
//
//      }
//   }
//}

//MARK: - RootCommentTableViewCellDelegate
extension DisplayCommentViewController: RootCommentTableViewCellDelegate {
   
   func rootCommentTableViewCell(_ cell: RootCommentTableViewCell, didSelectShowComment sender: UIButton) {
      self.viewModel.isShowCommentView = true
      growingTextView.becomeFirstResponder()
   }
   
   func rootCommentTableViewCell(_ cell: RootCommentTableViewCell, didSelectLikeButton sender: UIButton) {
      
      if let indexPath = viewModel.indexSelectedComment {
         viewModel.doUpdateWithToggleLikeHeaderSubComment(at: IndexPath(item: 0, section: 0))
         let model = viewModel.listVideoComment[indexPath.section].listComment[indexPath.row]
         self.sendLikeAndDislikeComment(isLike: true ,idVideo: viewModel.listVideoComment[indexPath.section].id,model: model)
         tableView.reloadData()
      }
   }
   func rootCommentTableViewCell(_ cell: RootCommentTableViewCell, didSelectDisLikeButton sender: UIButton) {
      if let indexPath = viewModel.indexSelectedComment {
         viewModel.doUpdateWithToggleDisLikeHeaderSubComment(at: IndexPath(item: 0, section: 0))
         let model = viewModel.listVideoComment[indexPath.section].listComment[indexPath.row]
         self.sendLikeAndDislikeComment(isLike: false ,idVideo: viewModel.listVideoComment[indexPath.section].id,model: model)
         tableView.reloadData()
      }
   }
   
   func rootCommentTableViewCell(_ cell: RootCommentTableViewCell, didSelectCommentButton sender: UIButton) {
      
   }
}
