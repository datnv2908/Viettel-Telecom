//
//  SearchVoiceViewController.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 10/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import Speech

@available(iOS 10.0, *)
class SearchVoiceViewController: BaseViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var resultTextField: UITextField!
    var delegate: PassVoiceResultProtocol!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.current)
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine = AVAudioEngine()
    var timer: Timer?
    var isTalkedTimer: Timer?
    var animationTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        customPlaceholderTextField(string: String.startSpeech)
        recordButton.isSelected = false
        recordButton.isEnabled = false
        speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            var isButtonEnable = false
            switch authStatus {
            case .authorized:
                isButtonEnable = true
            case .denied:
                isButtonEnable = false
            case .notDetermined:
                isButtonEnable = false
            case .restricted:
                isButtonEnable = false
            }
            OperationQueue.main.addOperation {
                self.recordButton.isEnabled = isButtonEnable
                self.onRecord()
            }
        }
    }
    
    @IBAction func onRecord() {
        if audioEngine.isRunning {
            stopAnimation()
            finishedRecord()
        } else {
            startRecording()
        }
    }
    
    func startRecording() {
        startAnimation()
        customPlaceholderTextField(string: String.startSpeech)
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.default)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {return}
        recognitionRequest.shouldReportPartialResults = true
        
        //set timer for starting talk
        isTalkedTimer?.invalidate()
        isTalkedTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
            self.customPlaceholderTextField(string: String.noSpeechSearchVoice)
            self.endRecognitionRequest()
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            //stop isTalkedTimer if talked
            if self.isTalkedTimer != nil {
                self.isTalkedTimer?.invalidate()
                self.isTalkedTimer = nil
            }
            var isFinal = false
            var text: String?
            if result != nil {
                text = result?.bestTranscription.formattedString
                self.resultTextField.text = text
                isFinal = (result?.isFinal)!
            }
            if error != nil || isFinal {
                self.finishedRecord()
            } else if error == nil {
                //set timer to end record
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                    self.finishedRecord()
                })
            }
        })
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            
        }
        recordButton.isSelected = true
    }
    
    @IBAction func onCancel(_ sender: UIButton) {
        endRecognitionRequest()
        dismiss(animated: true, completion: nil)
    }
    
    private func finishedRecord() {
        endRecognitionRequest()
        self.delegate.passVoiceResult(textField: self.resultTextField)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func endRecognitionRequest() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback)
        } catch {
            
        }
        let inputNode = audioEngine.inputNode
        inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask = nil
        recordButton.isEnabled = true
        recordButton.isSelected = false
        timer?.invalidate()
        timer = nil
        isTalkedTimer?.invalidate()
        isTalkedTimer = nil
        stopAnimation()
    }
    
    private func customPlaceholderTextField(string: String) {
        resultTextField.attributedPlaceholder =
            NSAttributedString(string: string,
                               attributes: [NSAttributedString.Key.foregroundColor: AppColor.warmGreyTwo(),
                                            NSAttributedString.Key.font: SFUIDisplayFont.fontWithType(.light, size: 20)])
    }
    
    //MARK: Animation
    func startAnimation() {
        animationTimer = Timer.scheduledTimer(timeInterval: 1,
                                              target: self,
                                              selector: #selector(addPulse),
                                              userInfo: nil,
                                              repeats: true)
    }
    
    @objc func addPulse() {
        let pulse = Pulsing(numberOfPulses: 1, radius: 200, position: recordButton.center)
        pulse.animationDuration = 5
        self.view.layer.insertSublayer(pulse, below: recordButton.layer)
    }

    func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    deinit {
        endRecognitionRequest()
        DLog("")
    }
}

@available(iOS 10.0, *)
extension SearchVoiceViewController: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
        } else {
            recordButton.isEnabled = false
        }
    }
}

protocol PassVoiceResultProtocol {
    func passVoiceResult(textField: UITextField)
}
