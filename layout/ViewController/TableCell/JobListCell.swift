//
//  JobListCell.swift
//  layout
//
//  Created by Rama Agastya on 07/09/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

protocol JobListCellDelegate {
    func didSeeMoreBtn(indexPath: Int)
}

class JobListCell: UITableViewCell {
    @IBOutlet weak var FeeLabel: UILabel!
    @IBOutlet weak var LocLabel: UILabel!
    @IBOutlet weak var CusLabel: UILabel!
    @IBOutlet weak var JobLabel: UILabel!
    @IBOutlet weak var CatLabel: UILabel!
    @IBOutlet weak var IVJobList: UIImageView!
    @IBOutlet weak var NextView: UIView!{
        didSet {
            NextView.isHidden = true
        }
    }
    
    var delegate: JobListCellDelegate?
    var indexPath: Int?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func seeMoreBtn(_ sender: Any) {
        delegate?.didSeeMoreBtn(indexPath: indexPath!)
    }
    
}
