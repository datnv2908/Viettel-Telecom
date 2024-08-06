//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//
import UIKit
import AVKit
import AVFoundation
import GoogleCast
import MMDrawerController
import MessageUI
import Reachability


class FilmDetailView: BaseViewController, FilmDetailViewProtocol, MFMessageComposeViewControllerDelegate, PickerSeasonDelegate {
   
    
 
    private var detailContext = 3
    var presenter: FilmDetailPresenterProtocol?
    var filmPresenter: FilmDetailPresenter?
    // A dictionary of offscreen cells that are used within the sizeForItemAtIndexPath method to handle the size calculations. These are never drawn onscreen. The dictionary is in the format:
    // { NSString *reuseIdentifier : UICollectionViewCell *offscreenCell, ... }
    fileprivate var offscreenCells = [String: UICollectionViewCell]()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var castButton: GCKUICastButton!
    var reality = Reachability()
    var isShowFullDesc: Bool = false
    private var notifyModel: NotifyModel?
   var isHeightCalculated: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
        setUpView()
        if Constants.isIpad {
            view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
            view.isOpaque = false
        }
        
        let height = -UIApplication.shared.statusBarFrame.height
        collectionView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0 )
        guard let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: Constants.screenWidth, height: 350)
//        collectionView.collectionViewLayout = layout
//
//        collectionView2.la
//        UserDefaults.standard.addObserver(self,
//                                          forKeyPath: Constants.kLoginStatus,
//                                          options: [.new],
//                                          context: &detailContext)
        
        self.view.stopSnowing()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiceRemoteNotification(_:)),
                                               name: NSNotification.Name.receiveRemoteNotification,
                                               object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Constants.appDelegate.rootViewController.drawerController.openDrawerGestureModeMask = .custom
        logViewEvent(Constants.fire_base_detail, Constants.fire_base_detail_event)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DismissDetailFilm"), object: nil)
            NotificationCenter.default.removeObserver(self,
                                                             name: NSNotification.Name.receiveRemoteNotification, object: nil)
        }
        Constants.appDelegate.rootViewController.drawerController.openDrawerGestureModeMask = .bezelPanningCenterView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func setUpView() {
        headerViewHeight.constant = UIApplication.shared.statusBarFrame.height + 44.0
        let view = UIView(frame: CGRect(x: 0, y: 0, width: headerView.frame.size.width, height: headerViewHeight.constant))
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [AppColor.navigationColor().cgColor, UIColor.clear.cgColor]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.addSublayer(gradient)
        headerView.insertSubview(view, at: 0)
        
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK:-
    //MARK: IBACTIONS
    @objc func didReceiceRemoteNotification(_ notify: NSNotification) {
        notifyModel = notify.object as? NotifyModel
        if let model = notifyModel {
            if model.contentType  == .category || model.contentType == .collection {
                presenter?.didReceiveCateNoti(id: model.partId,type: model.contentType, model: model)
            }else{
                FilmDetailWireFrame.reloadDataFromNotifi(self, film: model.parentId, part: model.partId, noti: false, sendView: false)
                
            }
        }
    }
    @IBAction func btnBackPressed(_ sender: Any) {
        presenter?.didTapOnCloseButton(sender)
    }
    
    @IBAction func btnSharePressed(_ sender: UIButton) {
        self.presenter?.onShare(sender)
    }
    
    @IBAction func btnSearchPressed(_ sender: Any) {
        if #available(iOS 10.0, *) {
            let vc = SearchViewController.initWithNib()
            let nav = BaseNavigationViewController(rootViewController: vc)
            nav.modalPresentationStyle = .overCurrentContext
            self.present(nav, animated: true, completion: nil)
        } else {
            toast("Version bigger 10.0")
        }
    }

    @IBAction func btnChromeCastPressed(_ sender: UIButton) {
    
    }
    
    // MARK: - - obser value for keypath
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &detailContext {
            accessTokenDidChanged()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    func accessTokenDidChanged() {
        self.presenter?.viewDidLoad()
    }

    //mark: -- FilmDetailViewProtocol
    //reload view with Playlist Model
    func scrollToTop() {
        self.collectionView.scrollRectToVisible(self.view.frame, animated: true)
    }
    
    func reloadData() {

        for sectionModel in (presenter as! FilmDetailPresenter).viewModel.sections {
            if let identifier = sectionModel.identifier {
                collectionView.register(UINib(nibName: identifier, bundle: Bundle.main), forCellWithReuseIdentifier: identifier)
            }
            if let identifier = sectionModel.headerIdentifier {
                collectionView.register(UINib(nibName: identifier, bundle: Bundle.main), forSupplementaryViewOfKind:
                    UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
            }
        }
        weak var weakSelf = self
//        DispatchQueue.main.async {
            weakSelf?.collectionView.reloadData()
//      }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    deinit {
//        UserDefaults.standard.removeObserver(self, forKeyPath: Constants.kLoginStatus, context: &detailContext)
    }
    
    func showSMSConfirm(_ fromView: FilmDetailViewProtocol?, message: String, number: String, content: String) {
        if MFMessageComposeViewController.canSendText() == true {
            let recipients:[String] = [number]
            let messageController = MFMessageComposeViewController()
            messageController.messageComposeDelegate  = self
            messageController.recipients = recipients
            messageController.body = content
            self.present(messageController, animated: true, completion: nil)
        } else {
            self.toast(String.thiet_bi_khong_ho_tro_nhan_tin)
        }
    }
    
    func showAlertExpired(_ model: PBaseRowModel) {
        
        if let filmDetail = (presenter as! FilmDetailPresenter).viewModel.detailModel {
            if let isEverBuyPlaylist = filmDetail.stream.popup?.isEverBuyPlaylist, isEverBuyPlaylist == true {
                let popupViewController = AlertPopupViewController.init(titleStr: String.thong_bao, message: filmDetail.stream.popup?.confirm ?? "", cancelTitle: String.okString)
                popupViewController.cancelDialog = {(_) in
                    self.showConfrimPopup(model)
                }
                self.present(popupViewController, animated: true, completion: nil)
            } else {
                self.showConfrimPopup(model)
            }
        } else {
            self.showConfrimPopup(model)
        }
    }
    
    func showConfrimPopup(_ model: PBaseRowModel) {
        var priceFull: String = ""
        var price: String = ""
        
        
        let rowModel = model as? FilmDetailViewModel.FilmTitleRowModel
        let filmDetail = (presenter as! FilmDetailPresenter).viewModel.detailModel
        let isBuyVideo = (filmDetail?.stream.popup?.isBuyVideo)!
        let isBuyPlaylist = (filmDetail?.stream.popup?.isBuyPlaylist)!
        
        if isBuyPlaylist {
            priceFull = filmDetail?.detail.priceFull ?? ""
        }
        
        if isBuyVideo {
            price = rowModel?.price ?? ""
        }
        
        let viewcontroller = DialogRentMovieViewController(title: String.rentFilm,
                                                           filmTitle: rowModel?.title,
                                                           country: rowModel?.country,
                                                           time: rowModel?.yearofProduct,
                                                           price: price,
                                                           priceFull: priceFull,
                                                           image: rowModel?.imageUrl,
                                                           timeUse: rowModel?.buyStatusText,
                                                           isBuyVideo: isBuyVideo,
                                                           isBuyPlaylist: isBuyPlaylist,
                                                           isDrm: filmDetail?.isDRMContent())
        viewcontroller.view.backgroundColor = .clear
        viewcontroller.confirmDialog = {(_) in
            self.presenter?.onSelectItem(.price, 0)
        }
        viewcontroller.confirmEsDialog = {(_) in
            self.presenter?.onRentESFilm()
        }
        self.present(viewcontroller, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult){
        controller.dismiss(animated: true, completion: nil)
    }
}

extension FilmDetailView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (presenter as! FilmDetailPresenter).viewModel.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (presenter as! FilmDetailPresenter).viewModel.sections[section].rows.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionModel = (presenter as? FilmDetailPresenter)?.viewModel.sections[indexPath.section],
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sectionModel.identifier!, for: indexPath) as? BaseCollectionViewCell else {
            return UICollectionViewCell()
        }
        
//        let sectionModel = (presenter as! FilmDetailPresenter).viewModel.sections[indexPath.section]
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sectionModel.identifier!, for: indexPath) as! BaseCollectionViewCell
        
        if let inforcell = cell as? FilmInfoCollectionViewCell {
            inforcell.delegate = self
        }
        
        if let infocell = cell as? TrailerCollectionViewCell {
            infocell.delegate = self
            if infocell.titleLabel?.text?.isEmpty == true {
                infocell.titleLabel?.isHidden = false
                infocell.titleLabel?.text = String.dang_cap_nhat
            } else {
                infocell.titleLabel?.isHidden = true
            }
        }

        if let seasonCell = cell as? FilmSeasonCollectionViewCell {
            seasonCell.delegate = self
            
        }
        
        if let cellDesc = cell as? FilmDescCollectionViewCell {
            cellDesc.bindingWithModel(sectionModel.rows[indexPath.row], isShowFullDesc)
        } else {
            cell.bindingWithModel(sectionModel.rows[indexPath.row])
        }
        self.collectionView.setNeedsLayout()
        self.collectionView.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let model  = (presenter as! FilmDetailPresenter).viewModel
            let sectionModel = model.sections[indexPath.section]
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                       withReuseIdentifier: sectionModel.headerIdentifier!,
                                                                       for: indexPath) as! FilmRelatedCollectionReusableView
            view.delegate = self
            view.bindingWithModel(sectionModel)
            if let data = model.detailModel {
                view.isSeason(isSeason: data.isSeasonFilm)
                if data.isSeasonFilm {
                    view.getListModel(model: data)
                }
            }
            
            return view
        } else {
            return UICollectionReusableView()
        }
    }
}

