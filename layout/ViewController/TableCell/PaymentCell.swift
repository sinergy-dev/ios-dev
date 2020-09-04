//
//  PaymentCell.swift
//  layout
//
//  Created by Rama Agastya on 24/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class PaymentCell: UITableViewCell {

    @IBOutlet weak var IVPayment: UIImageView!
    @IBOutlet weak var JobLabel: UILabel!
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
