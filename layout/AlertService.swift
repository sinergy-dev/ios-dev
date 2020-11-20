//
//  AlertService.swift
//  layout
//
//  Created by SIP_Sales on 20/11/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class AlertService{
    
    let storyboard = UIStoryboard(name: "Alert", bundle: .main)
    var alert = AlertViewController()
    
    func alert(title: String, buttonTitle:String, completion: @escaping () -> Void) -> AlertViewController{
        
        alert = storyboard.instantiateViewController(withIdentifier: "alertStoryboard") as! AlertViewController
        
        self.alert.alertTitle = title
        self.alert.actionButtonTitle = buttonTitle
        self.alert.buttonAction = completion
        
        return alert
    }
    
    func getInput() -> String {
        return self.alert.getInput()
    }
}
