//
//  JobSingle.swift
//  layout
//
//  Created by Rama Agastya on 24/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import Foundation

struct JobSingle:Decodable{
    var job:JobList?
    
    init(job:JobList?) {
        self.job = job
    }
}
