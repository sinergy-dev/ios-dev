//
//  LaunchScreenViewController.swift
//  layout
//
//  Created by SIP_Sales on 04/11/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    var validityToken: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        if(UserDefaults.standard.bool(forKey: "isLoggedIn")){
            checkTokenValidity(userToken: UserDefaults.standard.string(forKey: "Token")! ){
                if (self.validityToken!){
                    let viewController = self.storyboard!.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
                    UIApplication.shared.windows.first?.rootViewController = viewController
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                } else {
                    self.gotoLogin()
                }
            }
        } else {
            gotoLogin()
        }
    }
    
    func gotoLogin() {
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "loginView")
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func checkTokenValidity(userToken:String, completed: @escaping () -> ()){
        let url = GlobalVariable.urlGetCheckToken
        var request = URLRequest(url:URL(string:url)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(userToken, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                if((response as! HTTPURLResponse).statusCode == 200) {
                    self.validityToken = true
                } else {
                    self.validityToken = false
                }
                DispatchQueue.main.async {
                    completed()
                }
            }
        }.resume()
    }

}
