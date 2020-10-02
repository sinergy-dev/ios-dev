//
//  LoginViewController.swift
//  layout
//
//  Created by Rama Agastya on 01/10/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    var loginObject:LoginObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textEmail.delegate = self
        textPassword.delegate = self
        
        if(UserDefaults.standard.bool(forKey: "isLoggedIn")){
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
            UIApplication.shared.windows.first?.rootViewController = viewController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    @IBAction func doLogin(_ sender: Any) {
        print("Email " + textEmail.text!)
        print("Paassword " + textPassword.text!)
        
        if (textEmail.text == ""){
            let alert = UIAlertController(title: "Email Empty", message: "Please provide valid email!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else if (textPassword.text == "") {
            let alert = UIAlertController(title: "Password Empty", message: "Please provide valid password!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else {
            sendLogin(emailUser: textEmail.text!, passwordUser: textPassword.text!){
                if(self.loginObject.response.success != 200){
                    let alert = UIAlertController(title: "Somethings wrong", message: "Please check your email and password", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    
                    UserDefaults.standard.set("Bearer " + self.loginObject.response.token!, forKey: "Token")
                    UserDefaults.standard.set(self.loginObject.response.id_user, forKey: "id_user")
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.synchronize()
                    
                    let viewController = self.storyboard!.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
                    UIApplication.shared.windows.first?.rootViewController = viewController
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
            }
        }
        textPassword.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textEmail.resignFirstResponder()
        textPassword.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textEmail.resignFirstResponder()
        textPassword.resignFirstResponder()
        return true
    }
    
    func sendLogin(emailUser:String,passwordUser:String, completed: @escaping () -> ()){
        let url = GlobalVariable.urlLogin
        var components = URLComponents(string: url)!
        components.queryItems = [
            URLQueryItem(name: "email", value: emailUser),
            URLQueryItem(name: "password", value: passwordUser)
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        var request = URLRequest(url:components.url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                let output = String(data: data!, encoding: String.Encoding.utf8) as String?
                print(output!)
                do {
                    print(data!)
                    self.loginObject = try JSONDecoder().decode(LoginObject.self, from: data!)
                    print(self.loginObject.response.success)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print("JSON Error 1")
                }
            }
        }.resume()
    }

}
