//
//  RowModel.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer
import AVKit

class RowModel: PBaseRowModel {
    var id: String = ""
    var title: String = ""
    var desc: String = ""
    var imageUrl: String = ""
    var identifier: String = ""
    var contentType: ContentType = ContentType.film
    var percent: Double = 0.0
    var duration: String = ""
    var trailer: Int = 0
    var price: Int?
    var isShowPrice: Bool = false
    var film: FilmModel?
    var trailerStreamModel: StreamModel?
    var trailerItem: AVPlayerItem?
    var descFilm: String
    private let service: FilmService = FilmService()
    
    init(blockType: BlockType, model: FilmModel?) {
        identifier  = blockType.rowIdentifier()
        if let item = model {
            if blockType == .watching {
                desc = item.duration
            } else {
                desc = item.desc
                imageUrl    = item.coverImage
            }
            
            id      = item.id
            title   = item.name
            imageUrl = item.coverImage
            contentType = item.contentType
            percent     = item.durationPercent
            duration    = item.duration
            trailer     = item.trailer
            price       = model?.price
            film        = model
            
        }
        descFilm = "" 
    }
    
    func setBlockType(blockType: BlockType) {
        self.identifier  = blockType.rowIdentifier()
    }

     func getTrailerComplete(comletion: @escaping((_ playerItem: AVPlayerItem) -> Void), failse:@escaping(() -> Void)) {
        weak var weakSelf = self
        
        if let item = trailerItem {
            comletion(item)
            return
        }

        if trailer != 0 {
            service.getVideoTrailer(ItemId: "\(trailer)") { (result) in
                switch result {
                case .success(let _videotrailerModel):
                    if let streamModel = _videotrailerModel as? StreamModel {
                        weakSelf?.trailerStreamModel = streamModel
                        
                        if let url = URL(string: streamModel.urlStreaming) {
                            let asset = AVAsset(url: url)
                            asset.loadValuesAsynchronously(forKeys: ["duration"], completionHandler: {
                                DispatchQueue.main.async {
                                    let movieItem = AVPlayerItem(asset: asset)
                                    weakSelf?.trailerItem = movieItem
                                    comletion(movieItem)
                                }
                            })
                        }
                    }
                    break
                case .failure(let err):
                    failse()
                    break
                }
            }
        }
    }

    func updateTrailerStreamModel(_ item: StreamModel) {
        self.trailerStreamModel = item
    }
}
