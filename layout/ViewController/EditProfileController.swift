//
//  EditProfileController.swift
//  layout
//
//  Created by Rama Agastya on 14/09/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class EditProfileController: UIViewController {

    @IBOutlet weak var IVEditProfile: UIImageView!
    @IBOutlet weak var ETName: UITextField!
    @IBOutlet weak var ETEmail: UITextField!
    @IBOutlet weak var ETNumber: UITextField!
    @IBOutlet weak var ETAddress: UITextField!
    
    @IBAction func btnSubmit(_ sender: Any) {
        self.updateProfile(updateEmail: (ETEmail.text ?? ""), updateName: (ETName.text ?? ""), updatePhone: (ETNumber.text ?? ""), updateAddress: (ETAddress.text ?? "")){
            self.dialogMessage()
        }
    }
    var dataUser:UserSingle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData {

            self.ETName.text? = self.dataUser!.user.name
            self.ETNumber.text? = self.dataUser!.user.phone
            self.ETEmail.text? = self.dataUser!.user.email
            self.ETAddress.text? = self.dataUser!.user.address
            
            if let imageURL = URL(string: self.dataUser!.user.photo_image_url) {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imageURL)
                    if let data = data {
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            self.IVEditProfile.image = image
                        }
                    }
                }
            }
        }
    }
    
    func dialogMessage() {
        let dialogMessage = UIAlertController(title: "Hi " + dataUser!.user.name, message: "Successfully Update Profile", preferredStyle: .alert)
        
        let submit = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        
        dialogMessage.addAction(submit)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func updateProfile(updateEmail:String, updateName:String, updatePhone:String, updateAddress:String, completed: @escaping () -> ()) {
        let url = GlobalVariable.urlUpdateProfile

        var components = URLComponents(string: url)!
        components.queryItems = [
            URLQueryItem(name: "email", value: updateEmail),
            URLQueryItem(name: "name", value: updateName),
            URLQueryItem(name: "phone", value: updatePhone),
            URLQueryItem(name: "address", value: updateAddress)
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        var request = URLRequest(url:components.url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(UserDefaults.standard.string(forKey: "Token")!, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    completed()
                }
            }
        }.resume()
    }
    
    func getData(completed: @escaping () -> ()){
            
        let url = GlobalVariable.urlGetAccount
        
        let components = URLComponents(string: url)!
        var request = URLRequest(url:components.url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(UserDefaults.standard.string(forKey: "Token")!, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                do {
                    self.dataUser = try JSONDecoder().decode(UserSingle.self, from: data!)
                    
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print("JSON Error")
                }
            }
        }.resume()
    }

}
