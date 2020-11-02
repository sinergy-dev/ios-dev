//
//  PersonalDetailCell.swift
//  layout
//
//  Created by Rama Agastya on 18/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class PersonalDetailCell: UITableViewCell {
    
    @IBOutlet weak var IVPersonalDetail: UIImageView!
    @IBOutlet weak var JobLabel: UILabel!
    @IBOutlet weak var CategoryLabel: UILabel!
    @IBOutlet weak var LocLabel: UILabel!
    @IBOutlet weak var CusLabel: UILabel!
    @IBOutlet weak var StatusLabel: UILabel!
    
    func setDetail(data: DetailPersonal) {
        IVPersonalDetail.image = data.image
        JobLabel.text = data.title
        CategoryLabel.text = data.category
    } 
}
