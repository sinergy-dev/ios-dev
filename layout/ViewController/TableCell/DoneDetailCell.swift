//
//  DoneDetailCell.swift
//  layout
//
//  Created by Rama Agastya on 03/09/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class DoneDetailCell: UITableViewCell {

    @IBOutlet weak var DayLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var ActivityLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
