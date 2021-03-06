//
//  ViewController.swift
//  Downloading data in background
//
//  Created by Domenico Solazzo on 16/05/15.
//  License MIT
//

import UIKit

class ViewController: UIViewController, NSURLSessionDelegate,
        NSURLSessionDownloadDelegate, NSURLSessionTaskDelegate {

    // Session object
    var session: NSURLSession!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let configuration = NSURLSessionConfiguration.backgroundSessionConfiguration(configurationIdentifier)
        configuration.timeoutIntervalForRequest = 15
        
        session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var url = NSURL(string: "http://goo.gl/mf9xj3")
        var task = session.downloadTaskWithURL(url!)
        task.resume()
    }
    
    //- MARK: URLSession delegates
    // This method indicates if we received new data
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        println("Received data")
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        print("Finished...")
        
        if error == nil{
            println("...without error")
        }else{
            println("...with error. Error \(error)")
        }
        
        session.finishTasksAndInvalidate()
    }
    
    func URLSession(session: NSURLSession,
        downloadTask: NSURLSessionDownloadTask,
        didFinishDownloadingToURL location: NSURL){
            println("Finished writing the downloaded content to URL = \(location)")
    }
    //- MARK: Computer properties
    /* This computed property will generate a unique identifier for our
    background session configuration. The first time it is used, it will get
    the current date and time and return that as a string to you. It will
    also save that string into the system defaults so that it can retrieve
    it the next time it is called. This computed property's value
    is persistent between launches of this app.
    */
    var configurationIdentifier: String{
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var key = "configurationIdentifier"
        let previousValue = userDefaults.stringForKey(key) as String?
        
        if previousValue != nil{
            return previousValue!
        }else{
            let newValue = NSDate().description
            userDefaults.setObject(newValue, forKey: key)
            userDefaults.synchronize()
            return newValue
        }
    }
    //- MARK: Helper Methods
    func showAlertWithTitle(title:String, message:String){
        var controller = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(controller, animated: true, completion: nil)
    }
}

