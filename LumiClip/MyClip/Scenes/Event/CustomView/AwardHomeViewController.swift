//
//  AwardHomeViewController.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/29/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class AwardHomeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UserAwardHeaderViewDelegate {

    @IBOutlet weak var awardTableView: UITableView!
    let cellReuseIdentifier = "UserAwardTableViewCell"
    var startEventDate: String
    var eventMonthRanges: [MonthRangeModel]
    let eventService = EventService()
    
    var sectionData:[Int:[UserAwardModel]] = [:]
    
    init(_ startDate: String, _ eventMonthRanges: [MonthRangeModel]) {
        self.startEventDate = startDate
        self.eventMonthRanges = eventMonthRanges
        super.init(nibName: "AwardHomeViewController", bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        awardTableView.register(UINib(nibName: "UserAwardTableViewCell", bundle: nil), forCellReuseIdentifier: UserAwardTableViewCell.nibName())
        
        awardTableView.delegate = self
        awardTableView.dataSource = self
        awardTableView.allowsSelection = false
        // Do any additional setup after loading the view.
        self.startEventDate = convertStartDate(startEventDate)
        getWeekAwards();
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
        if((sectionData[section]?.count)! > 5)
        {
            return 5
        }else{
            return (sectionData[section]?.count)!
        }
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UserAwardTableViewCell = self.awardTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! UserAwardTableViewCell
        cell.bindingWithModel(sectionData[indexPath.section]![indexPath.row])
        
        if(indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.white
        }else{
            cell.backgroundColor = UIColor.colorFromHexa("F5F5F5")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view =  UserAwardHeaderView();
        view.delegate = self
        if(section == 0){
            view.bindWithData(type: UserAwardHeaderView.WEEK, timeAward:"\(String.tu) " + startEventDate + " \(String.den.lowercased()) " + self.getCurrentDate())
        }else{
            view.bindWithData(type: UserAwardHeaderView.MONTH, timeAward:eventMonthRanges[0].value)
        }
        return view;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 83
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }
    
    func getWeekAwards() {
        showHud()
        let toDate = getCurrentDate();
        eventService.getWeekAward(fromDate:startEventDate, toDate: toDate, page: 1)
        { (result) in
            switch result {
            case .success(let response):
                self.sectionData[0] = response.data
                self.getMonthAwards()
                break
            case .failure(let error):
                self.toast(error.localizedDescription)
            }
            self.hideHude()
        }
    }
    
    func getMonthAwards() {
        showHud()
        eventService.getMonthAward(for: eventMonthRanges[0].key, page: 1)
        { (result) in
            switch result {
            case .success(let response):
                self.sectionData[1] = response.data
                 self.awardTableView.reloadData();
                //self.getWeekAwards()
                break
            case .failure(let error):
                self.toast(error.localizedDescription)
            }
            self.hideHude()
        }
    }
    
    
    
    func convertStartDate(_ startDate:String) -> String{
        if(!startDate.isEmpty) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: startDate)
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return  dateFormatter.string(from: date!)
        }
        return ""
    }
    
    func getCurrentDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return  dateFormatter.string(from: Date())
    }
    func onClickSeeMoreAction(type: String) {
        if(type == UserAwardHeaderView.MONTH){
            let viewcontroller = AwardMonthViewController(eventMonthRanges)
            navigationController?.pushViewController(viewcontroller, animated: true)
        }else{
            let viewcontroller = AwardWeekViewController(startEventDate, getCurrentDate())
            navigationController?.pushViewController(viewcontroller, animated: true)
        }
    }
    
    @objc private func buttonClicked() {
        
    }

}


