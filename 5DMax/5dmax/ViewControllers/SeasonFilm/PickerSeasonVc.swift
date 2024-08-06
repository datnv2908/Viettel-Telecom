//
//  PickerSeasonVc.swift
//  5dmax
//
//  Created by Toan on 5/26/21.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit
 
protocol PickerSeasonDelegate: NSObjectProtocol {
    func selectPickerSeason(index : Int,id:Int)
}

class PickerSeasonVc: BaseViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var containner: UIView!
    @IBOutlet weak var seasonPicker: UIPickerView!
//    let seasonPicker = UIPickerView()
    var viewModel : PlayListModel!
    private var selectionIndex : Int = 0
    private var selectModelId : Int = 0
    var delegate : PickerSeasonDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seasonPicker.delegate = self
        seasonPicker.dataSource = self
        self.view.backgroundColor = .clear
        seasonPicker.frame = self.containner.frame
        self.containner.addSubview(seasonPicker)
        let gesture = UITapGestureRecognizer(target: self, action:#selector(tapAction(_:)) )
        tapView.addGestureRecognizer(gesture)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let seasons = viewModel.lisSeasons
        if seasons.indices.contains(viewModel.seasonIndex) {
            self.seasonPicker.selectRow(viewModel.seasonIndex, inComponent: 0, animated: false)
            self.selectionIndex = viewModel.seasonIndex
            self.selectModelId = viewModel.lisSeasons[viewModel.seasonIndex].id
        }
    }
    
    @objc func tapAction(_ tap : UITapGestureRecognizer){
        self.dismiss()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.lisSeasons.count
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let seasonName = NSAttributedString(string: viewModel.lisSeasons[row].name, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
      
        return seasonName;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectionIndex = row
        self.selectModelId = viewModel.lisSeasons[row].id
    }
    private func dismiss(){
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss()
    }
    
     @IBAction func onSelected(_ sender: Any) {
        delegate?.selectPickerSeason(index: selectionIndex,id: self.selectModelId)
        self.dismiss()
     }
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
