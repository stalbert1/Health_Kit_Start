//
//  DataViewVC.swift
//  Health_Kit_Start
//
//  Created by Shane Talbert on 1/2/19.
//  Copyright © 2019 Shane Talbert. All rights reserved.
//

import UIKit
import MessageUI

class DataViewVC: UIViewController,UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var workoutsToDisplay = [Workout]()
    
    //multi demensional array to store each card in a seperate array
    var mySeperatedWorkouts = [[Workout]]()
    
    //make empty set of strings for sections and total info
    var monthYearSummary = Set<String>()
    
    var sectionNames = [String]()
    
    //will have a dictionary of keys as string and int to keep the totals.
    var totalMinutesPerExercise = [String : Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 80.0
        
        print("view did load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
        
        //Building data to use in rows and section of table
        
        totalMinutesPerExercise = [String : Int]()
        
        for workout in workoutsToDisplay {
            monthYearSummary.insert(workout.monthYearPerformed())
            
            //building the dictionary and add totals as it progresses...
            if totalMinutesPerExercise[workout.exerciseName] == nil {
                totalMinutesPerExercise[workout.exerciseName] = workout.exerciseTimeInMinutes
            } else {
                totalMinutesPerExercise[workout.exerciseName] = totalMinutesPerExercise[workout.exerciseName]! + workout.exerciseTimeInMinutes
            }
        }
        
        for monthYear in monthYearSummary {
            sectionNames.append(monthYear)
        }
        
        //initializing the 2d array
        mySeperatedWorkouts = Array(repeating: [], count: sectionNames.count)
        
        //build multiple arrays
        for index in 0..<sectionNames.count {
            for thisWorkout in workoutsToDisplay {
                if thisWorkout.monthYearPerformed() == sectionNames[index] {
                
                    mySeperatedWorkouts[index].append(thisWorkout)
                }
            }
        }
        
        
        
        //Now try adding a totals section at the bottom.
        //Section title will be totals
        
        //1 row for each type of exercise date will be the day it is totaled
        //min will be total min added together
        //exercise name will be the name of the totaled exercise
        //print(totalMinutesPerExercise)

        
        
    }
    
    
    @IBAction func totalsPressed() {
        
        self.performSegue(withIdentifier: "gotoTotalsView", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoTotalsView" {
            print("preparing for totals segue")
            if let destination = segue.destination as? TotalsVC {
                //will pass the dictionary with total names and values
                destination.passedTotalMinutesPerExercise = totalMinutesPerExercise
                
            }
        }
    }
    
    //seague id to goto totals view is
    //gotoTotalsView
    
    @IBAction func exportPressed() {
        
        print("export was pressed")
        
        //This will build the csv file to export
        //the first line here is for the header
        var myExerciseList: String = "Date,Exercise,Minutes\n"
        
        for exercise in workoutsToDisplay {
            myExerciseList = myExerciseList + exercise.csvOutputString()
            
        }
        
        print(myExerciseList)
        
        //save myExerciseList as a csv file
        createSaveEmailFile(stringDataToSave: myExerciseList)
        
    }
    
    
    // MARK: - Create and send Email
    
    func createSaveEmailFile(stringDataToSave: String) {
        
        let flMgr = FileManager.init()
        let documentsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        //this appends the file name to the end of the returned string
        let writePath = documentsDir.appending("/test.txt")
        flMgr.createFile(atPath: writePath, contents: nil, attributes: nil)
        
        //print(writePath)
        //write file code
        do {
            //without overriding.  Only saving last entry
            try stringDataToSave.write(toFile: writePath, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print ("Error\(error)")
        }
        
        //next email the file that was just created
        let myData = NSData(contentsOfFile: writePath)
        
        //mime type text/csv
        if MFMailComposeViewController.canSendMail() == true {
            showMailComposer(withAttachmentURL: "workoutList.csv", myData: myData! as Data)
        } else {
            print("This device can't send mail")
        }
        
        
    }
    
    func showMailComposer(withAttachmentURL: String, myData: Data) {
        
        let subject = "Workout backup CSV file"
        let messageBody = "Workout backup file in CSV format."
        
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject(subject)
        mailComposer.setMessageBody(messageBody, isHTML: false)
        
        mailComposer.addAttachmentData(myData, mimeType: "text/csv", fileName: withAttachmentURL)
        present(mailComposer, animated: true, completion: nil)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            //cancelled
            alert(title: "OOpps", msg: "Cancelled")
        case MFMailComposeResult.sent.rawValue:
            //message sent
            alert(title: "Sucess", msg: "Message sent")
        case MFMailComposeResult.failed.rawValue:
            //message failed
            alert(title: "Failed", msg: "Message failed to save")
        case MFMailComposeResult.saved.rawValue:
            alert(title: "Saved", msg: "Message is saved")
        default: break
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func alert (title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: - Table View Setup
    
    //currently it is not sorting by date on the table view...
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return monthYearSummary.count
        return sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // code here
        return mySeperatedWorkouts[section].count
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.cyan
        
        let label = UILabel()
        label.text = sectionNames[section]
        label.frame = CGRect(x: 5, y: 5, width: 200, height: 35)
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //myCell reuse id
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? WorkoutTableViewCell {
            cell.lblDate.text = mySeperatedWorkouts[indexPath.section][indexPath.row].dateStr()
            cell.lblExerciseName.text = mySeperatedWorkouts[indexPath.section][indexPath.row].exerciseName
            cell.lblExerciseMinutes.text = "\(mySeperatedWorkouts[indexPath.section][indexPath.row].exerciseTimeInMinutes) Min"
            
            return cell
        } else {
            return WorkoutTableViewCell()
        }
        
      
    }


}
