//
//  JobLocation.swift
//  layout
//
//  Created by Rama Agastya on 24/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import Foundation

struct JobLocation:Decodable {
    let id: Int
    let location_name: String
    let sub_location: Int
    let level: Int
    let date_add: String
    let long_location: String
    let text: String
}
