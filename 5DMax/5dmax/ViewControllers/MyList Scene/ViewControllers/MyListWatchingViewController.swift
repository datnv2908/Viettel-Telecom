//
//  MyListWatchingViewController.swift
//  5dmax
//
//  Created by Os on 4/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SVPullToRefresh

class MyListWatchingViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    private var model: CategoryModel
    var groupModel: GroupModel?
    fileprivate var refreshControl = UIRefreshControl()
    var viewModel: MyListWatchingViewModel = MyListWatchingViewModel()
    var service = FilmService()

    var editting: Bool = false
    private var currentOffset = kDefaultOffset
    init(_ type: GroupType) {
        model = CategoryModel(type)
        super.init(nibName: "MyListWatchingViewController", bundle: Bundle.main)
    }

    init(_ category: CategoryModel) {
        model = category
        super.init(nibName: "MyListWatchingViewController", bundle: Bundle.main)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        refreshControl.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.white
        tableView?.addSubview(refreshControl)
        weak var wself = self
        tableView.addInfiniteScrolling {
            let offset = (wself?.currentOffset)! + kDefaultLimit
            wself?.getData(offset: offset, limit: kDefaultLimit)
        }
        tableView.showsInfiniteScrolling = false
        self.navigationItem.title = model.name
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem.composeBarButton(target: self, action: #selector(onEdit))
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshData()
    }

    func setUpView() {
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
    }

    @objc func onEdit() {
        editting = !editting
        tableView.reloadData()
    }

    func reloadData() {
        if viewModel.myList.rows.count == 0 {
            tableView.addNoDataLabel(String.dataNotFound)
        } else {
            tableView.removeNoDataLabel()
        }
        tableView.reloadData()
    }

    func getData(offset: Int, limit: Int) {
        showHud()
        service.getMoreContent(id: model.getMoreContentId, offset: offset, limit: limit) {(model, error) in
            if error != nil {
                self.toast((error?.localizedDescription)!)
            } else {
                self.currentOffset = offset
                if offset == kDefaultOffset {
                    self.groupModel = model
                    self.viewModel = MyListWatchingViewModel(self.groupModel!)
                } else {
                    self.groupModel?.content.append(contentsOf: model!.content)
                    self.viewModel.appendContent(model!.content)
                }
                self.reloadData()
                if (model?.content.count)! < kDefaultLimit {
                    self.tableView.showsInfiniteScrolling = false
                } else {
                    self.tableView.showsInfiniteScrolling = true
                }
            }
            self.hideHude()
            self.refreshControl.endRefreshing()
            self.tableView.infiniteScrollingView.stopAnimating()
        }
    }
    @objc func refreshData() {
        getData(offset: kDefaultOffset, limit: kDefaultLimit)
    }

    func deleteHistoryFilmAtIndex(_ index: Int) {
        showHud()
        let filmId = groupModel?.content[index].partId ?? groupModel?.content[index].id
        service.removeFromHistory(filmId!) { (result) in
            switch result {
            case .success(_ ):
                self.groupModel?.content.remove(at: index)
                self.viewModel = MyListWatchingViewModel(self.groupModel!)
                self.reloadData()
                break
            case .failure(let error):
                self.toast(error.localizedDescription)
                break
            }
            self.hideHude()
        }
    }
}
extension MyListWatchingViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.myList.rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyListWatchingTableViewCell.dequeueReuseCellWithNib(in: tableView, reuseIdentifier: "cell")
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.bindingWithModel(viewModel.myList.rows[indexPath.row], isEditing: editting)
        weak var wself = self
        cell.deleteClosure = {(_ ) in
            wself?.deleteHistoryFilmAtIndex(indexPath.row)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let filmModel = groupModel?.content[indexPath.row] {
            FilmDetailWireFrame.presentFilmDetailModule(self, film: filmModel, noti: false, sendView: false)
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return MoreContentType.film.insetForSection().top
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
}
