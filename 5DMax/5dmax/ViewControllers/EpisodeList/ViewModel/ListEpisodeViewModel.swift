//
//  ListEpisodeViewModel.swift
//  5dmax
//
//  Created by Huy Nguyen on 4/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation

class ListEpisodeViewModel {
    
    var currentIndex: Int = 0
    var title: String?
    var playList: PlayListModel?
    var service: FilmService = FilmService()
    
    var onReloadData: (() -> Void)?
    var toggleLoading: ((Bool)->Void)?
    var onError: ((String) -> Void)?
    
    init(_ playListModel: PlayListModel) {
        for (index, item ) in playListModel.parts.enumerated() {
            if item.partId == playListModel.detail.getCurrentVideoId() {
                currentIndex = index
            }
        }
        title = playListModel.detail.name
        self.playList = playListModel
    }
    
    func onSelectSeason(id : Int) {
        
        getRelateFilmBySeason("\(id)", completion: { (result) in
            switch result {
            case .success(let json):
                    self.playList!.parts = json
                    self.playList?.idSeasonSelected = id
                    self.currentIndex = 0
                    self.onReloadData?()
            case .failure(let err):
                self.onError?(err.localizedDescription)
                break
            }
        })
    }
    
    func getRelateFilmBySeason(_ itemId: String, completion: @escaping (Result<[PartModel]>) -> Void) {
        self.toggleLoading?(true)
        service.getRelateFilmBySeason(id: itemId) { [weak self] (json, error) in
            self?.toggleLoading?(false)
            if let err = error {
                completion(Result.failure(err as! Error))
            }else{
                var parts = [PartModel]()
                for subJson in json["parts"].arrayValue {
                    let modelOTD = PartDTO(subJson)
                    let model = PartModel(modelOTD)
                    parts.append(model)
                }
                completion(Result.success(parts))
            }
            
        }
    }
}
