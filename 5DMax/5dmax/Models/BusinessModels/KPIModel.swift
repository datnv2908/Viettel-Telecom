//
//  TraceModel.swift
//  MyClip
//
//  Created by hnc on 11/1/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

/*
 Header:
 -    Authorization: Có (Không bắt buộc)
 Params:
 - token: mã token nhận được ở API init
 - duration_watching: tổng thời gian đã xem (đơn vị giây)
 - pause_times: số lần pause
 - seek_time: số lần tua
 - wait_time: số lần chờ buffer
 - duration_buffer: Tổng thời gian chờ buffer
 - current_time: thời điểm đang xem hiện tại
 */
import UIKit

 @objc class KPIModel: NSObject {
    var isChanged = false
    var isBuffering = false
    var isPlaying = false
    var token: String = ""
    var contentId: String = ""
    var contentType: String = ""
    var playUrl: String = ""
    var watchingDuration: Double = 0 {
        didSet {
            isChanged = true
        }
    }
    var pauseTimes: Int = 0 {
        didSet {
            isChanged = true
        }
    }
    var seekTimes: Int = 0 {
        didSet {
            isChanged = true
        }
    }
    var waitTimes: Int = 0 {
        didSet {
            isChanged = true
        }
    }
    var bufferingDuration: Double = 0 {
        didSet {
            isChanged = true
        }
    }
    var sendTime: Double = 0.0 {
        didSet {
            isChanged = true
        }
    }
    var currentBufferingDuration = 0.0
    var currentWatchingDuration = 0.0
    // private attributes
    lazy var bufferingStartTime = Date()
    lazy var watchingStartTime = Date()
    override init() {
        token = ""
        watchingDuration = 0.0
        pauseTimes = 0
        seekTimes = 0
        waitTimes = 0
        bufferingDuration = 0.0
        sendTime = 0
    }
    
    init(with token: String) {
        self.token = token
        watchingDuration = 0.0
        pauseTimes = 0
        seekTimes = 0
        waitTimes = 0
        bufferingDuration = 0.0
        sendTime = 0
    }
    
    func startBuffering() {
        bufferingStartTime = Date()
        isBuffering = true
    }
    
    func stopBuffering() {
        let finishTime = Date()
        let duration = finishTime.timeIntervalSince(bufferingStartTime)
        bufferingDuration += duration
        isBuffering = false
    }
    
    func startWatching() {
        watchingStartTime = Date()
        isPlaying = true
    }
    
    func stopWatching() {
        let finishTime = Date()
        let duration = finishTime.timeIntervalSince(watchingStartTime)
        watchingDuration += duration
        isPlaying = false
    }
    
    func toDictionary() -> [String: String] {
        var param = [String: String]()
        sendTime += 1
        param["video_id"] = contentId
//        param["content_type"] = contentType
        param["play_url"] = playUrl
        param["trace_key"] = token
        param["duration_watch"] = "\(watchingDuration)"
        param["pause_times"] = "\(pauseTimes)"
        param["seek_times"] = "\(seekTimes)"
        param["wait_times"] = "\(waitTimes)"
        param["os_type"] = "iOS"
        param["duration_waiting"] = "\(bufferingDuration)"
        param["send_times"] = "\(sendTime)"
        param["duration_buffer"] = "0"
        return param
    }
}

