//
//  PaymentList.swift
//  layout
//
//  Created by Rama Agastya on 26/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import Foundation

struct PaymentList:Decodable {
    let id:Int
    let id_job:Int
    let id_history:Int
    let id_payment_account:Int
    let payment_to:Int
    let payment_from:Int
    let payment_nominal:Int
    let payment_method:String
    let payment_invoice:String
    let date_add:String
    let payment_invoice_URL:String
    let job_category_image:String
    let date_huminize:String
    let lastest_progress: PaymentLastestProgress
    let job:JobList
    let progress: [PaymentProgress]
}
