//
//  JobProgress.swift
//  layout
//
//  Created by Rama Agastya on 02/09/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import Foundation

struct JobProgress:Decodable {
    let id: Int
    let id_job: Int
    let id_user: Int
    let id_activity: String
    let date_time: String
    var detail_activity: String
}
