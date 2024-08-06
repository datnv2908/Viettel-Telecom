//
//  CustomDatePickerViewController.swift
//  MyClip
//
//  Created by hnc on 8/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
protocol CustomDatePickerViewControllerDelegate: NSObjectProtocol {
    func customDatePickerViewController(viewController: CustomDatePickerViewController,
                                        dateString: String)
    func customDatePickerViewController(viewController: CustomDatePickerViewController,
                                        didSelectCancelButton sender: UIButton)
}

class CustomDatePickerViewController: BaseViewController {
    var dateFormater = DateFormatter()
    @IBOutlet weak var datePickerDate: UIDatePicker!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    var fromVC  = BaseViewController()
    weak var delegate: CustomDatePickerViewControllerDelegate?
    var date = ""
    
    init(_ date: String) {
        self.date = date
        super.init(nibName: "CustomDatePickerViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        okBtn.setTitle(String.dong_y, for: .normal)
        cancelBtn.setTitle(String.huy, for: .normal)
    }

    override func setupView() {
        dateFormater.dateFormat = "dd/MM/yyyy"
        datePickerDate.datePickerMode = .date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let tmp = formatter.date(from: self.date)
        datePickerDate.date = tmp!
        datePickerDate.addTarget(self,
                             action: #selector(self.datePickerValueChanged),
                             for: .valueChanged)
    }

    @objc func datePickerValueChanged(sender: UIDatePicker) {
        //dateButton.setTitle(dateFormater.string(from: sender.date), for: .normal)
    }

    @IBAction func onClickOKButton(_ sender: Any) {
        let dateString = "\(dateFormater.string(from: datePickerDate.date))"
        delegate?.customDatePickerViewController(viewController: self, dateString: dateString)
    }

    @IBAction func onClickCancelButton(_ sender: Any) {
        delegate?.customDatePickerViewController(viewController: self, didSelectCancelButton: sender as! UIButton)
    }
}
