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
    var actionButton : ActionButton!
    
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
        
        if self.supportFromSegue.status != "Open" {
            setupButtons()
        }
        
    }
    
    func setupButtons() {
        let chat = ActionButtonItem(title: "Chat", image: #imageLiteral(resourceName: "Exclusion_2"))
        chat.action = {
            item in self.Chat()
            self.actionButton.toggleMenu()
        }
        actionButton = ActionButton(attachedToView: self.view, items: [chat])
        actionButton.setTitle("+", forState: UIControl.State())
        actionButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        actionButton.action = { button in button.toggleMenu()}
        
    }
    
    func Chat() {
        performSegue(withIdentifier: "toChatView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChatView" {
            if let destination = segue.destination as? ChatViewController {
                destination.chatSupportFromSegue = self.supportFromSegue
            }
        }
    }

}
