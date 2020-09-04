//
//  JobLevel.swift
//  layout
//
//  Created by Rama Agastya on 24/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import Foundation

struct JobLevel:Decodable {
    let id: Int
    let level_name: String
    let level_description: String
    let date_add: String
}
