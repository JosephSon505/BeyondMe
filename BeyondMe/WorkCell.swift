//
//  WorkCell.swift
//  BeyondMe
//
//  Created by Joseph Son on 12/11/19.
//  Copyright © 2019 Joseph Son. All rights reserved.
//

import UIKit

class WorkCell: UITableViewCell {
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(company: String, position: String, startDate: String, endDate: String) {
        companyLabel.text = company
        positionLabel.text = position
        startDateLabel.text = startDate
        endDateLabel.text = endDate
    }

}
