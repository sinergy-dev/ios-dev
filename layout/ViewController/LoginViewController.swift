//
//  LoginViewController.swift
//  layout
//
//  Created by Rama Agastya on 01/10/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    var loginObject:LoginObject!
    var validityToken: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textEmail.delegate = self
        textPassword.delegate = self
        
        
//        if(UserDefaults.standard.bool(forKey: "isLoggedIn")){
//            checkTokenValidity(userToken: UserDefaults.standard.string(forKey: "Token")! ){
//                if (self.validityToken!){
//                    let viewController = self.storyboard!.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
//                    UIApplication.shared.windows.first?.rootViewController = viewController
//                    UIApplication.shared.windows.first?.makeKeyAndVisible()
//                }
//            }
//        }
    }
    
    @IBAction func doLogin(_ sender: Any) {
        
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
                    
                    Auth.auth().signIn(withEmail: self.textEmail.text!, password: self.textPassword.text!) { authResult, error in
                        if let error = error as NSError? {
                            if error.code == 17011 {
                                Auth.auth().createUser(withEmail: self.textEmail.text!, password: self.textPassword.text!) { authResult, error in
                                    print(Auth.auth().currentUser?.uid ?? "Nil")
                                    print("Create User Success")
                                    let viewController = self.storyboard!.instantiateViewController(withIdentifier: "launchscreen") as! UINavigationController
                                    UIApplication.shared.windows.first?.rootViewController = viewController
                                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                                }
                            } else {
                                print("Somethings wrong")
                            }
                        } else {
                            print(Auth.auth().currentUser?.uid ?? "Nil")
                            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "launchscreen") as! UINavigationController
                            UIApplication.shared.windows.first?.rootViewController = viewController
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                        }
                    }
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
                    self.loginObject = try JSONDecoder().decode(LoginObject.self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print("JSON Error 1")
                }
            }
        }.resume()
    }
    
//    func checkTokenValidity(userToken:String, completed: @escaping () -> ()){
//        let url = GlobalVariable.urlGetCheckToken
//        var request = URLRequest(url:URL(string:url)!)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        request.setValue(userToken, forHTTPHeaderField: "Authorization")
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if error == nil {
//                if((response as! HTTPURLResponse).statusCode == 200) {
//                    self.validityToken = true
//                } else {
//                    self.validityToken = false
//                }
//                DispatchQueue.main.async {
//                    completed()
//                }
//            }
//        }.resume()
//    }

}
