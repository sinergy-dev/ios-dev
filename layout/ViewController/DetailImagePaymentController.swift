//
//  DetailImagePaymentController.swift
//  layout
//
//  Created by Rama Agastya on 15/09/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class DetailImagePaymentController: UIViewController {

    @IBOutlet weak var ImagePayment: UIImageView!
    var selectedImage:String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.global(priority: .background).async {
            let imageUrl = NSURL(string: self.selectedImage)
            let imageData = NSData(contentsOf: imageUrl! as URL)
            
            DispatchQueue.main.async {
                if imageData != nil {
                    self.ImagePayment.image = UIImage(data: imageData! as Data)
                }
            }
            
            /*dispatch_async(dispatch_get_main_queue(),{
                if imageData != nil {
                    self.ImagePayment.image = UIImage(data: imageData! as Data)
                }
            })*/
        }
        
        /*dispatch_async(dispatch_get_global_queue(DispatchQueue.GlobalQueuePriority.default, 0), {
            let imageUrl = NSURL(string: self.selectedImage)
            let imageData = NSData(contentsOf: imageUrl! as URL)
            
            dispatch_async(dispatch_get_main_queue(),{
                if imageData != nil {
                    self.ImagePayment.image = UIImage(data: imageData! as Data)
                }
            })
        })*/
    }

}
