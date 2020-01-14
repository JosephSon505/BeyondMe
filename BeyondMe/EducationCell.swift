//
//  EducationCell.swift
//  BeyondMe
//
//  Created by Joseph Son on 12/11/19.
//  Copyright © 2019 Joseph Son. All rights reserved.
//

import UIKit

class EducationCell: UITableViewCell {
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var gpaLabel: UILabel!
    @IBOutlet weak var graduationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(school: String, major: String, gpa: String, gradDay: String) {
        schoolLabel.text = school
        majorLabel.text = major
        gpaLabel.text = gpa
        graduationLabel.text = gradDay
    }
}
