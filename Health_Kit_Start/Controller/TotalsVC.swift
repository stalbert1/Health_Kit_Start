//
//  TotalsVC.swift
//  Health_Kit_Start
//
//  Created by Shane Talbert on 1/8/19.
//  Copyright © 2019 Shane Talbert. All rights reserved.
//

import UIKit

class TotalsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    //This is the dictionary data that will be arriving potentially
    var passedTotalMinutesPerExercise = [String : Int]()
    
    //will use this to display data in tables
    var displayData = [String]()
    
    
    //Would like to total the amount of times on each exercise and maybe do a table view of uiviews to return pie charts of minutes pie and times for each workout pie.
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        print("in the totals vc")
        print(passedTotalMinutesPerExercise)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for (exercise, time) in passedTotalMinutesPerExercise {
            displayData.append("Performed \(exercise) for \(time) Min")
        }
        
    }
    

}



extension TotalsVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //re use id is "descCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "descCell")
        //cell!.textLabel?.text = displayData[indexPath.row]
        cell?.textLabel?.text = displayData[indexPath.row]
        return cell!
        
        
    }
    
    
}
