//
//  workout.swift
//  Health_Kit_Start
//
//  Created by Shane Talbert on 12/30/18.
//  Copyright © 2018 Shane Talbert. All rights reserved.
//

import Foundation

struct Workout {
    let exercise: UInt
    let duration: TimeInterval
    let startDate: Date
    
    //computed property that will compute the string value based on the exercise UInt value
    var exerciseName: String {
        get {
            
            var exerciseNameToReturn = ""
            
            switch exercise {
            case 13:
                exerciseNameToReturn = "cycling"
            case 16:
                exerciseNameToReturn = "eliptical"
            case 37:
                exerciseNameToReturn = "running"
            case 48:
                exerciseNameToReturn = "tennis"
            case 50:
                exerciseNameToReturn = "strength training"
            case 52:
                exerciseNameToReturn = "walking"
            default:
                exerciseNameToReturn = "other"
            }
            return exerciseNameToReturn
        }
    }
    
    var exerciseTimeInMinutes: Int {
        get {
            let minutes: Int = Int(duration / 60)
            return minutes
        }
        
        
    }
    
    init(exercise: UInt, duration: TimeInterval, startDate: Date) {
        self.exercise = exercise
        self.duration = duration
        self.startDate = startDate
    }
    
    func monthYearPerformed() -> String {
        
        //will use this to put sections in my table view.
        let dFormat = DateFormatter()
        let format = "MMM-yyyy"
        dFormat.dateFormat = format
        let dateStr = dFormat.string(from: self.startDate)
        return dateStr
        
    }
    
    func dateStr() -> String {
        
        //need to pretty up the date only want the date
        let dFormat = DateFormatter()
        let format = "MMM-dd-yyyy"
        dFormat.dateFormat = format
        let dateStr = dFormat.string(from: self.startDate)
        return dateStr
    }
    
    //also have a print statement which pretties up the output...
    func testingOutput() -> String {
        
        let testString = "on \(self.dateStr()) performed \(self.exerciseName) for \(self.exerciseTimeInMinutes) minutes."
        return testString
    }
    
    func csvOutputString() -> String {
        let outputStr: String = "\(self.dateStr()),\(self.exerciseName),\(self.exerciseTimeInMinutes)\n"
        return outputStr
    }
    
}
