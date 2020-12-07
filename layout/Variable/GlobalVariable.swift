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
    static let urlGetCheckToken = hostServer + "/api/check_token"
    static var urlGetJobList = hostServer + "/api/job/getJobByCategory"
    static var urlGetCategoryAll = hostServer + "/dashboard/getJobCategoryAll"
    static var urlGetJobDetail = hostServer + "/api/job/getJobOpen"
    static var urlGetAccount = hostServer + "/api/users/getProfileDetail"
    static var urlGetPayment = hostServer + "/api/payment/getJobPayment"
    static var urlGetSupport = hostServer + "/api/job/getJobSupport"
    static var urlGetProgressJob = hostServer + "/api/job/getJobProgress"
    static var urlGetJobListSumm = hostServer + "/dashboard/getJobListAndSumary"
    static var urlGetJobOpen = hostServer + "/job/getJobOpen"
    
    static var urlGetJobListbyEngineer = hostServer + "/api/dashboard/getJobListAndSumaryEngineer"
    static var urlUpdateJobProgress = hostServer + "/api/job/postJobUpdate"
    static var urlUpdateJobDone = hostServer + "/api/job/postJobFinish"
    static var urlUpdateJobSupport = hostServer + "/api/job/postJobRequestSupport"
    static var urlUpdateJobRequest = hostServer + "/api/job/postJobRequestItem"
    
    static var urlJobStart = hostServer + "/api/job/postJobStart"
    static var urlApplyJob = hostServer + "/api/job/postJobApply"
    
    static var urlLogin = hostServer + "/api/api_login"
    static var urlUpdateProfile = hostServer + "/api/users/postProfileUpdate"
    static var urlgetChatModerator = hostServer + "/api/job/getChatModerator";
}

