//
//  ViewController.swift
//  Observing changes in HealthKit
//
//  Created by Domenico Solazzo on 08/05/15.
//  License MIT
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    // Body mass
    let weightQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
    
    lazy var types: Set<NSObject> = {
        return Set<NSObject>(arrayLiteral: self.weightQuantityType)
    }()
    
    // Health store
    lazy var healthStore = HKHealthStore()
    
    // Predicate
    lazy var predicate: NSPredicate = {
        let now = NSDate()
        
        let yesterday = NSCalendar.currentCalendar().dateByAddingUnit(
            NSCalendarUnit.DayCalendarUnit,
            value: -1,
            toDate: now,
            options: NSCalendarOptions.WrapComponents)
        
        return HKQuery.predicateForSamplesWithStartDate(
            yesterday,
            endDate: now,
            options: HKQueryOptions.StrictEndDate)
    }()
    
    // Observer Query
    lazy var query: HKObserverQuery = {[weak self] in
        let strongSelf = self!
        return HKObserverQuery(sampleType: strongSelf.weightQuantityType,
            predicate: strongSelf.predicate,
            updateHandler: strongSelf.weightChangedHandler
        )
    }()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if HKHealthStore.isHealthDataAvailable(){
            healthStore.requestAuthorizationToShareTypes(nil, readTypes: types, completion: {[weak self]
                (succeeded:Bool, error:NSError!) -> Void in
                let strongSelf = self!
                
                if succeeded && error != nil{
                    dispatch_async(dispatch_get_main_queue(),
                        strongSelf.startObservingWeightChanges)
                }else{
                    if let theError = error{
                        println("Error \(theError)")
                    }
                }
            })
        }else{
            println("Health data is not available")
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        stopObservingWeightChanges()
    }
    
    func startObservingWeightChanges(){
        healthStore.executeQuery(query)
        healthStore.enableBackgroundDeliveryForType(weightQuantityType,
            frequency: HKUpdateFrequency.Immediate) { (succeeded:Bool, error:NSError!) -> Void in
                if succeeded{
                    println("Enabled background delivery of weight changes")
                }else{
                    if let theError = error{
                        print("Failed to enabled background changes")
                        println("Error \(theError)")
                    }
                }
        }
    }
    
    func stopObservingWeightChanges(){
        healthStore.stopQuery(query)
        healthStore.disableAllBackgroundDeliveryWithCompletion{
            (succeeded: Bool, error: NSError!) in
            
            if succeeded{
                println("Disabled background delivery of weight changes")
            } else {
                if let theError = error{
                    print("Failed to disable background delivery of weight changes. ")
                    println("Error = \(theError)")
                }
            }
            
        }
    }
    
    // Fetching the changes
    func fetchRecordedWeightsInLastDay(){
        // Sorting
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        
        // Query
        let query = HKSampleQuery(sampleType: weightQuantityType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) {[weak self]
            (query:HKSampleQuery!, results:[AnyObject]!, error: NSError!) -> Void in
            if results.count > 0{
                for sample in results as! [HKQuantitySample]{
                    // Get the weight in kilograms from the quantity
                    let weightInKilograms = sample.quantity.doubleValueForUnit(
                        HKUnit.gramUnitWithMetricPrefix(.Kilo)
                    )
                    
                    // Get the value of KG, localized for the user
                    let formatter = NSMassFormatter()
                    let kilogramSuffix = formatter.unitStringFromValue(weightInKilograms, unit:.Kilogram)
                    
                    dispatch_async(dispatch_get_main_queue(), {[weak self] in
                        let strongSelf = self!
                        
                        println("Weight has been changed to " +
                            "\(weightInKilograms) \(kilogramSuffix)")
                        println("Change date = \(sample.startDate)")
                    })
                }
                
                
            }else{
                print("Could not read the user's weight ")
                println("or no weight data was available")
            }
        }
        
        healthStore.executeQuery(query)
    }
    
    func weightChangedHandler(query: HKObserverQuery!,
        completionHandler: HKObserverQueryCompletionHandler!,
        error: NSError!){
    
    }
}

