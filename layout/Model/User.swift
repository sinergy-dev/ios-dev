//
//  User.swift
//  layout
//
//  Created by Rama Agastya on 18/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import Foundation

struct User:Decodable {
    let id:Int
    let name:String
    let email:String
    let phone:String
    let address:String
    let job_engineer_count:Int
    let fee_engineer_count:Int
    let category_engineer:String
    let date_of_join:String
    
}

