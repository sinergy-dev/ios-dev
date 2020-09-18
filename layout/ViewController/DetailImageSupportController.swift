//
//  DetailImageSupportController.swift
//  layout
//
//  Created by Rama Agastya on 18/09/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class DetailImageSupportController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    var selectedImage:String!

    override func viewDidLoad() {
        super.viewDidLoad()

        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.global(priority: .background).async {
            let imageUrl = NSURL(string: self.selectedImage)
            let imageData = NSData(contentsOf: imageUrl! as URL)
            
            DispatchQueue.main.async {
                if imageData != nil {
                    self.imageView.image = UIImage(data: imageData! as Data)
                }
            }
        }
    }

}
