//
//  JobCategoryMain.swift
//  layout
//
//  Created by Sinergy on 9/4/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import Foundation

struct JobCategoryMain: Decodable {
    let id:Int
    let category_main_name:String
    let date_add:String
    let category:[JobCategory]
}
