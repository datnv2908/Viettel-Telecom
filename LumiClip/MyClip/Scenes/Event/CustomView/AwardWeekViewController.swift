//
//  AwardWeekViewController.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/30/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import DatePickerDialog

class AwardWeekViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var awardTableView: UITableView!
    @IBOutlet weak var lbFromDate: UILabel!
    @IBOutlet weak var lbToDate: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var awardLabel: UILabel!
    @IBOutlet weak var viewBtn: UIButton!
    
    let cellReuseIdentifier = "UserAwardTableViewCell"
    var minimumDateStr: String
    var startDate: String
    var toDate: String
    var startDateDisplay: String
    var toDateDisplay: String
    var awardDatas:[UserAwardModel]
    let eventService = EventService()
    var currentMonthKey: String
    var currentPage: Int
    
    init(_ startDate: String, _ currentDate: String) {
        self.minimumDateStr = startDate
        self.startDate = startDate
        self.startDateDisplay = startDate
        self.toDate = currentDate
        self.toDateDisplay = currentDate
        self.awardDatas = [UserAwardModel]()
        currentMonthKey = ""
        currentPage = 1
        super.init(nibName: "AwardWeekViewController", bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = String.giai_thuong_tuan
        
        phoneLabel.text = String.so_thue_bao
        awardLabel.text = String.giai_thuong
        viewBtn.setTitle(String.xem, for: .normal)
        
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
        
        lbFromDate.text = "\(String.tu) " + startDateDisplay
        lbToDate.text = "\(String.den) " + toDateDisplay
        
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
    
    func getWeekAwards() {
        currentPage = 1
        showHud()
        eventService.getWeekAward(fromDate: startDate, toDate: toDate, page: 1)
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
        eventService.getWeekAward(fromDate: startDate, toDate: toDate, page: currentPage)
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

    @IBAction func shoFromDatePicker(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let minimumDate = dateFormatter.date(from: minimumDateStr)
        
        let currentDate = dateFormatter.date(from: startDateDisplay)
        
        
        let datePicker = DatePickerDialog(textColor: UIColor.colorFromHexa("009DFD"),
                                          buttonColor: UIColor.colorFromHexa("009DFD"),
                                          font: UIFont.boldSystemFont(ofSize: 18),
                                          showCancelButton: true)
        
        datePicker.show(String.chon_ngay,
                        doneButtonTitle: String.dong_y,
                        cancelButtonTitle: String.huy,
                        defaultDate: currentDate!,
                        minimumDate: minimumDate,
                        maximumDate: Date(),
                        datePickerMode: .date) { (date) in
                            if let dt = date {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "dd/MM/yyyy"
                                self.startDateDisplay = formatter.string(from: dt)
                                self.lbFromDate.text = "\(String.tu) " + self.startDateDisplay
                            }
        }
        
    }
    
    @IBAction func showToDatePicker(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let minimumDate = dateFormatter.date(from: minimumDateStr)
        
        let currentDate = dateFormatter.date(from: toDateDisplay)
        
        
        let datePicker = DatePickerDialog(textColor: UIColor.colorFromHexa("009DFD"),
                                          buttonColor: UIColor.colorFromHexa("009DFD"),
                                          font: UIFont.boldSystemFont(ofSize: 18),
                                          showCancelButton: true)
        
        datePicker.show(String.chon_ngay,
                        doneButtonTitle: String.dong_y,
                        cancelButtonTitle: String.huy,
                        defaultDate: currentDate!,
                        minimumDate: minimumDate,
                        maximumDate: Date(),
                        datePickerMode: .date) { (date) in
                            if let dt = date {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "dd/MM/yyyy"
                                self.toDateDisplay = formatter.string(from: dt)
                                self.lbToDate.text = "\(String.den) " + self.toDateDisplay
                            }
        }
    }
    @IBAction func actionReloadAward(_ sender: Any) {
        startDate = startDateDisplay
        toDate = toDateDisplay
        getWeekAwards()
    }
    
}
