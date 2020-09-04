//
//  JobPIC.swift
//  layout
//
//  Created by Rama Agastya on 01/09/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import Foundation

struct JobPIC:Decodable {
    let id: Int
    let pic_name: String
    let pic_phone: String
    let pic_mail: String
    let pic_address: String
    let date_add: String
}
