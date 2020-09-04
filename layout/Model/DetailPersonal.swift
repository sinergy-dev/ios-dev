//
//  DetailPersonal.swift
//  layout
//
//  Created by Rama Agastya on 18/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import Foundation
import UIKit

class DetailPersonal{
    
    var image: UIImage
    var title: String
    var category: String
    
//    init(title:String) {
////        self.image = image
//        self.title = title
//    }
    
    init( title:String, image:String, category:String) {
        self.image = UIImage(named: image)!
        self.title = title
        self.category = category
    }
}
