//
//  SubCommentViewController.swift
//  MyClip
//
//  Created by ThuongPV-iOS on 11/20/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
protocol SubCommentViewControllerDelegate: NSObjectProtocol {
    func subCommentViewController(_ viewController: SubCommentViewController, didSelectClose sender: UIButton)
    func subCommentViewController(_ viewController: SubCommentViewController, didSelectLikeComment sender: UIButton, at indexPath: IndexPath)
    func subCommentViewController(_ viewController: SubCommentViewController, didSelectEditCommentId comment: CommentModel)
    func subCommentViewController(_ viewController: SubCommentViewController, didSelectShowTextView sender: UIButton)
    func subCommentViewController(_ viewController: SubCommentViewController,
                                 didSelectDisLikeComment sender: UIButton,
                                 at indexPath: IndexPath)
}

class SubCommentViewController: BaseViewController {
    var parentId = ""
    var viewModel = SubCommentViewModel()
    weak var delegate: SubCommentViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var allRepLabel: UILabel!
    @IBOutlet weak var allCommentView: UIView!
    let service = VideoServices()
   var canComment : Bool = true
    init(_ videoId: String) {
        viewModel.videoId = videoId
        super.init(nibName: "SubCommentViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allCommentView.backgroundColor = UIColor.setViewColor()
        self.allRepLabel.textColor  = UIColor.settitleColor()
        self.allRepLabel.text = String.tat_ca_tra_loi
      self.tableView.backgroundColor = UIColor.setViewColor()
        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        tableView.register(UINib(nibName: CommentInfoTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: CommentInfoTableViewCell.nibName())
        tableView.register(UINib(nibName: RootCommentTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: RootCommentTableViewCell.nibName())
    }
    
    func doUpdateWithComment(_ comment: CommentModel) {
        viewModel.doUpdateWithComment(comment)
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func toggleLikeComment(_ indexPath: IndexPath) {
        let comment = viewModel.data[indexPath.row]
        viewModel.doUpdateWithToggleLikeComment(at: indexPath)
        tableView.reloadData()
        service.toggleLikeComment(type: "VOD", contentId: (viewModel.videoId), commentId: comment.objectID, completion: { (result) in
            switch result {
            case .success(_):
                break
            case .failure(_):
                break
            }
        })
    }
   func toggleDisLikeComment(_ indexPath: IndexPath) {
       let comment = viewModel.data[indexPath.row]
       viewModel.doUpdateWithToggleLikeComment(at: indexPath)
       tableView.reloadData()
      service.toggleDisLikeComment(type: "VOD ", contentId: (viewModel.videoId), commentId: comment.objectID) { (result) in
             switch result {
             case .success(_):
               break
             case .failure(_):
                 break
             }
         }
   }
    @IBAction func onClickCloseButton(_ sender: Any) {
        delegate?.subCommentViewController(self, didSelectClose: sender as! UIButton)
    }
    
}

extension SubCommentViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.data[indexPath.row] as! CommentInfoRowModel
        let cell = tableView.dequeueReusableCell(withIdentifier: model.identifier, for: indexPath) as! BaseTableViewCell
        cell.bindingWithModel(model)
        if let cell = cell as? CommentInfoTableViewCell {
            cell.delegate = self
        }
        if let cell = cell as? RootCommentTableViewCell {
            cell.btnComment.isUserInteractionEnabled = canComment
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension SubCommentViewController: CommentInfoTableViewCellDelegate {
    func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell, didClickLike sender: UIButton) {
        if let indexPath = tableView.indexPath(for: cell) {
            toggleLikeComment(indexPath)
            delegate?.subCommentViewController(self, didSelectLikeComment: sender, at: indexPath)
        }
    }
    
    func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell, didSelectEdit sender: UIButton) {
        if let indexPath = tableView.indexPath(for: cell) {
            let model = viewModel.listSubComment[indexPath.row-1]
            delegate?.subCommentViewController(self, didSelectEditCommentId: model)
        }
    }
   func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell, onSelectRejectComment sender: UIButton) {
      if let indexPath = tableView.indexPath(for: cell) {
          let model = viewModel.listSubComment[indexPath.row-1]
      }
   }
    func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell, didClickComment sender: UIButton) {
        
    }
    
    func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell, onSelectShowSubComment sender: UIButton) {
        
    }
    func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell, didClickDisLike sender: UIButton) {
      if let indexPath = tableView.indexPath(for: cell) {
         self.toggleDisLikeComment(indexPath)
         viewModel.doUpdateWithToggleDisLikeComment(at: indexPath)
         self.tableView.reloadData()
      }
    }
}

extension SubCommentViewController: RootCommentTableViewCellDelegate {
    func rootCommentTableViewCell(_ cell: RootCommentTableViewCell, didSelectLikeButton sender: UIButton) {
        if let indexPath = tableView.indexPath(for: cell) {
            delegate?.subCommentViewController(self, didSelectLikeComment: sender, at: indexPath)
            viewModel.doUpdateWithToggleLikeComment(at: indexPath)
            tableView.reloadData()
        }
    }
   func rootCommentTableViewCell(_ cell: RootCommentTableViewCell, didSelectDisLikeButton sender: UIButton) {
      if let indexPath = tableView.indexPath(for: cell) {
         delegate?.subCommentViewController(self, didSelectDisLikeComment: sender, at: indexPath)
         viewModel.doUpdateWithToggleDisLikeComment(at: indexPath)
         tableView.reloadData()
      }
      
   }
    
    func rootCommentTableViewCell(_ cell: RootCommentTableViewCell, didSelectShowComment sender: UIButton) {
        if let indexPath = tableView.indexPath(for: cell) {
            let model = viewModel.data[indexPath.row]
            delegate?.subCommentViewController(self, didSelectShowTextView: sender)
        }
    }
    
    func rootCommentTableViewCell(_ cell: RootCommentTableViewCell, didSelectCommentButton sender: UIButton) {
        
    }
}
