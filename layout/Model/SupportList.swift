//
//  SupportList.swift
//  layout
//
//  Created by Rama Agastya on 27/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import Foundation

struct SupportList:Decodable {
    let id:Int
    let id_job:Int
    let id_history:Int
    let id_engineer:Int
    let problem_support:String
    let reason_support:String
    let status: String
    let date_add:String
    let picture_support_url:String
    let job:JobList
    let job_category: JobCategory
}
