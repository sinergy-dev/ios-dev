//
//  SupportDetailController.swift
//  layout
//
//  Created by Rama Agastya on 27/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class SupportDetailController: UIViewController {

    var supportFromSegue:SupportList!
    
    @IBOutlet weak var IVSupportDetail: UIImageView!
    @IBOutlet weak var JobLabel: UILabel!
    @IBOutlet weak var ProblemLabel: UILabel!
    @IBOutlet weak var ReasonLabel: UILabel!
    @IBOutlet weak var IVBukti: UIImageView!
    
    @available(iOS 13.0, *)
    @IBAction func Button(_ sender: Any) {
        let ImageView:DetailImageSupportController = self.storyboard?.instantiateViewController(identifier: "DetailImageSupportController") as! DetailImageSupportController
        
        ImageView.selectedImage = self.supportFromSegue.picture_support_url
        
        self.navigationController?.pushViewController(ImageView, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let imageURL = URL(string: supportFromSegue.picture_support_url) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.IVBukti.image = image
                    }
                }
            }
        }
        
        self.JobLabel.text? = self.supportFromSegue.job.job_name
        self.ProblemLabel.text? = self.supportFromSegue.problem_support
        self.ReasonLabel.text? = self.supportFromSegue.reason_support
        if let imageURL = URL(string: supportFromSegue.job_category.category_image_url) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.IVSupportDetail.image = image
                    }
                }
            }
        }
    }

}
