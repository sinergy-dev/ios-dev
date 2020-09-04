//
//  PaymentDetailCell.swift
//  layout
//
//  Created by Rama Agastya on 27/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class PaymentDetailCell: UITableViewCell {
    @IBOutlet weak var IVStatusPayment: UIImageView!
    @IBOutlet weak var DateDetailLabel: UILabel!
    @IBOutlet weak var StatusDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