extension FilmDetailView:FilmInfoCollectionViewCellDelegate {
    func cellDisSelectAddToWatchLater() {
        presenter?.onAddToFavorite()
    }
}

extension FilmDetailView: TrailerCollectionViewCellDelegate {
    func didSelectPlayTrailer(cell: TrailerCollectionViewCell, sender: Any) {
        presenter?.doPlayTrailer()
    }
}

extension FilmDetailView: FilmSeasonCollectionViewCellDelegate {
    func filmSeasonCollectionViewCell(_ cell: FilmSeasonCollectionViewCell, didSelectEpisodeAtIndex index: Int) {
        presenter?.onChoosePart(index)
    }

    func filmSeasonCollectionViewCell(_ cell: FilmSeasonCollectionViewCell, didTapOnPlayPart sender: Any) {
        presenter?.onSelectItem(.cover, 0)
    }
}

extension FilmDetailView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionModel = (presenter as! FilmDetailPresenter).viewModel.sections[section]
        let insets = sectionModel.type.insetForSection()
        return insets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let sectionModel = (presenter as! FilmDetailPresenter).viewModel.sections[section]
        return sectionModel.type.lineSpacing()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let sectionModel = (presenter as! FilmDetailPresenter).viewModel.sections[section]
        return sectionModel.type.itemSpacing()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionModel = (presenter as! FilmDetailPresenter).viewModel.sections[indexPath.section]
        if sectionModel.type.sizeForItem() == CGSize.zero {
            var cell = self.offscreenCells[sectionModel.identifier!] as? BaseCollectionViewCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed(sectionModel.identifier!, owner: self,
                                                options: nil)?.first as? BaseCollectionViewCell
            }
            
            if let cellDesc = cell as? FilmDescCollectionViewCell {
                cellDesc.descLabel?.numberOfLines = isShowFullDesc ? 0 : 3
            }
            
            cell?.bindingWithModel(sectionModel.rows[indexPath.row])
            let margin = sectionModel.type.margin()
            let width = Constants.screenWidth - margin
            
            cell!.bounds = CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude)
            cell!.contentView.bounds = cell!.bounds
            cell!.setNeedsLayout()
            cell!.layoutIfNeeded()
            var size = cell!.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            size.width = width
            return size
        } else {
            return sectionModel.type.sizeForItem()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let sectionModel = (presenter as! FilmDetailPresenter).viewModel.sections[section]
        return sectionModel.type.sizeForHeader()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if ((cell as? FilmDescCollectionViewCell) != nil) {
            isShowFullDesc = !isShowFullDesc
            collectionView.reloadData()
        } else if ((cell as? FilmPriceCollectionViewCell) != nil) {
            let sectionModel = (presenter as! FilmDetailPresenter).viewModel.sections[indexPath.section]
            let model = sectionModel.rows[indexPath.row]
            showAlertExpired(model)
        } else if let item = presenter as? FilmDetailPresenter {
            
            let sectionModel = item.viewModel.sections[indexPath.section]
            if sectionModel.type == .cover {
                let result = item.viewModel.sections.first { (section: FilmDetailViewModel.FilmDetailSectionModel) -> Bool in
                    return section.type == .price
                }
                if let section = result {
                    showAlertExpired(section.rows[0])
                } else {
                    presenter?.onSelectItem(sectionModel.type, indexPath.item)
                }
            } else {
                presenter?.onSelectItem(sectionModel.type, indexPath.item)
            }
        }
    }
}

