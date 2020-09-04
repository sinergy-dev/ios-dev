//
//  SupportCell.swift
//  layout
//
//  Created by Rama Agastya on 27/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class SupportCell: UITableViewCell {
    @IBOutlet weak var IVSupport: UIImageView!
    @IBOutlet weak var JobLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var StatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
