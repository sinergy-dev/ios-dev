//
//  LoginObjectReturn.swift
//  TestLogin
//
//  Created by Sinergy on 10/1/20.
//  Copyright © 2020 Sinergy. All rights reserved.
//

import Foundation

struct LoginObjectReturn:Decodable{
    let success:Int
    let id_user:Int?
    let token:String?
    let message:String?
    
}

