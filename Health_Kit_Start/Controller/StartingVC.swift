//
//  StartingVC.swift
//  Health_Kit_Start
//
//  Created by Shane Talbert on 12/3/18.
//  Copyright © 2018 Shane Talbert. All rights reserved.
//

import UIKit
import HealthKit

class StartingVC : UIViewController {
    
    
    @IBOutlet weak var dateFrom: UIDatePicker!
    @IBOutlet weak var dateTo: UIDatePicker!
    
    var healthStore: HKHealthStore!
    
    //array of Workouts structure
    var workouts = [Workout]()
    
    
    @IBAction func getDataPressed() {
        
        workouts.removeAll()
        
        print("get data pressed")
        let datePickedFrom = dateFrom.date
        let datePickeTo = dateTo.date
 
//        print("running raw value is...\(HKWorkoutActivityType.running.rawValue)")
//        print("eliptical raw value is...\(HKWorkoutActivityType.elliptical.rawValue)")
//        print("tennis raw value is...\(HKWorkoutActivityType.tennis.rawValue)")
//        print("walking raw value is...\(HKWorkoutActivityType.walking.rawValue)")
//        print("traditional strength training raw value is...\(HKWorkoutActivityType.traditionalStrengthTraining.rawValue)")
//        print("other raw value is...\(HKWorkoutActivityType.other.rawValue)")
//        print("cycling raw value is...\(HKWorkoutActivityType.cycling.rawValue)")
        
        let sampleType = HKSampleType.workoutType()
        //let sampleType = HKSampleType.seriesType(forIdentifier: "Tennis")
        
        // the [] is == to .none options
        let predicate = HKQuery.predicateForSamples(withStart: datePickedFrom, end: datePickeTo, options: [])
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
            query, results, error in
            
            //was casting as? HKQuantitySample
            guard let samples = results as? [HKWorkout] else {
                fatalError("An error occured fetching the user's workout data. In your app, try to handle this error gracefully. The error was: \(String(describing: error?.localizedDescription))");
            }
            
            DispatchQueue.main.async {
                
                print("there are \(samples.count) samples...")
                
                for sample in samples {

                    //let tempWorkoutStruct = Workout(exercise: <#T##UInt#>, duration: <#T##TimeInterval#>, startDate: <#T##Date#>)
                    let tempWorkout = Workout(exercise: sample.workoutActivityType.rawValue, duration: sample.duration, startDate: sample.startDate)
                    self.workouts.append(tempWorkout)
            
                    //this is the one, I think it is a UInt which you may convert to cases and enum?
                    //print(sample.workoutActivityType.rawValue)
                    
                    }
                
                for workout in self.workouts {
                    //print(workout.testingOutput())
                    print(workout.monthYearPerformed())
                }
                
                self.performSegue(withIdentifier: "gotoDataView", sender: self)
            }
        }
        
        healthStore.execute(query)

    }
    
    
    @IBAction func permissionsPressed() {
        
        print("permissions pressed")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoDataView" {
            print("preparing for segue")
            if let destination = segue.destination as? DataViewVC {
                destination.workoutsToDisplay = workouts
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check to see if Healthkit is available on the device (ipad is not supported)
        if !HKHealthStore.isHealthDataAvailable() {
            
            print("Error the health data is not available")
        }
        
        //create the healthcare store object
        //this needs to be ivar
        healthStore = HKHealthStore()
        
        //types that will be allowed to be shared and read.  Could have 2 diff sets.
        //let typesToWrite = Set ([HKObjectType.workoutType()])
        
        let healthCareItemsToRead : Set<HKObjectType> = [HKObjectType.workoutType()]
        
        //should set the write to nil?
        
        //if you have already accepted auth the user will not be presented the choices again.
        healthStore.requestAuthorization(toShare: .none, read: healthCareItemsToRead) { (success, error) in
            if !success {
                //closure success is a boolean and error is a type of error
                //handle error here
                print("error \(String(describing: error)) reported...")
                
            }
        }
        
        let auth = healthStore.authorizationStatus(for: HKObjectType.workoutType())
        print("The authorization status is ... \(auth) ... And the call is over")
        
    }// end view did load
    
    
}



