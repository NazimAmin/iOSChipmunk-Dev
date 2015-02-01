//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Nazim Amin on 1/29/15.
//  Copyright (c) 2015 sensnoia. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingProgress: UILabel!
    
    @IBOutlet weak var stopRecord: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    var recordedAudio: RecordedAudio! //object of RecordedAudio.swift
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        stopRecord.hidden = true;
    }

    @IBAction func recordStart(sender: UIButton) {
        recordingProgress.hidden = false;
        stopRecord.hidden = false;

        //Inside func recordAudio(sender: UIButton)
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()

    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        println("breaking here on audioFinished")
        if(flag){
        //save the recorded audio
        recordedAudio = RecordedAudio()
        recordedAudio.filePathUrl = recorder.url
        recordedAudio.title = recorder.url.lastPathComponent
        
        //perform a segue to the next UIController
        self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording wasn't successful");
            recordButton.enabled = true
            stopRecord.hidden = true
        }
    }
    //this gets called right before performing the transition to the new viewcontroller
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording"{
            let playSoundVC:PlaybackViewController = segue.destinationViewController as PlaybackViewController
            let data = sender as RecordedAudio
            playSoundVC.recievedAudio = data
            println("breaking here on prepareForSegue")
        }
    }
    @IBAction func stopRecording(sender: UIButton) {
        recordingProgress.hidden = true;
        stopRecord.hidden = true;
        recordButton.enabled = true;
        
        //stop recording
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

