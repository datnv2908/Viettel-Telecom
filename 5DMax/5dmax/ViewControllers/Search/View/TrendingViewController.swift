//
//  TrendingViewController.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol TrendingViewControllerDelegate: NSObjectProtocol {
    func trendingView(_ viewcontroller: TrendingViewController, didSelectItem keyword: String)
}

class TrendingViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    fileprivate var keywords = [String]()
    fileprivate var viewModel: TrendingViewModel
    weak var delegate: TrendingViewControllerDelegate?

    init() {
        viewModel = TrendingViewModel(keywords)
        super.init(nibName: "TrendingViewController", bundle: Bundle.main)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        headerView.backgroundColor = UIColor.clear
        tableView.tableHeaderView = headerView
        doSomethingOnLoad()
    }

    func doSomethingOnLoad() {
        if let model = DataManager.getDefaultSetting() {
            keywords = model.hotKeywords
            viewModel = TrendingViewModel(keywords)
            for row in viewModel.rows {
                tableView.register(UINib(nibName: row.identifier, bundle: Bundle.main),
                                   forCellReuseIdentifier: row.identifier)
            }
        }
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 65
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension TrendingViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowModel = viewModel.rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: rowModel.identifier,
                                                 for: indexPath) as! BaseTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.bindingWithModel(rowModel)
        return cell
    }
}

extension TrendingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = TrendingHeaderView.dequeueReuseHeaderWithNib(in: tableView,
                                                                reuseIdentifier: TrendingHeaderView.nibName())
        return view
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            delegate.trendingView(self, didSelectItem: self.keywords[indexPath.row])
        }
    }
}
