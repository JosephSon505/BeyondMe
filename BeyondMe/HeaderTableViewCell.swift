//
//  HeaderTableViewCell.swift
//  BeyondMe
//
//  Created by Joseph Son on 12/11/19.
//  Copyright © 2019 Joseph Son. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headerLabel.font = UIFont(name: "AvenirNext-Bold", size: 20)
    }

    func setup(title: String) {
        headerLabel.text = title
    }
}
