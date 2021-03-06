//
//  ViewController.swift
//  Pinpointing the Location of a Device
//
//  Created by Domenico Solazzo on 18/05/15.
//  License MIT
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    // Private variables
    var locationManager: CLLocationManager?
    
    // It is called when the authorization status of your location manager is changed by the user
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("The authorization status of location services is changed to: ")
        
        switch CLLocationManager.authorizationStatus(){
        case .AuthorizedAlways:
            println("Authorized always")
        case .AuthorizedWhenInUse:
            println("Authorized when in use")
        case .Denied:
            println("Denied")
        case .NotDetermined:
            println("Not determined")
        case .Restricted:
            println("Restricted")
        default:
            println("Unhandled")
        }
    }
    
    // It is called when there is an error fetching the user's location
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Failure retrieving the user's location. Error: \(error)")
    }
    
    // System got a location update
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        println("Location - Latitude: \(newLocation.coordinate.latitude)")
        println("Location - Longitude: \(newLocation.coordinate.longitude)")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /* Are location services available on this device? */
        if CLLocationManager.locationServicesEnabled(){
            
            /* Do we have authorization to access location services? */
            switch CLLocationManager.authorizationStatus(){
            case .AuthorizedAlways:
                /* Yes, always */
                createLocationManager(true)
            case .AuthorizedWhenInUse:
                /* Yes, only when our app is in use */
                createLocationManager(true)
            case .Denied:
                /* No */
                displayAlertWithTitle("Not Determined",
                    message: "Location services are not allowed for this app")
            case .NotDetermined:
                /* We don't know yet, we have to ask */
                createLocationManager(false)
                if let manager = self.locationManager{
                    manager.requestWhenInUseAuthorization()
                }
            case .Restricted:
                /* Restrictions have been applied, we have no access
                to location services */
                displayAlertWithTitle("Restricted",
                    message: "Location services are not allowed for this app")
            }
            
            
        } else {
            /* Location services are not enabled.
            Take appropriate action: for instance, prompt the
            user to enable the location services */
            println("Location services are not enabled")
        }
    }
    
    //- MARK: Helper methods
    func displayAlertWithTitle(title:String, message:String){
        var alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func createLocationManager(startImmediately:Bool){
        locationManager = CLLocationManager()
        if let manager = locationManager{
            println("Successfully created a location manager!")
            manager.delegate = self
            if startImmediately{
                manager.startUpdatingLocation()
            }
        }
    
    }
}

