//
//  AppDelegate.swift
//  Detecting the Availability of the Accelerometer
//
//  Created by Domenico on 21/05/15.
//  License MIT
//

import UIKit
import CoreMotion

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        let motionManager = CMMotionManager()
        
        // Check if the accelerometer is available
        if motionManager.accelerometerAvailable{
            println("The accelerometer is available")
        }else{
            println("The accelerometer is not available")
        }
        
        // Check if the acceleromter is active
        if motionManager.accelerometerActive{
            println("The accelerometer is active")
        }else{
            println("The accelerometer is not active")
        }
        
        return true
    }
}

