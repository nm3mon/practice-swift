//
//  ViewController.swift
//  Capturing Thumbnails from Video Files
//
//  Created by Domenico on 23/05/15.
//  License MIT
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    var moviePlayer: MPMoviePlayerController?
    var playButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton = UIButton.buttonWithType(.System) as? UIButton
        
        if let button = playButton{
            
            /* Add our button to the screen. Pressing this button
            will start the video playback */
            button.frame = CGRect(x: 0, y: 0, width: 70, height: 37)
            button.center = view.center
            
            button.autoresizingMask =
                .FlexibleTopMargin |
                .FlexibleLeftMargin |
                .FlexibleBottomMargin |
                .FlexibleRightMargin
            
            button.addTarget(self,
                action: "startPlayingVideo",
                forControlEvents: .TouchUpInside)
            
            button.setTitle("Play", forState: .Normal)
            
            view.addSubview(button)
            
        }
    }
    func videoHasFinishedPlaying(notification: NSNotification){
        
        println("Video finished playing")
        
        /* Find out what the reason was for the player to stop */
        let reason =
        notification.userInfo![MPMoviePlayerPlaybackDidFinishReasonUserInfoKey]
            as! NSNumber?
        
        if let theReason = reason{
            
            let reasonValue = MPMovieFinishReason(rawValue: theReason.integerValue)
            
            switch reasonValue!{
            case .PlaybackEnded:
                /* The movie ended normally */
                println("Playback Ended")
            case .PlaybackError:
                /* An error happened and the movie ended */
                println("Error happened")
            case .UserExited:
                /* The user exited the player */
                println("User exited")
            default:
                println("Another event happened")
            }
            
            println("Finish Reason = \(theReason)")
            stopPlayingVideo()
        }
        
    }

    func videoThumbnailIsAvailable(notification: NSNotification){
        
        if let player = moviePlayer{
            println("Thumbnail is available")
            
            /* Now get the thumbnail out of the user info dictionary */
            let thumbnail =
            notification.userInfo![MPMoviePlayerThumbnailImageKey] as? UIImage
            
            if let image = thumbnail{
                
                /* We got the thumbnail image. You can now use it here */
                println("Thumbnail image = \(image)")
                
            }
        }
        
    }
    
    func stopPlayingVideo() {
        
        if let player = moviePlayer{
            NSNotificationCenter.defaultCenter().removeObserver(self)
            player.stop()
            player.view.removeFromSuperview()
        }
        
    }
    
    func startPlayingVideo(){
        
        /* First let's construct the URL of the file in our application bundle
        that needs to get played by the movie player */
        let mainBundle = NSBundle.mainBundle()
        
        let url = mainBundle.URLForResource("Sample", withExtension: "m4v")
        
        /* If we have already created a movie player before,
        let's try to stop it */
        if let player = moviePlayer{
            stopPlayingVideo()
        }
        
        /* Now create a new movie player using the URL */
        moviePlayer = MPMoviePlayerController(contentURL: url)
        
        if let player = moviePlayer{
            
            /* Listen for the notification that the movie player sends us
            whenever it finishes playing */
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "videoHasFinishedPlaying:",
                name: MPMoviePlayerPlaybackDidFinishNotification,
                object: nil)
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "videoThumbnailIsAvailable:",
                name: MPMoviePlayerThumbnailImageRequestDidFinishNotification,
                object: nil)
            
            println("Successfully instantiated the movie player")
            
            /* Scale the movie player to fit the aspect ratio */
            player.scalingMode = .AspectFit
            
            view.addSubview(player.view)
            
            player.setFullscreen(true, animated: true)
            
            /* Let's start playing the video in full screen mode */
            player.play()
            
            /* Capture the frame at the third second into the movie */
            let thirdSecondThumbnail = 3.0
            
            /* We can ask to capture as many frames as we
            want. But for now, we are just asking to capture one frame
            Ask the movie player to capture this frame for us */
            player.requestThumbnailImagesAtTimes([thirdSecondThumbnail],
                timeOption: .NearestKeyFrame)
            
        } else {
            println("Failed to instantiate the movie player")
        }
        
    }
}

