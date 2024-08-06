//
//  ListEpisodeViewController.swift
//  5dmax
//
//  Created by Gem on 3/30/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol ListEpisodeViewDelegate: NSObjectProtocol {
    func listEpisodeView(_ viewcontroller: ListEpisodeViewController, didSelectPart part: PartModel)
}

@objcMembers
class ListEpisodeViewController: BaseViewController {

    weak var delegate: ListEpisodeViewDelegate?

//    fileprivate var playListModel: PlayListModel
    fileprivate var viewModel: ListEpisodeViewModel
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var seasionView: UIView!
    
    init(_ playListModel: PlayListModel) {
//        self.playListModel = playListModel
        viewModel = ListEpisodeViewModel(playListModel)
        super.init(nibName: "ListEpisodeViewController", bundle: Bundle.main)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "MovieEpsiodeCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "episodeCell")
        settupView()
        viewModel.onReloadData = {[weak self] in
            self?.settupView()
            self?.collectionView.reloadData()
        }
        viewModel.onError = {[weak self] error in
            self?.toast(error)
        }
        viewModel.toggleLoading = {[weak self] loading in
            if loading {
                self?.showHud()
            } else {
                self?.hideHude()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //Find current playing part
        let currentIndex = viewModel.currentIndex
        if viewModel.playList?.parts.isEmpty == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
                self.collectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0),
                                                 at: UICollectionView.ScrollPosition.centeredHorizontally,
                                                 animated: false)
            })
        }
    }
    
    func settupView() {

        guard let seasonId = viewModel.playList?.idSeasonSelected,
              let seasons = viewModel.playList?.lisSeasons, !seasons.isEmpty, viewModel.playList?.detail.attributes == .series else {
            seasionView.isHidden = true
            return
        }
        let seasonSelecteds = seasons.filter({ (item) in
            return item.id == seasonId
        })
        if !seasons.isEmpty {
            lbTitle.text = seasonSelecteds[0].name
        }
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectSeasonAction(_ sender: Any) {
        let pickerView = PickerSeasonVc.initWithNib()
        let nav = BaseNavigationViewController(rootViewController: pickerView)
        nav.modalPresentationStyle = .overCurrentContext
        pickerView.delegate = self
        pickerView.viewModel = self.viewModel.playList
        self.present(nav, animated: false, completion: nil)
    }

    func canRotate() {}

}

extension ListEpisodeViewController: PickerSeasonDelegate {
    func selectPickerSeason(index: Int, id: Int) {
        viewModel.onSelectSeason(id: id)
        viewModel.playList?.seasonIndex = index
    }
}

extension ListEpisodeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.playList?.parts.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "episodeCell",
                                                      for: indexPath) as! MovieEpsiodeCollectionViewCell
        let part = viewModel.playList!.parts[indexPath.item]
        let currentIndex = viewModel.currentIndex
        cell.bindData(part, indexPath.item == currentIndex)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            delegate.listEpisodeView(self, didSelectPart: viewModel.playList!.parts[indexPath.item])
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension ListEpisodeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return MovieEpsiodeCollectionViewCell.sizeOfCell()
    }
}