extension FilmDetailView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = (Constants.screenWidth/16)*9
        headerView.backgroundColor = scrollView.contentOffset.y > offset ? AppColor.hex000001Color() : UIColor.clear
    }
}

extension FilmDetailView: FilmRelatedCollectionReusableViewDelegate {
    func selectPickerSeason(season: SeasonDTO) {
        
    }
    func selectPickerSeason(index: Int, id: Int) {
        presenter?.onSelectSeason(id: id)
        let model = (presenter as! FilmDetailPresenter).viewModel
        model.detailModel?.seasonIndex = index
        
    }
    func filmRelatedCollection(_ sectionView: FilmRelatedCollectionReusableView, selectedSeason: String) {
        let pickerView = PickerSeasonVc.initWithNib()
        //        self.present(pickerView, animated: true, completion: nil)
        let nav = BaseNavigationViewController(rootViewController: pickerView)
        nav.modalPresentationStyle = .overCurrentContext
        pickerView.delegate = self
        if let model = (presenter as! FilmDetailPresenter).viewModel.detailModel {
        pickerView.viewModel = model
        }
        self.present(nav, animated: false, completion: nil)
    }
    
    func filmRelatedCollection(_ sectionView: FilmRelatedCollectionReusableView, selectedType: FilmDetailSectionType) {
        DLog("selectedType \(selectedType)")
        presenter?.doChangeDisplay(selectedType)
    }
}

extension FilmDetailView: PlayerViewDelegate {
    func didSelectPart(_ model: PartModel) {
        presenter?.didSelectPart(model)
    }
}

