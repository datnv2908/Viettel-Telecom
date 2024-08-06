//
//  ManagerCommnentWireFrame.swift
//  MeuClip
//
//  Created by Toannx on 21/11/2021.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit

class ManagerCommnentWireFrame: NSObject {
   weak var view : ManagerCommentViewController?
   var presenter : ManagerCommentPresenter?
}
extension ManagerCommnentWireFrame : ManagerCommentWireFrameInput {
   func reloadData() {
      self.presenter?.getData()
   }
   
   func reloadTableView() {
      self.view?.tableView.reloadData()
   }
   func showToast(text: String) {
      self.view?.toast(text)
   }
   func showLoading(){
      self.view?.showHud()
   }
   func hideLoading(){
      self.view?.hideHude()
   }
   
}
