//
//  ManagerCommentConfigurator.swift
//  MeuClip
//
//  Created by Toannx on 19/11/2021.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON
class ManagerCommentConfigurator: NSObject {

   class func managerCotroller(listVideoComment : [CommentModelDisplay], curentStatus : CommentStatus,fromNoti : Bool) -> ManagerCommentViewController {
      let view = ManagerCommentViewController.initWithNib()
      var viewModel = ManagerCommentViewModel()
      viewModel.setUpData(listVideoComment: listVideoComment, curentStatus: curentStatus,fromNoti: fromNoti)
      let presenter =  ManagerCommentPresenter()
      let wireFrame = ManagerCommnentWireFrame()
      let interactor = ManagerCommentInteractor()
      
      presenter.wireFrame = wireFrame
      presenter.viewModel = viewModel
      presenter.interactor = interactor
      presenter.view = view
      
     
      wireFrame.view = view
      wireFrame.presenter = presenter
      
      view.viewModel = presenter.viewModel
      view.presenter = presenter
      
      interactor.viewModel = presenter.viewModel
      
     
      return view
   }
}
protocol  ManagerCommentViewModelOutput{
   var listStatusComment : [CommentStatus] {get set}
   var currentIndexStatus : Int {get set}
   var isLike : Bool {get set}
   var listVideoComment : [CommentModelDisplay] {get set}
   var indexSelectedComment: IndexPath? {get set}
   var isShowCommentView: Bool {get set}
   var data: [PBaseRowModel] {get set}
   var listchildComment: [CommentDisPlay] {get set}
   var listSubComment: [CommentDisPlay] {get set}
   var fromNoti: Bool {get set}
   mutating func setUpStatus(index : Int) -> CommentStatus
   mutating func doUpdateSubComment(index : IndexPath, model : CommentDisPlay)
   mutating func doUpdateWithComment(_ comment: CommentDisPlay )
   func getCurrentStatus() -> CommentStatus
   mutating func removeComment(indexCommennt: IndexPath)
   mutating func doUpdateWithToggleLikeComment(at indexPath: IndexPath)
   mutating func doUpdateWithToggleDisLikeComment(at indexPath: IndexPath)
   func getCurrentComment() ->  CommentStatus
   mutating func setUpData(listVideoComment : [CommentModelDisplay] , curentStatus : CommentStatus, fromNoti : Bool)
}
protocol ManagerCommentControllerInput : class {
   func getData(id : String , completion: @escaping (Result<APIResponse<[CommentModelDisplay]>>) -> Void)
   func sendApproveComment(isApprove: Bool , id: String, completion: @escaping (Result<APIResponse<JSON>>) -> Void )
   func likeAnDislikeComment( index : IndexPath ,isLike: Bool, idComment: String, idVideo: String, completion: @escaping (Result<APIResponse<JSON>>) -> Void)
   func getPostComment(indexCell : IndexPath, contentId: String, comment: String, parent_id :String, completion: @escaping (Result<APIResponse<CommentDisPlay>>) -> Void)
}

protocol  ManagerCommentWireFrameInput : class{
   func reloadData()
   func reloadTableView()
   func showToast(text : String)
   func showLoading()
   func hideLoading()
}
protocol ManagerCommentControllerOutPut  : class{
   func viewDidLoad()
   func viewDidAppear(_ animated: Bool)
   func sendApproveComment(isApprove: Bool , index: IndexPath)
   func sendLikeAndDislikeComment(isLike : Bool , index : IndexPath)
   func onBack(_ sender: Any)
   func doUpDateComment(comment: String , index : IndexPath)
   func CommentAction(text : String ,index : IndexPath)
   func presentBottomSheet()
   func setUpNavigation(titleButton : String)
   func adjustContent(for keyboardRect: CGRect)
   func showComment()
   
}
