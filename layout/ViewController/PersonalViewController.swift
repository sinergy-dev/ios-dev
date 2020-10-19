//
//  PersonalViewController.swift
//  layout
//
//  Created by Rama Agastya on 18/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit
import FirebaseAuth

class PersonalViewController: UIViewController {
    
    var dataUser:UserSingle!

    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var PhoneLabel: UILabel!
    @IBOutlet weak var JobLabel: UILabel!
    @IBOutlet weak var SkillLabel: UILabel!
    @IBOutlet weak var FeeLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var AddressLabel: UILabel!
    @IBOutlet weak var IVProfile: UIImageView!
    @IBAction func btnEdit(_ sender: Any) {
        //performSegue(withgIdentifier: "toEditProfile", sender: sender)
        //if let destinationViewController = segue.destination as? EditProfileController {
          //if let button = sender as? UIButton {
            //      EditProfileController.<buttonIndex> = button.tag
                  // Note: add/define var buttonIndex: Int = 0 in <YourDestinationViewController> and print there in viewDidLoad.
          //}
        //}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData {
            print(self.dataUser!.user.name)
            let sourceFormat = DateFormatter()
            sourceFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"

            let destinationFormat = DateFormatter()
            destinationFormat.dateFormat = "dd MMM yyyy"

            let dateJoin = destinationFormat.string(from: sourceFormat.date(from: self.dataUser!.user.date_of_join)!)

            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "id_ID")
            formatter.numberStyle = .currency
            let formattedFee = formatter.string(from: NSNumber(value: Int(self.dataUser!.user.fee_engineer_count)) as NSNumber)

            self.NameLabel.text? = self.dataUser!.user.name
            self.PhoneLabel.text? = self.dataUser!.user.phone
            self.EmailLabel.text? = self.dataUser!.user.email
            self.JobLabel.text? = "Job Applied: " + String(self.dataUser!.user.job_engineer_count) + " Jobs"
            self.SkillLabel.text? = "Skills: " + self.dataUser!.user.category_engineer
            self.DateLabel.text? = "Join Date: " + dateJoin
            self.FeeLabel.text? = "Engineer's Fee: " + formattedFee!
            self.AddressLabel.text? = "Address:" + self.dataUser!.user.address
            
            if let imageURL = URL(string: self.dataUser!.user.photo_image_url) {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imageURL)
                    if let data = data {
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            self.IVProfile.image = image
                        }
                    }
                }
            }
        }
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
    
    @IBAction func doLogout(_ sender: Any) {
        UserDefaults.standard.set(false,forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }

        
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "loginView")
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
}
