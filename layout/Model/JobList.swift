//
//  JobList.swift
//  layout
//
//  Created by Rama Agastya on 24/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import Foundation

struct JobList:Decodable {
    let id:Int
    let id_category:Int
    let id_customer:Int
    let id_level:Int
    let id_location:Int
    let id_pic:Int
    let job_name:String
    let job_description:String
    let job_requrment:String
    let job_location:String
    let job_status:String
    let job_price:Int
    let date_start:String
    let date_end:String
    let date_add:String
    let category:JobCategory?
    let customer:JobCustomer?
    let location:JobLocation?
    let level:JobLevel?
    let pic: JobPIC?
    var progress:[JobProgress]?
}
