//
//  DetailCatogoryViewController.swift
//  MyClip
//
//  Created by Os on 9/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class DetailCatogoryViewController: BaseSimpleTableViewController<ContentModel> {
    let service = VideoServices()
    var cateModel = CategoryModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func setupView() {
        super.setupView()
        setUpNavigationItem()
        tableView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        refreshData()
    }
    
    func setUpNavigationItem() {
        navigationItem.title = cateModel.name
    }
    
    override func getData(pager: Pager, _ completion: @escaping (Result<APIResponse<[ContentModel]>>) -> Void) {
         let cateId = "video_of_category_" + cateModel.id
        service.getMoreContents(for: cateId, pager: pager) { (result) in
            completion(result)
            
            let showDate = UserDefaults.standard.string(forKey: "show_message_2010")
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let currentDateStr = formatter.string(from: date)
            
            if(showDate != nil && showDate == currentDateStr) {
                return
            }
            
            switch result {
            case .success(let response):
                if(response.popupEvent.message.count > 0){
                    self.showWishMessage(message:response.popupEvent.message, image: response.popupEvent.image)
                }
                
                break
            default:
                break
            }
        }
    }
    
    func showWishMessage(message: String, image: String) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let currentDateStr = formatter.string(from: date)
        
        UserDefaults.standard.set(currentDateStr, forKey: "show_message_2010")
        
        let dialogEvent = DialogPictureViewController(message: message,
                                          image: image)
        presentDialogEvent(dialogEvent, animated: true, completion: nil)
    }
    
    override func convertToRowModel(_ item: ContentModel) -> PBaseRowModel? {
        return VideoRowModel(video: item)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.data[indexPath.row]
        showVideoDetails(model)
    }
    
    deinit {
        service.cancelAllRequests()
    }
}

