//
//  AppliedCell.swift
//  layout
//
//  Created by Rama Agastya on 01/09/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class AppliedCell: UITableViewCell {
    @IBOutlet weak var IVApplied: UIImageView!
    @IBOutlet weak var JobLabel: UILabel!
    @IBOutlet weak var CatLabel: UILabel!
    @IBOutlet weak var CusLabel: UILabel!
    @IBOutlet weak var LocLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
