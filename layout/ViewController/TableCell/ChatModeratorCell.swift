//
//  ChatModeratorCell.swift
//  layout
//
//  Created by SIP_Sales on 07/12/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class ChatModeratorCell: UITableViewCell {
    
    @IBOutlet weak var IVChatModerator: UIImageView!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
