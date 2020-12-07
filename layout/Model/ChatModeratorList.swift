//
//  ChatModeratorList.swift
//  layout
//
//  Created by SIP_Sales on 07/12/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import Foundation

struct ChatModeratorList:Decodable {
    let id:Int
    let id_job:Int
    let id_engineer:Int
    let status: String
    let date_add:String
    let date_update:String
    let job:JobList
    let job_category: JobCategory
}
