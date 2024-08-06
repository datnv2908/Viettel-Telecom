//
// Microphone.swift
//
// Copyright (c) 2015-2016 Damien (http://delba.io)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import AVFoundation

enum MicroPermission {
    case denied
    case authorized
    case notDetermined
}

class AppPermission: NSObject {
    class var statusMicrophone: MicroPermission {
        let status = AVAudioSession.sharedInstance().recordPermission
        
        switch status {
        case AVAudioSession.RecordPermission.denied:  return .denied
        case AVAudioSession.RecordPermission.granted: return .authorized
        default:                                     return .notDetermined
        }
    }
    
    class func requestMicrophone(_ callback: @escaping((_ status: MicroPermission)->Void)) {
        AVAudioSession.sharedInstance().requestRecordPermission { _ in
            let status = AppPermission.statusMicrophone
            callback(status)
        }
    }
}