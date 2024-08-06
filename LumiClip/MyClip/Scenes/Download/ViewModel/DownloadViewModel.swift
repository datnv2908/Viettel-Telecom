//
//  DownloadViewModel.swift
//  MyClip
//
//  Created by hnc on 12/19/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
struct DownloadViewModel {
    var sections = [SectionModel]()
    var downloadedVideos = [DownloadModel]()
    init() {
        sections = [SectionModel]()
        var downloadingRows = [VideoRowModel]()
        for item in DownloadManager.shared.downloadingVideos {
            downloadingRows.append(VideoRowModel(model: item, identifier: DownloadVideoTableViewCell.nibName()))
        }
        let header = HeaderModel(title: "\(String.dang_tai_xuong.uppercased()) (\(DownloadManager.shared.downloadingVideos.count))", identifier: UploadHeaderView.nibName())
        let downloadingSection = SectionModel(rows: downloadingRows, header: header)

        var downloadedRows = [VideoRowModel]()
        downloadedVideos = DownloadManager.shared.getAllDownloadedVideo()
        for item in downloadedVideos {
            downloadedRows.append(VideoRowModel(model: item, identifier: VideoSmallImageTableViewCell.nibName()))
        }
        let downloadedSection = SectionModel(rows: downloadedRows)

        sections.append(downloadingSection)
        sections.append(downloadedSection)
    }
}
