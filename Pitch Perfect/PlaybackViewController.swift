//
//  PlaybackViewController.swift
//  Pitch Perfect
//
//  Created by Nazim Amin on 1/29/15.
//  Copyright (c) 2015 sensnoia. All rights reserved.
//

import UIKit
import AVFoundation

class PlaybackViewController: UIViewController {
    
    @IBOutlet weak var playBackSnailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var DarthvaderButton: UIButton!

    //Declared globally within PlaySoundsViewController
    var audioEngine: AVAudioEngine!
    var avAudioFile: AVAudioFile!
    var recievedAudio: RecordedAudio!
    
    var audioPlayer:AVAudioPlayer!
    var newPauseImage = UIImage();
    var newPlayImage = UIImage();
     var audioPlayerNode = AVAudioPlayerNode()
    
    var newAudioPlayer:AVAudioPlayer!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        avAudioFile = AVAudioFile(forReading: recievedAudio.filePathUrl, error: nil)
        
        //this is my legacy code, if I wanted to play hard coded file
      /*  if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
            
            var fileUrl = NSURL.fileURLWithPath(filePath);
            
            audioPlayer = AVAudioPlayer(contentsOfURL: fileUrl, error: nil);
            audioPlayer.enableRate = true;
            audioPlayer.prepareToPlay();
        }
        else{
            println("the file path is empty\n");
        }*/
        
        //audio engine obj
        audioEngine = AVAudioEngine()
        
        //this is the new code fot the file as we read. filepathUrl and type was set previously. 
        
        audioPlayer = AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl, error: nil);
        audioPlayer.enableRate = true;
        audioPlayer.prepareToPlay();
        
        //loading an image that I will change later in the function
        newPauseImage = UIImage(named: "pauseButton") as UIImage!
        newPlayImage = UIImage(named: "playButton") as UIImage!
        newAudioPlayer = AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl, error: nil);
        newAudioPlayer.prepareToPlay()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    */

    //this is a play audio fucntion for non-repetitive calls
    func playAudio(speed: Float){
        if audioPlayer.playing{
            audioPlayer.stop()
            audioPlayer.currentTime = 0.0;
        }
        
        audioPlayer.rate = speed
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    //echo effect
    @IBAction func echoEffect(sender: UIButton) {
   
    
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
        var delay: NSTimeInterval = 0.2
        var newPlayTime:NSTimeInterval
        newPlayTime = newAudioPlayer.deviceCurrentTime + delay
        newAudioPlayer.volume = 0.7
        newAudioPlayer.playAtTime(newPlayTime)
    }
    
    @IBAction func playBackSnail(sender: UIButton) {
        playAudio(0.5)
    }
    @IBAction func fastPlayBack(sender: UIButton) {
        playAudio(2.0)
    }
    
    @IBAction func stopAllAudio(sender: UIButton) {
        if(audioPlayer.playing || audioEngine.running){
            audioPlayer.stop()
            audioEngine.stop()
            audioPlayer.currentTime = 0.0
        }
    }
    //this will pause any audio and then will change the icon dynamacilly to play and vice-versa
    @IBAction func pauseButton(sender: UIButton) {
        
        if(audioPlayer.playing || audioEngine.running){
            audioPlayer.pause()
            audioEngine.pause()
            sender.setImage(newPlayImage, forState: UIControlState.Normal);
        }else if (!audioPlayer.playing){
            sender.setImage(newPauseImage, forState: UIControlState.Normal)
            audioPlayer.play()
        }
    }
    
    //changing pitch for chipmunk
    
    @IBAction func chipmunkEffect(sender: UIButton) {
        playWithEffectPitch(1000.0)
    }
    
    
    @IBAction func DarthvaderEffect(sender: UIButton) {
        playWithEffectPitch(-1000)
    }
    func playWithEffectPitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
    
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
    
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
    
        audioPlayerNode.scheduleFile(avAudioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    
}
