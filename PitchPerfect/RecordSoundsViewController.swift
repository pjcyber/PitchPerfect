//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Pjcyber on 2/23/20.
//  Copyright © 2020 Pjcyber. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    // MARK: - Properties
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        stopRecordingButton.isEnabled = false
    }
    
    // MARK: - Recording Audio
    
    @IBAction func recordAudio(_ sender: Any) {
        setRecording(true)
        
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
    
    // MARK: - Stop Recording session
    
    @IBAction func stopRecording(_ sender: Any) {
        setRecording(false)
        audioRecorder.stop()
        let audoiSession = AVAudioSession.sharedInstance()
        try! audoiSession.setActive(false)
    }
    
    // MARK: - Audio Recorder Delegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            // configuring segue
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    // MARK: - Adding a segue and passing the recordedAudioURL
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func setRecording(_ recording: Bool) {
        if recording {
            recordingLabel.text = "Recording in progress"
            recordButton.isEnabled = !recording
            stopRecordingButton.isEnabled = recording
        } else {
            recordingLabel.text = "Tap to Recording"
            recordButton.isEnabled = !recording
            stopRecordingButton.isEnabled = recording
        }
    }
}

