//
//  EarningViewController.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/30/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class EarningViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tnhtLabel: UILabel!
    @IBOutlet weak var tgLabel: UILabel!
    @IBOutlet weak var ttLabel: UILabel!
    @IBOutlet weak var tnLabel: UILabel!
    
    @IBOutlet weak var lbMonthEarning: UILabel!
    @IBOutlet weak var lbNotice: UILabel!
    @IBOutlet weak var awardTableView: UITableView!
    
    let cellReuseIdentifier = "EarningHistoryTableViewCell"

    let eventService = EventService()
    var currentOffset: Int = 12
   @IBOutlet weak var headerView: UIView!
   var historiesDatas:[EarningItemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = String.thu_nhap
        
        tnhtLabel.text = String.thu_nhap_hang_thang
        tgLabel.text = String.thoi_gian
        ttLabel.text = String.trang_thai
        tnLabel.text = String.thu_nhap
        headerView.backgroundColor = UIColor.setViewColor()
        tnLabel.textColor = UIColor.settitleColor()
       lbMonthEarning.textColor = UIColor.settitleColor()
        awardTableView.register(UINib(nibName: "EarningHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: EarningHistoryTableViewCell.nibName())
        
        awardTableView.delegate = self
        awardTableView.dataSource = self
        awardTableView.allowsSelection = false
        
        awardTableView.addNoDataLabel(String.khong_co_du_lieu)
        weak var wself = self
        awardTableView?.addInfiniteScrolling(actionHandler: {
            wself?.getNextPage()
        })
        awardTableView?.showsInfiniteScrolling = false
        // Do any additional setup after loading the view.
        
        historiesDatas = [EarningItemModel]()
      awardTableView.backgroundColor = UIColor.setViewColor()
        getHistories();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historiesDatas.count;
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:EarningHistoryTableViewCell = self.awardTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! EarningHistoryTableViewCell
        cell.bindingWithModel(historiesDatas[indexPath.row])

        if(indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.white
        }else{
            cell.backgroundColor = UIColor.colorFromHexa("F5F5F5")
        }
        return cell
    }
    
    func getHistories() {
        showHud()
        eventService.getMonthEarning(limit:12)
        { (result) in
            switch result {
            case .success(let response):
                if(response.data.histories.count > 0){
                    self.historiesDatas = response.data.histories
                    self.awardTableView.removeNoDataLabel()
                    self.awardTableView.reloadData()
                    self.awardTableView?.showsInfiniteScrolling = true
                }else{
                    self.historiesDatas.removeAll()
                    self.awardTableView.addNoDataLabel(String.khong_co_du_lieu)
                    self.awardTableView.reloadData()
                }
                
                if(response.data.currentRevenueStr != "") {
                    self.lbMonthEarning.text = response.data.currentRevenueStr;
                }else{
                    self.lbMonthEarning.text = "0mt";
                }
                self.lbNotice.text = response.data.hintMessage;
                
                break
            case .failure(let error):
                self.toast(error.localizedDescription)
            }
            self.hideHude()
            self.awardTableView?.infiniteScrollingView.stopAnimating()
        }
    }
    
    func getNextPage() {
        eventService.getMonthEarningMore(limit: 12, offset: currentOffset)
        { (result) in
            switch result {
            case .success(let response):
                if(response.data.histories.count > 0){
                    self.currentOffset = self.currentOffset + 12
                    self.historiesDatas.append(contentsOf: response.data.histories)
                    self.awardTableView.reloadData()
                    self.awardTableView?.showsInfiniteScrolling = true
                }else{
                    self.awardTableView?.showsInfiniteScrolling = false
                }
                break
            case .failure(let error):
                self.toast(error.localizedDescription)
            }
            self.hideHude()
            self.awardTableView?.infiniteScrollingView.stopAnimating()
        }
    }

    
}
