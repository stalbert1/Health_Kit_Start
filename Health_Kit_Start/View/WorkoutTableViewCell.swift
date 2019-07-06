//
//  WorkoutTableViewCell.swift
//  Health_Kit_Start
//
//  Created by Shane Talbert on 1/2/19.
//  Copyright © 2019 Shane Talbert. All rights reserved.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblExerciseName: UILabel!
    @IBOutlet weak var lblExerciseMinutes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
