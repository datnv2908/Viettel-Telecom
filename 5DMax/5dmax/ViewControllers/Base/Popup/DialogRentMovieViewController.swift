//
//  DialogRentMovieViewController.swift
//  5dmax
//
//  Created by admin on 9/11/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import Nuke

class DialogRentMovieViewController: BaseViewController {

    private var confirmButtonTitle: String = String.rentFilm
    private var cancelButtonTitle: String = String.cancel
    
    @IBOutlet weak var hireFilmBtn: UIButton!
    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var nameFilmLabel: UILabel!
    @IBOutlet weak var countryFilmLabel: UILabel!
    @IBOutlet weak var yearFilmLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceFilmLabel: UILabel!
    @IBOutlet weak var avatarFilmImageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var rentMovieView: UIView!
    @IBOutlet weak var rentMovieButton: UIButton! {
        didSet {
            rentMovieButton.titleLabel?.numberOfLines = 0
            rentMovieButton.titleLabel?.lineBreakMode = .byWordWrapping
            rentMovieButton.titleLabel?.textAlignment = .center
        }
    }
    @IBOutlet weak var rentMovieItemButton: UIButton!
    
    @IBOutlet weak var rentMovieAllView: UIView!
    @IBOutlet weak var rentMovieEsButton: UIButton! {
        didSet {
            rentMovieEsButton.titleLabel?.numberOfLines = 0
            rentMovieEsButton.titleLabel?.lineBreakMode = .byWordWrapping
            rentMovieEsButton.titleLabel?.textAlignment = .center
        }
    }
    @IBOutlet weak var rentMovieAllButton: UIButton! {
        didSet {
            rentMovieAllButton.titleLabel?.numberOfLines = 0
            rentMovieAllButton.titleLabel?.lineBreakMode = .byWordWrapping
            rentMovieAllButton.titleLabel?.textAlignment = .center
        }
    }
    
    public var confirmDialog: ((UIButton) -> Void)?
    public var confirmEsDialog: ((UIButton) -> Void)?
    public var cancelDialog: ((UIButton) -> Void)?
    
    public var mTitle: String = ""
    public var mFilmTitle: String = ""
    public var mCountry: String = String.dang_cap_nhat
    public var mTimeForUse: String = ""
    public var mPrice: String = ""
    public var mPriceFull: String = ""
    public var mImageThumbUrl: String?
    public var mTimeUse: String = ""
    public var misBuyPlaylist: Bool = false
    public var misBuyVideo: Bool = false
    public var misDrm: Bool = false
    
    init(title: String?,
         filmTitle: String?,
         country: String?,
         time: String?,
         price: String?,
         priceFull: String?,
         image: String?,
         timeUse: String?,
         isBuyVideo: Bool?,
         isBuyPlaylist: Bool?,
         isDrm: Bool?) {
        if let value = title {
            mTitle      = value
        }
        
        if let value = filmTitle {
            mFilmTitle  = value
        }
        
        if let value = country {
            mCountry  = value
        }
        
        if let value = time {
            mTimeForUse  = value
        }
        
        if let value = price {
            mPrice  = value
        }
        
        if let value = priceFull {
            mPriceFull  = value
        }
        
        if let value = timeUse {
            mTimeUse = value
        }
        
        if let value = isBuyPlaylist {
            misBuyPlaylist = value
        }
        
        if let value = isBuyVideo {
            misBuyVideo = value
        }
        
        if let value = isDrm {
            misDrm = value
        }
        
        mImageThumbUrl = image
        super.init(nibName: "DialogRentMovieViewController", bundle: Bundle.main)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameFilmLabel.text = mFilmTitle
        hireFilmBtn.setTitle(misDrm ? String.rentFilm : String.buyFilm, for: .normal)
        if (misBuyPlaylist && misBuyVideo) {
            rentMovieView.isHidden = true
            rentMovieAllView.isHidden = false
            rentMovieEsButton.setTitle("\(misDrm ? String.thue_tap_drm.uppercased() : String.thue_tap.uppercased())\n\(String.price)\(mPrice)", for: .normal)
            rentMovieAllButton.setTitle("\(misDrm ? String.thue_toan_bo_drm.uppercased() : String.thue_toan_bo.uppercased())\n\(String.price)\(mPriceFull)", for: .normal)
        } else {
            rentMovieView.isHidden = false
            rentMovieAllView.isHidden = true
            
            if misBuyPlaylist {
                rentMovieButton.setTitle("\(String.thue_phim.uppercased())\n\(String.price) \(mPriceFull)", for: .normal)
            }
            
            if misBuyVideo {
                rentMovieButton.setTitle("\(String.thue_tap.uppercased())\n\(String.price) \(mPrice)", for: .normal)
            }
        }
        
        countryFilmLabel.text = String.quoc_gia + ": \(mCountry)"
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        yearFilmLabel.text = "\(String.nam_san_xuat): \(mTimeForUse)"
//        priceTitleLabel.text = String.gia_cuoc.uppercased()
//        priceFilmLabel.text = "\(String.price)\(String.displayMoneyFormatWithInValue(mPrice))"
        
        if let imageURLStr = mImageThumbUrl {
            if let url = URL(string: imageURLStr),
                let thumb = avatarFilmImageView {
                let request = ImageRequest(url: url)
                Nuke.loadImage(with: request, into: thumb)
            }
        }
        
        descriptionLabel.text = String.thoi_gian_su_dung + ": \(mTimeUse)"
    }
    
    @IBAction func onBuyFilmItemButton(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.confirmDialog?(sender)
        }
    }
    
    @IBAction func onBuyFilmButton(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
            if (self.misBuyPlaylist && self.misBuyVideo) {
                self.confirmDialog?(sender)
            } else {
                if self.misBuyPlaylist {
                    self.confirmDialog?(sender)
                }
                
                if self.misBuyVideo {
                    self.confirmEsDialog?(sender)
                }
            }
        }
    }
    
    @IBAction func onBuyEsFilmButton(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.confirmEsDialog?(sender)
        }
    }
    
    @IBAction func onCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.cancelDialog?(sender)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
