//
//  JobCustomer.swift
//  layout
//
//  Created by Rama Agastya on 24/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import Foundation

struct JobCustomer:Decodable {
    let id: Int
    let customer_name: String
    let customer_acronym: String
    let customer_description: String
    let date_add: String
    let location: Int
    let address: String?
    let location_client:JobCustomerLocation
}
