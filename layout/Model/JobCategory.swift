//
//  JobCategory.swift
//  layout
//
//  Created by Rama Agastya on 24/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import Foundation

struct JobCategory:Decodable {
    let id: Int
    let id_category_main: Int
    let category_name: String
    let category_description: String
    let category_image: String
    let category_image_url: String
    let text: String
    let text_category: String
}
