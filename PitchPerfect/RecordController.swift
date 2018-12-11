//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Muhammad El-Badawy on 12/9/18.
//  Copyright © 2018 Muhammad El-Badawy. All rights reserved.
//

import UIKit
import AVFoundation

class RecordController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    
    @IBAction func onRecord(_ sender: Any) {
        recordingAudio(recording: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    @IBAction func onStop(_ sender: Any) {
        recordingAudio(recording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        guard segue.identifier == "stopRecording" else { return }
        guard let playSoundsVC = segue.destination as? PlayerSoundsViewController else { return }
        guard let recordedAudioURL = sender as? URL else { return }
        playSoundsVC.recordedAudioURL = recordedAudioURL
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isEnabled = false
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        flag ?
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url) :
            print("somthing went wrong !!!")
    }
    func recordingAudio(recording: Bool){
        recordLabel.text = recording ? "Recording in Progress" : "Tap to Record"
        stopButton.isEnabled = recording
        recordButton.isEnabled = !recording
    }
}

