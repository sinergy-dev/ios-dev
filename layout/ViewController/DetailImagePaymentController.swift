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
    @IBOutlet weak var scrollview: UIScrollView!
    var selectedImage:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview.maximumZoomScale = 4
        scrollview.minimumZoomScale = 1
        
        scrollview.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.global(qos: .background).async {
            let imageUrl = NSURL(string: self.selectedImage)
            let imageData = NSData(contentsOf: imageUrl! as URL)
            
            DispatchQueue.main.async {
                if imageData != nil {
                    self.ImagePayment.image = UIImage(data: imageData! as Data)
                }
            }
        }
    }
}

extension DetailImagePaymentController: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return ImagePayment
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1{
            if let image = ImagePayment.image{
                let ratioW = ImagePayment.frame.width / image.size.width
                let ratioH = ImagePayment.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                
                let conditionLeft = newWidth * scrollView.zoomScale > ImagePayment.frame.width
                
                let left = 0.5 * (conditionLeft ? newWidth - ImagePayment.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                
                let conditionTop = newHeight * scrollView.zoomScale > ImagePayment.frame.height
                
                let top = 0.5 * (conditionTop ? newHeight - ImagePayment.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
    
}
