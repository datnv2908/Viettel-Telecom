//
//  ListCountryViewController.swift
//  5dmax
//
//  Created by Hoang on 3/22/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol ListCategoryViewControllerDelegate: class {
    func didSelectCountry(viewController: ListCategoryViewController, category: CategoryModel)
}

class ListCategoryViewController: BaseViewController {

    @IBOutlet weak var btnType: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var listCountries: [CategoryModel] = []
    weak var delegate: ListCategoryViewControllerDelegate?
    var type: FilmType = .retail

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func btnBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpView() {
        self.navigationItem.title = type.stringValue()
        self.btnType.setTitle(String.the_loai, for: .normal)
        tableView.rowHeight = 50.0
    }
    
    func setUpData() {
        if let setting = DataManager.getDefaultSetting() {
            switch type {
            case .retail:
                listCountries.append(contentsOf: setting.categories)
                break
            case .series:
                listCountries.append(contentsOf: setting.countries)
                break
            }
        }
    }
}

extension ListCategoryViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCountries.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = AppFont.museoSanFont(style: .light, size: 14.0)

        let country = listCountries[indexPath.row]
        cell.textLabel?.text = country.name.capitalized
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let category = listCountries[indexPath.row]
        self.delegate?.didSelectCountry(viewController: self, category: category)
        
        let vc = MoreContentViewController(category, fromNoti: false)
        let nav = BaseNavigationViewController(rootViewController: vc)
        self.mm_drawerController.centerViewController = nav
        self.mm_drawerController.toggle(.left, animated: true, completion: nil)
    }
}

extension ListCategoryViewController {

    class func initWithType(_ type: FilmType) -> ListCategoryViewController {
        let viewController = ListCategoryViewController.initWithNib()
        viewController.type = type
        return viewController
    }
}
