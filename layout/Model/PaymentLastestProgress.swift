//
//  PaymentLastestProgress.swift
//  layout
//
//  Created by Rama Agastya on 26/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import Foundation

struct PaymentLastestProgress:Decodable{
    let id: Int
    let id_payment: Int
    let id_user: Int
    let date_time: String
    let activity: String
    let note: String
    let created_at: String
}
