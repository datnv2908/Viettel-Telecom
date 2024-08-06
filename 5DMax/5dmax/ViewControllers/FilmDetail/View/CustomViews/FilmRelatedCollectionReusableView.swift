//
//  FilmRelatedCollectionReusableView.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/17/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol FilmRelatedCollectionReusableViewDelegate {
    func filmRelatedCollection(_ sectionView: FilmRelatedCollectionReusableView, selectedType: FilmDetailSectionType)
    func filmRelatedCollection(_ sectionView: FilmRelatedCollectionReusableView, selectedSeason: String)
}

class FilmRelatedCollectionReusableView: FilmBaseCollectionReusableView {
    
    var playlistModel: PlayListModel?
    var presenter: FilmDetailPresenterProtocol?
    var delegate: FilmRelatedCollectionReusableViewDelegate?
    var isSeasonFilm : Bool = false
    var lisSeasonFilm : PlayListModel?
    @IBOutlet weak var viewRelated: UIView!
    @IBOutlet weak var viewTrailers: UIView!
    @IBOutlet weak var relatedButton: UIButton!
    @IBOutlet weak var trailerButton: UIButton!
    
    @IBOutlet weak var seasonView: UIView!
    @IBOutlet weak var seasonLb: UILabel! 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewTrailers.isHidden = true
        relatedButton.setTitle(String.phim_lien_quan.uppercased(), for: .normal)
        trailerButton.setTitle(String.trailers.uppercased(), for: .normal)
        relatedButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.bold)
        
       
        
    }
    func getListModel (model : PlayListModel) {
        self.seasonLb.text = model.lisSeasons[model.seasonIndex].name
    }
    @IBAction func tabTrailersButton(_ sender: Any) {
        trailerButton.setTitleColor(.white, for: .normal)
        relatedButton.setTitleColor(.darkGray, for: .normal)
        trailerButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.bold)
        relatedButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.regular)
        viewRelated.isHidden = true
        viewTrailers.isHidden = false
        seasonView.isHidden = true
        delegate?.filmRelatedCollection(self, selectedType: FilmDetailSectionType.trailer)
    }
    func isSeason( isSeason : Bool) {
        if !viewTrailers.isHidden {
            // if is on trailder tab then not set
            return
        }
        self.seasonView.isHidden = !isSeason
    }
    @IBAction func tabRelatedButton(_ sender: Any) {
        relatedButton.setTitleColor( .white, for: .normal)
        trailerButton.setTitleColor(.darkGray, for: .normal)
        relatedButton.titleLabel?.font = AppFont.museoSanFont(style: .bold, size: 15)
        trailerButton.titleLabel?.font =  AppFont.museoSanFont(style: .bold, size: 15)
        viewRelated.isHidden = false
        viewTrailers.isHidden = true
        seasonView.isHidden = false
        delegate?.filmRelatedCollection(self, selectedType: FilmDetailSectionType.related)
    }
    @IBAction func changeSeason(_ sender: Any) {
        delegate?.filmRelatedCollection(self, selectedSeason: "")
    }
    
    override func bindingWithModel(_ model: FilmDetailViewModel.FilmDetailSectionModel) {
        relatedButton.setTitle(model.title, for: UIControl.State.normal)
       
    }
//    func UpdateSeasonDelegate(season: SeasonDTO) {
//        self.seasonLb.text = season.name
//    }
    
    
}
