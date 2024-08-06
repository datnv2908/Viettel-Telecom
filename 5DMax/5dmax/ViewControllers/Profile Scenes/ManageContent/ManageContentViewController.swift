//
//  ManageContentViewController.swift
//  5dmax
//
//  Created by Admin on 3/16/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ManageContentViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    
    @IBOutlet weak var pinCodeButton: UIButton!
    @IBOutlet weak var pinCodeView: UIView!
    @IBOutlet weak var codeTextField1: UITextField!
    @IBOutlet weak var codeTextField2: UITextField!
    @IBOutlet weak var codeTextField3: UITextField!
    @IBOutlet weak var codeTextField4: UITextField!
    @IBOutlet weak var pinCodeOffLabel: UILabel!
    @IBOutlet weak var pinCodeOnLabel: UILabel!

    @IBOutlet weak var babyLabel: UILabel!
    @IBOutlet weak var youthLabel: UILabel!
    @IBOutlet weak var teenLabel: UILabel!
    @IBOutlet weak var adultsLabel: UILabel!

    @IBOutlet weak var startCycleView: UIView!
    @IBOutlet weak var babyCycleView: UIView!
    @IBOutlet weak var youthCycleView: UIView!
    @IBOutlet weak var teenCycleView: UIView!
    @IBOutlet weak var adultsCycleView: UIView!

    @IBOutlet weak var babyLineView: UIView!
    @IBOutlet weak var youthLineView: UIView!
    @IBOutlet weak var teenLineView: UIView!
    @IBOutlet weak var adultsLineView: UIView!
    @IBOutlet weak var levelView: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblLevel: UILabel!

    var pinModel: PinModel = DataManager.getPinModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = String.kiem_soat_cua_phu_huynh
        setupUI()
        setUpLevelView()
    }

    func setupUI() {

        titleLabel.text = String.ban_co_the_kiem_soat
        desLabel.text = String.yeu_cau_nhap_ma_pin_4_so
        lblLevel.text = String.cap_do_kiem_soat_noi_dung
        pinCodeOnLabel.text = String.noi_dung_Nguoi_lon_tro_len_duoc_bao_ve_boi_ma_PIN
        babyLabel.text = String.tre_em
        youthLabel.text = String.thieu_nien
        teenLabel.text = String.teens
        adultsLabel.text = String.nguoi_lon
        
        btnSave.setTitle(String.luu.uppercased(), for: .normal)
        btnCancel.setTitle(String.huy.uppercased(), for: .normal)
        pinCodeButton.setTitle(String.thiet_lap_ma_pin.uppercased(), for: .normal)
        
        view.backgroundColor = AppColor.grayBackgroundColor()
        let boldAttribute = [NSAttributedString.Key.font: AppFont.museoSanFont(style: .bold, size: 14.0)]
        let pinCodeOffText = NSMutableAttributedString(string: String.ma_PIN_dang_tat, attributes: boldAttribute )
        let subString = NSAttributedString(string:" " + String.cho_phep_xem_tat_ca_noi_dung_ma_khong_can_den_ma_PIN)
        pinCodeOffText.append(subString)
        pinCodeOffLabel.attributedText = pinCodeOffText

        codeTextField1.text = pinModel.code1
        codeTextField2.text = pinModel.code2
        codeTextField3.text = pinModel.code3
        codeTextField4.text = pinModel.code4
        if pinModel.isOn {
            btnSave.isHidden = false
            btnCancel.isHidden = false
            pinCodeButton.isHidden = true
        } else {
            btnSave.isHidden = true
            btnCancel.isHidden = true
            pinCodeButton.isHidden = false
        }
        levelView.isHidden = false

        pinCodeOffLabel.isHidden = pinModel.isOn
        pinCodeOnLabel.isHidden = !pinModel.isOn

        btnCancel.layer.borderWidth = 1.0
        btnCancel.layer.borderColor = AppColor.warmGrey().cgColor
    }

    func setUpLevelView() {
        var stringCodeOntext = String.ma_PIN_dang_bat_nNoi_dung_Nguoi_lon_tro_len_duoc_bao_ve_boi_ma_PIN
        var range = NSString(string: stringCodeOntext.lowercased()).range(of: String.nguoi_lon_sub.lowercased())
        if pinModel.isOn {
            switch pinModel.contentLevel {
            case .all:
                setRangeColor(color: AppColor.untAvocadoGreen(),
                              cycleView: babyCycleView,
                              lineView: babyLineView,
                              label: babyLabel)
                setRangeColor(color: AppColor.warmGrey(),
                              cycleView: youthCycleView,
                              lineView: youthLineView,
                              label: youthLabel)
                setRangeColor(color: AppColor.warmGrey(),
                              cycleView: teenCycleView,
                              lineView: teenLineView,
                              label: teenLabel)
                setRangeColor(color: AppColor.warmGrey(),
                              cycleView: adultsCycleView,
                              lineView: adultsLineView,
                              label: adultsLabel)
                stringCodeOntext = String.ma_PIN_dang_bat_nNoi_dung_Thieu_nien_tro_len_duoc_bao_ve_boi_ma_PIN
                range = NSString(string: stringCodeOntext.lowercased()).range(of: String.thieu_nien_sub.lowercased())
                break

            case .required13:
                setRangeColor(color: AppColor.untAvocadoGreen(),
                              cycleView: babyCycleView,
                              lineView: babyLineView,
                              label: babyLabel)
                setRangeColor(color: AppColor.untAvocadoGreen(),
                              cycleView: youthCycleView,
                              lineView: youthLineView,
                              label: youthLabel)
                setRangeColor(color: AppColor.warmGrey(),
                              cycleView: teenCycleView,
                              lineView: teenLineView,
                              label: teenLabel)
                setRangeColor(color: AppColor.warmGrey(),
                              cycleView: adultsCycleView,
                              lineView: adultsLineView,
                              label: adultsLabel)
                stringCodeOntext = String.ma_PIN_dang_bat_nNoi_dung_Teens_tro_len_duoc_bao_ve_boi_ma_PIN
                range = NSString(string: stringCodeOntext.lowercased()).range(of: String.teens.lowercased())
                break

            case .required16:
                setRangeColor(color: AppColor.untAvocadoGreen(),
                              cycleView: babyCycleView,
                              lineView: babyLineView,
                              label: babyLabel)
                setRangeColor(color: AppColor.untAvocadoGreen(),
                              cycleView: youthCycleView,
                              lineView: youthLineView,
                              label: youthLabel)
                setRangeColor(color: AppColor.untAvocadoGreen(),
                              cycleView: teenCycleView,
                              lineView: teenLineView,
                              label: teenLabel)
                setRangeColor(color: AppColor.warmGrey(),
                              cycleView: adultsCycleView,
                              lineView: adultsLineView,
                              label: adultsLabel)
                stringCodeOntext = String.ma_PIN_dang_bat_nNoi_dung_Nguoi_lon_tro_len_duoc_bao_ve_boi_ma_PIN
                range = NSString(string: stringCodeOntext.lowercased()).range(of: String.nguoi_lon_sub.lowercased())
                break

            case .required18:
                setRangeColor(color: AppColor.untAvocadoGreen(),
                              cycleView: babyCycleView,
                              lineView: babyLineView,
                              label: babyLabel)
                setRangeColor(color: AppColor.untAvocadoGreen(),
                              cycleView: youthCycleView,
                              lineView: youthLineView,
                              label: youthLabel)
                setRangeColor(color: AppColor.untAvocadoGreen(),
                              cycleView: teenCycleView,
                              lineView: teenLineView,
                              label: teenLabel)
                setRangeColor(color: AppColor.untAvocadoGreen(),
                              cycleView: adultsCycleView,
                              lineView: adultsLineView,
                              label: adultsLabel)
                stringCodeOntext = String.ma_PIN_dang_bat_nTat_ca_noi_dung_deu_duoc_cho_phep
                range = NSString(string: stringCodeOntext.lowercased()).range(of: stringCodeOntext.lowercased())
                break
            }
            let pinCodeOnText = NSMutableAttributedString(string: stringCodeOntext)
            let boldAttribute = [NSAttributedString.Key.font: AppFont.museoSanFont(style: .bold, size: 14.0)]
            pinCodeOnText.addAttributes(boldAttribute, range: range)
            pinCodeOnLabel.attributedText = pinCodeOnText
            self.startCycleView.backgroundColor = AppColor.untAvocadoGreen()
        } else {
            setRangeColor(color: AppColor.untAvocadoGreenLight(),
                          cycleView: babyCycleView,
                          lineView: babyLineView,
                          label: babyLabel)
            setRangeColor(color: AppColor.untAvocadoGreenLight(),
                          cycleView: youthCycleView,
                          lineView: youthLineView,
                          label: youthLabel)
            setRangeColor(color: AppColor.untAvocadoGreenLight(),
                          cycleView: teenCycleView,
                          lineView: teenLineView,
                          label: teenLabel)
            setRangeColor(color: AppColor.untAvocadoGreenLight(),
                          cycleView: adultsCycleView,
                          lineView: adultsLineView,
                          label: adultsLabel)
            self.startCycleView.backgroundColor = AppColor.untAvocadoGreenLight()
        }

    }

    func setRangeColor(color: UIColor, cycleView: UIView, lineView: UIView, label: UILabel) {
        cycleView.backgroundColor = color
        lineView.backgroundColor = color
        label.textColor = color
    }

    // MARK: 
    // MARK: IBACTIONS
    @IBAction func didSelectSave(_ sender: Any) {

        self.view.endEditing(true)

        if let code1 = codeTextField1.text,
            let code2 = codeTextField2.text,
            let code3 = codeTextField3.text,
            let code4 = codeTextField4.text {
            if code1.characters.count > 0
                && code2.characters.count > 0
                && code3.characters.count > 0
                && code4.characters.count > 0 {

                pinModel.code1 = code1
                pinModel.code2 = code2
                pinModel.code3 = code3
                pinModel.code4 = code4
                pinModel.isOn = true
                setupUI()
                setUpLevelView()
                DataManager.savePIN(pinModel)
                self.navigationController?.toast(String.setupPinCodeSuccess)
                _ = self.navigationController?.popViewController(animated: true)

            } else {
                self.toast(String.enterPinCode)
            }
        }
    }

    @IBAction func didSelectCancel(_ sender: Any) {

        DataManager.deletePIN()
        pinModel = DataManager.getPinModel()
        setupUI()
        setUpLevelView()
    }

    @IBAction func didSelectSetupPinCode(_ sender: Any) {

        if pinModel.isOn && pinModel.isBlank() == false {

            weak var weakSelf = self
            ConfirmPINViewController.showConfirmPIN(fromViewController: self,
                                                    sender: pinCodeButton,
                                                    complete: { () -> (Void) in
                                                        weakSelf?.setPINOn()
            }, cancel: nil)

        } else {
            setPINOn()
        }
    }

    // MARK: 
    // MARK: 
    @IBAction func didSelectBaby(_ sender: Any) {

        if pinModel.isOn {
            self.view.endEditing(true)
            pinModel.contentLevel = .all
            setUpLevelView()
        }
    }

    @IBAction func didSelectYouth(_ sender: Any) {

        if pinModel.isOn {
            self.view.endEditing(true)
            pinModel.contentLevel = .required13
            setUpLevelView()
        }
    }

    @IBAction func didSelectTeen(_ sender: Any) {

        if pinModel.isOn {
            self.view.endEditing(true)
            pinModel.contentLevel = .required16
            setUpLevelView()
        }
    }

    @IBAction func didSelectAdults(_ sender: Any) {

        if pinModel.isOn {
            self.view.endEditing(true)
            pinModel.contentLevel = .required18
            setUpLevelView()
        }
    }

    // MARK: 
    // MARK: METHODS
    func isValid() -> Bool {

        if pinModel.isOn && pinModel.isBlank() == false {

            weak var weakSelf = self
            ConfirmPINViewController.showConfirmPIN(fromViewController: self,
                                                    sender: pinCodeButton,
                                                    complete: { () -> (Void) in

                                                        weakSelf?.setPINOn()

            }, cancel: nil)

            return false
        }

        return true
    }

    func setPINOn() {
        pinModel.isOn = true
        pinCodeButton.isHidden = true
        pinCodeOffLabel.isHidden = true
        pinCodeOnLabel.isHidden = false
        levelView.isHidden = false
        btnSave.isHidden = false
        btnCancel.isHidden = false
        codeTextField1.becomeFirstResponder()
        self.setUpLevelView()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        self.view.endEditing(true)
    }
}

extension ManageContentViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString

        if newString.length > 0 {

            if (newString as String).isNumberInvalid() == false {
                return false
            }

            textField.text = string
            if textField == codeTextField1 {

                codeTextField2.becomeFirstResponder()

            } else if textField == codeTextField2 {

                codeTextField3.becomeFirstResponder()

            } else if textField == codeTextField3 {

                codeTextField4.becomeFirstResponder()
            }

        } else {

            textField.text = ""
            if textField == codeTextField4 {

                codeTextField3.becomeFirstResponder()

            } else if textField == codeTextField3 {

                codeTextField2.becomeFirstResponder()

            } else if textField == codeTextField2 {

                codeTextField1.becomeFirstResponder()
            }
        }

        return false
    }
}
