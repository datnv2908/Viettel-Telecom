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
 - int_time: thời gian chờ đến thời điểm bắt đầu xem
 */
import UIKit

class KPIModel: NSObject {
    var isChanged = false
    var isBuffering = false
    var isPlaying = false
    var token: String = ""
    var watchingDuration: Double = 0 {
        didSet {
            isChanged = true
        }
    }
    var bufferTimesOverThreeSe: Int = 0 {
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
    var currentTime: Double = 0.0 {
        didSet {
            isChanged = true
        }
    }
    
    var initTimes: Double = 0 {
        didSet {
            isChanged = true
        }
    }
    
    var currentBufferingDuration = 0.0
    var currentWatchingDuration = 0.0
    // private attributes
    var bufferingStartTime = Date()
    var watchingStartTime = Date()
    var initStartTime = Date()
    
    var bandWidth: Double = 0
    var bandWidthAvg: Double = 0
    
    override init() {
        token = ""
        watchingDuration = 0.0
        pauseTimes = 0
        seekTimes = 0
        waitTimes = 0
        bufferingDuration = 0.0
        currentTime = 0
        initTimes = 0
        bandWidth = 0.0
        bandWidthAvg = 0.0
        initStartTime = Date()
    }
    
    init(with token: String) {
       self.token = token
        watchingDuration = 0.0
        pauseTimes = 0
        seekTimes = 0
        waitTimes = 0
        bufferingDuration = 0.0
        currentTime = 0
        initTimes = 0
        bandWidth = 0.0
        bandWidthAvg = 0.0
        initStartTime = Date()
    }
    
    func startBuffering() {
        if(initTimes == 0){
            initStartTime = Date()
        }
        bufferingStartTime = Date()
        isBuffering = true
    }
    
    func stopBuffering() {
        if(isBuffering){
            let finishTime = Date()
            let duration = finishTime.timeIntervalSince(bufferingStartTime)
            if(duration > 3){
                bufferTimesOverThreeSe += 1
            }
            bufferingDuration += duration
            isBuffering = false
        }
    }
    
    func startWatching() {
        watchingStartTime = Date()
        isPlaying = true
        if(initTimes == 0){
            initTimes = Double(watchingStartTime.timeIntervalSince(initStartTime))
        }
    }
    
    func stopWatching() {
        let finishTime = Date()
        let duration = finishTime.timeIntervalSince(watchingStartTime)
        watchingDuration += duration
        isPlaying = false
    }
    
    func toDictionary() -> [String: String] {
        var param = [String: String]()
        param["token"] = token
        param["duration_watching"] = "\(watchingDuration)"
        param["pause_times"] = "\(pauseTimes)"
        param["seek_times"] = "\(seekTimes)"
        param["wait_times"] = "\(waitTimes)"
        param["duration_buffer"] = "\(bufferingDuration)"
        param["current_time"] = "\(currentTime)"
        param["init_time"] = "\(initTimes)"
        param["bandwidth"] = "\(bandWidth)"
        param["bandwidth_avg"] = "\(bandWidthAvg)"
        param["buffer_times_over_3s"] = "\(bufferTimesOverThreeSe)"
        return param
    }
}
