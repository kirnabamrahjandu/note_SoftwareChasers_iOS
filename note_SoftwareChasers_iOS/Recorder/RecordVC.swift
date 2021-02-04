//
//  RecordVC.swift
//  note_SoftwareChasers_iOS
//
//  Created by user191875 on 2/4/21.
//

import UIKit
import AVKit
class RecordVC: UIViewController,AVAudioRecorderDelegate {
    @IBOutlet weak var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioFilename : URL?
    var bombSoundEffect: AVAudioPlayer?
    var newNoteVc : NewNoteVC?
    override func viewDidLoad() {
        super.viewDidLoad()
        recorderSettingUp()
    }
    
   
    @IBAction func handlePlay(_ sender: Any) {
        if let url = audioFilename{
            do {
                bombSoundEffect = try AVAudioPlayer(contentsOf: url)
                bombSoundEffect?.play()
                print("Playing")
            } catch {
                 print("couldn't load file :(")
            }
        }
       
    }
    @IBAction func handleSave(_ sender: Any) {
        if let file = audioFilename{
            guard let vc = newNoteVc else {return}
            vc.audioRecordingSet(file: file.absoluteString)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    @IBAction func Handlestop(_ sender: Any) {
        bombSoundEffect?.stop()
    }
    func recorderSettingUp(){
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                    }
                }
            }
        } catch {
        }
    }
    func loadRecordingUI(){
        recordButton.setTitle("Press & Record", for: .normal)
        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
    }
    func startRecording() {
        try! recordingSession.setCategory(.record)
         audioFilename = getDocumentsDirectory().appendingPathComponent("\(UUID().uuidString).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename!, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            recordButton.setTitle("Press & Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            recordButton.setTitle("Press & Re-record", for: .normal)
        } else {
            recordButton.setTitle("Press & Record", for: .normal)
            // recording failed :(
        }
    }
    @objc func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print(audioFilename?.absoluteURL ?? "")
        print(audioFilename?.absoluteString ?? "")
        print(audioFilename?.relativeString ?? "")
        if !flag {
            finishRecording(success: false)
        }
        try! recordingSession.setCategory(.playback)
    }
}

