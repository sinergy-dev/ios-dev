//
//  GlobalVariable.swift
//  layout
//
//  Created by Rama Agastya on 18/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import Foundation

enum GlobalVariable {
    static let hostServer = "https://development-api.sifoma.id"
    static var urlGetJobList = hostServer + "/api/job/getJobByCategory"
    static var urlGetJobDetail = hostServer + "/api/job/getJobOpen"
    static var urlGetAccount = hostServer + "/api/users/getProfileDetail"
    static var urlGetPayment = hostServer + "/api/payment/getJobPayment"
    static var urlGetSupport = hostServer + "/api/job/getJobSupport"
    static var urlGetProgressJob = hostServer + "/api/job/getJobProgress"
    static var urlGetJobListSumm = hostServer + "/dashboard/getJobListAndSumary"
    static var urlGetJobOpen = hostServer + "/job/getJobOpen"
    
    static var urlUpdateJobProgress = hostServer + "/api/job/postJobUpdate"
    
    static var urlJobStart = hostServer + "/api/job/postJobStart"
    
    static var urlApplyJob = hostServer + "/api/job/postJobApply"
    
    static let tempToken = "Bearer 6d554ebe8194d899ab309e4dda558c85d2ae311a847bee2a4472d3484277b477"
}

