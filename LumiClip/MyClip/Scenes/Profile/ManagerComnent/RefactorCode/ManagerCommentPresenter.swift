//
//  ManagerCommentPresenter.swift
//  MeuClip
//
//  Created by Toannx on 19/11/2021.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit

class ManagerCommentPresenter: NSObject {
   weak var view : ManagerCommentViewController?
   var viewModel : ManagerCommentViewModelOutput?
   var interactor : ManagerCommentControllerInput?
   var wireFrame : ManagerCommentWireFrameInput?
   let service : CommentServices? = nil
   var isVisibleKeyboard = true
   
   
}

// MARK: - View

extension ManagerCommentPresenter : ManagerCommentControllerOutPut {
   
   func viewDidLoad() {
      self.setUpNavigation(titleButton: (self.viewModel?.setUpStatus(index: self.viewModel!.currentIndexStatus).getTitle())!)
      if view?.viewModel?.listVideoComment.count == 0 {
         self.view?.tableView.backgroundView =  self.view?.emptyView()
      }
      
   }
   func viewDidAppear(_ animated: Bool) {
      self.registerForKeyboardNotifications()
   }
   
   func setUpNavigation(titleButton: String) {
      self.view?.chooseStatusBt.setTitle(titleButton, for: .normal)
      self.view?.view.layoutIfNeeded()
   }
   func sendApproveComment(isApprove: Bool, index: IndexPath) {
      if (self.view?.viewModel!.listVideoComment.indices.contains(index.section))! && ((self.view?.viewModel!.listVideoComment[index.section].listComment.indices.contains(index.row)) != nil){
         if  let model = viewModel?.listVideoComment[index.section].listComment[index.row]{
            interactor?.sendApproveComment(isApprove: isApprove, id: model.id, completion: { result in
               switch result {
               case .success:
                  if self.view?.viewModel?.fromNoti ??  false {
                     switch self.view?.viewModel?.getCurrentStatus() {
                     case .approvedComment:
                        self.wireFrame?.reloadData()
                     case .waitApprove :
                        self.view?.viewModel?.removeComment(indexCommennt: index)
                        self.wireFrame?.reloadTableView()
                     case .rejectComment :
                        self.wireFrame?.reloadData()
                     case .none:
                        break
                     case .some(.all):
                        self.wireFrame?.reloadData()
                     }
                  }else{
                     self.wireFrame?.reloadData()
                  }
                  
               case.failure(let err ):
                  self.view?.toast(err.localizedDescription)
               }
            })
      }
      }
   }
   
   func showComment() {
      self.viewModel?.isShowCommentView = true
      self.view?.growingTextView.becomeFirstResponder()
   }
   func sendLikeAndDislikeComment(isLike: Bool, index: IndexPath) {
      if  let model = viewModel?.listVideoComment[index.section].listComment[index.row] {
         interactor?.likeAnDislikeComment(index: index, isLike: isLike, idComment: model.id, idVideo: (viewModel?.listVideoComment[index.section].id)!, completion: { [weak self] result in
            if let weakSelf = self {
               switch result {
               case .success:
                  return
               case.failure(let err ):
                  self?.view?.toast(err.localizedDescription)
               }
            }
         }
      )}
   }
   
   func onBack(_ sender: Any) {
      self.view?.dismiss(animated: true, completion: nil)
   }
   func doUpDateComment(comment: String , index : IndexPath) {
      if let user = DataManager.getCurrentMemberModel() {
        
            if  let model = viewModel?.listVideoComment{
               interactor?.getPostComment(indexCell: index, contentId: model[index.section].id, comment: comment, parent_id: model[index.section].listComment[index.row].id, completion: { [weak self] result in
                  switch result {
                  case .success (let respond):
                     let childComment = respond.data
                     self?.viewModel?.doUpdateWithComment(childComment)
                     self?.viewModel?.doUpdateSubComment(index: index, model: childComment)
                     self?.wireFrame?.reloadTableView()
                  case .failure:
                     print("err")
                  }
               })
            }
         self.view?.growingTextView.text = ""
         self.view?.growingTextView.resignFirstResponder()
      }
   }
   
   func CommentAction(text : String ,index : IndexPath) {
      doUpDateComment(comment: text,index: index)
   }
   func registerForKeyboardNotifications() {
      self.view?.rsk_subscribeKeyboardWith(beforeWillShowOrHideAnimation: nil,
                                     willShowOrHideAnimation: { [unowned self]
                                        (keyboardRectEnd, duration, isShowing) -> Void in
                                        self.isVisibleKeyboard = isShowing
                                        self.adjustContent(for: keyboardRectEnd)
                                     }, onComplete: { (finished, isShown) -> Void in
                                       self.isVisibleKeyboard = isShown
                                       if (self.isVisibleKeyboard) {
                                          if (self.viewModel?.isShowCommentView) == true {
                                             self.view?.commentView.isHidden = false
                                          }
                                       } else {
                                          self.viewModel?.isShowCommentView = false
                                          self.view?.commentView.isHidden = true
                                          self.view?.growingTextView.resignFirstResponder()
                                       }
                                     })
      
      self.view?.rsk_subscribeKeyboard(willChangeFrameAnimation: { [unowned self] (keyboardRectEnd, duration) -> Void in
         self.adjustContent(for: keyboardRectEnd)
         self.view?.view.layoutIfNeeded()
      }, onComplete: nil)
   }
    func adjustContent(for keyboardRect: CGRect) {
      let keyboardHeight = keyboardRect.height
      // fix bug keyboard
      let offset: CGFloat = Constants.hasSafeArea ? 35 : 0
      
      let keyboardYPosition = self.isVisibleKeyboard ? keyboardHeight - offset : 0.0;
      self.view?.bottomSpacing.constant = keyboardYPosition
   }
   func presentBottomSheet() {
      let actionsheetController = ActionSheetViewController()
      if let model = self.viewModel?.listStatusComment {
      for (index ,item) in model.enumerated()  {
         let action = Action(ActionData(title:model[index].getTitle(),subTitle: "",imageUrl: ""),
                             style: .default) { (action) in
            self.setUpNavigation(titleButton: (self.viewModel?.setUpStatus(index: index).getTitle())!)
            self.setUpNavigation(titleButton: (self.view?.viewModel?.setUpStatus(index: index).getTitle())!)
            self.wireFrame?.reloadData()
         }
         actionsheetController.addAction(action)
      }
         self.view?.present(actionsheetController, animated: true, completion: nil)
      }
   }
   func getData(){
      self.view?.showHud()
      interactor?.getData(id: (viewModel?.getCurrentComment().getId())!, completion: { resurt in
            switch  resurt {
            case .success( let respond) :
               self.view?.viewModel?.listVideoComment = respond.data
               self.viewModel?.listVideoComment = respond.data
               if respond.data.count == 0 {
                  self.view?.tableView.backgroundView = self.view?.emptyView()
               }
               self.view?.tableView.reloadData()
               self.wireFrame?.hideLoading()
              
            return
            case.failure(let err ) :
               self.wireFrame?.showToast(text: err.localizedDescription)
               self.wireFrame?.hideLoading()
            return
            }
         })
   }
}
