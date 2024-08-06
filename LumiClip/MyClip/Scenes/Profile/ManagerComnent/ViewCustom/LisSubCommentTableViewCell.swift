//
//  LisSubCommentTableViewCell.swift
//  MeuClip
//
//  Created by mac on 29/10/2021.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit

class LisSubCommentTableViewCell: UITableViewCell {
   
   @IBOutlet weak var subCommentTableView: UITableView!
   var commentModel : [CommentDisPlay]!
   
    override func awakeFromNib() {
        super.awakeFromNib()
      self.setUpTableView()
      
    }
   // MARK: - init

   func blindModel(model : [CommentDisPlay]){
      self.commentModel = model
   }
   
// MARK: - SetUp UI
   func setUpTableView(){
      self.subCommentTableView.delegate = self
      self.subCommentTableView.dataSource = self
      self.subCommentTableView.register(UINib(nibName: "WaitAprroveCommentCell", bundle: nil), forCellReuseIdentifier: "WaitAprroveCommentCell")
   }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
extension LisSubCommentTableViewCell : UITableViewDataSource , UITableViewDelegate {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      return self.commentModel.count
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "WaitAprroveCommentCell") as? WaitAprroveCommentCell else {
         let cell  = UITableViewCell()
         return cell
      }
      cell.bindingWithModel(commentModel[indexPath.row])
      cell.approveComment = { [weak self]  in
         
      }
      cell.rejectComment = { [weak self]  in
         
      }
      
      return cell
   }
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
      return UITableView.automaticDimension
   }

   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      self.subCommentTableView.deselectRow(at: indexPath, animated: false)
      
   }

}
