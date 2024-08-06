//
//  AwardMonthViewController.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/30/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class AwardMonthViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var awardTableView: UITableView!
    @IBOutlet weak var lbTimeAward: UILabel!
    @IBOutlet weak var chooseMonthLabel: UILabel!
    @IBOutlet weak var viewBtn: UIButton!
    
    let cellReuseIdentifier = "UserAwardTableViewCell"
    var eventMonthRanges: [MonthRangeModel]
    var awardDatas:[UserAwardModel]
    let eventService = EventService()
    var currentMonthKey: String
    var currentPage: Int
    
    init(_ eventMonthRanges: [MonthRangeModel]) {
        self.eventMonthRanges = eventMonthRanges
        self.awardDatas = [UserAwardModel]()
        currentMonthKey = ""
        currentPage = 1
        super.init(nibName: "AwardMonthViewController", bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = String.giai_thuong_thang
        
        viewBtn.setTitle(String.xem, for: .normal)
        chooseMonthLabel.text = String.chon_thang
        
        awardTableView.register(UINib(nibName: "UserAwardTableViewCell", bundle: nil), forCellReuseIdentifier: UserAwardTableViewCell.nibName())
        
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
        
        awardDatas = [UserAwardModel]()
        
        lbTimeAward.text = eventMonthRanges[0].value
        currentMonthKey = eventMonthRanges[0].key
        
        getMonthAwards();
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
        return awardDatas.count;
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UserAwardTableViewCell = self.awardTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! UserAwardTableViewCell
        cell.bindingWithModel(awardDatas[indexPath.row])
        
        if(indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.white
        }else{
            cell.backgroundColor = UIColor.colorFromHexa("F5F5F5")
        }
        return cell
    }
    
    func getMonthAwards() {
        currentPage = 1
        showHud()
        eventService.getMonthAward(for: currentMonthKey, page: 1)
        { (result) in
            switch result {
            case .success(let response):
                if(response.data.count > 0){
                    self.awardDatas = response.data
                    self.awardTableView.removeNoDataLabel()
                    self.awardTableView.reloadData()
                    self.awardTableView?.showsInfiniteScrolling = true
                }else{
                    self.awardDatas.removeAll()
                    self.awardTableView.addNoDataLabel(String.khong_co_du_lieu)
                    self.awardTableView.reloadData()
                }
                break
            case .failure(let error):
                self.toast(error.localizedDescription)
            }
            self.hideHude()
            self.awardTableView?.infiniteScrollingView.stopAnimating()
        }
    }
    
    func getNextPage() {
        currentPage += 1
        eventService.getMonthAward(for: currentMonthKey, page: currentPage)
        { (result) in
            switch result {
            case .success(let response):
                if(response.data.count > 0){
                    self.awardDatas.append(contentsOf: response.data)
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

    @IBAction func showDateSelection(_ sender: Any) {
        let actionController = ActionSheetViewController()
        actionController.addSection(Section())
        let selectedQuality: String = lbTimeAward.text!
        for item in eventMonthRanges
        {
            let actionData = selectedQuality == item.value ? ActionData(title: item.value, image: #imageLiteral(resourceName: "tick")) : ActionData(title: item.value)
            let action = Action(actionData, style: .default, handler: { (_) in
                self.lbTimeAward.text = item.value
                self.currentMonthKey = item.key
            })
            actionController.addAction(action)
        }
        present(actionController, animated: true, completion: nil)
    }
    
    @IBAction func actionReloadAward(_ sender: Any) {
        getMonthAwards()
    }
    
}
