//
//  AcceptedDetailController.swift
//  layout
//
//  Created by Rama Agastya on 02/09/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class AcceptedDetailController: UIViewController {
    @IBOutlet weak var IVAcceptedDetail: UIImageView!
    @IBOutlet weak var JobLabel: UILabel!
    @IBOutlet weak var JobdesLabel: UILabel!
    @IBOutlet weak var JobreqLabel: UILabel!
    @IBOutlet weak var CusLabel: UILabel!
    @IBOutlet weak var LocLabel: UILabel!
    @IBOutlet weak var LevelLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var PICLabel: UILabel!
    @IBOutlet weak var FeeLabel: UILabel!
    
    @IBAction func btnStart(_ sender: Any) {
        self.startJob {
            self.dialogMessage()
            
        }
        
    }
    
    var jobDetail:JobSingle!
    var jobAcceptedFromSegue:JobList!

    override func viewDidLoad() {
        super.viewDidLoad()

        JobLabel.text? = jobAcceptedFromSegue!.job_name
        JobdesLabel.text? = jobAcceptedFromSegue!.job_description
        JobreqLabel.text? = jobAcceptedFromSegue!.job_requrment
        if let imageURL = URL(string: jobAcceptedFromSegue!.category!.category_image_url) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.IVAcceptedDetail.image = image
                    }
                }
            }
        }
        
        getData {
            let sourceFormat = DateFormatter()
            sourceFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"

            let destinationFormat = DateFormatter()
            destinationFormat.dateFormat = "MMM dd yyyy"
            
            let dateStart = destinationFormat.string(from: sourceFormat.date(from: self.jobDetail.job!.date_start)!)
            let dateFinish = destinationFormat.string(from: sourceFormat.date(from: self.jobDetail.job!.date_end)!)
            
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "id_ID")
            formatter.numberStyle = .currency
            let formattedJobPrice = formatter.string(from: NSNumber(value: Int(self.jobDetail.job!.job_price)) as NSNumber)
            
            self.CusLabel.text? = self.jobDetail.job!.customer!.customer_name
            self.LocLabel.text? = self.jobDetail.job!.location!.long_location
            self.PICLabel.text? = self.jobDetail.job!.pic!.pic_name
            self.LevelLabel.text? = self.jobDetail.job!.level!.level_name + " [" + self.jobDetail.job!.level!.level_description + "]"
            
            self.DateLabel.text? = dateStart + " to " + dateFinish
            self.FeeLabel.text? = formattedJobPrice!
        }
    }
    
    func getData(completed: @escaping () -> ()){
            
        let url = GlobalVariable.urlGetJobDetail
        
        var components = URLComponents(string: url)!
        components.queryItems = [
            URLQueryItem(name: "id_job", value: String(self.jobAcceptedFromSegue!.id))
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        var request = URLRequest(url:components.url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(GlobalVariable.tempToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                do {
                    self.jobDetail = try JSONDecoder().decode(JobSingle.self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print("JSON Error")
                }
            }
        }.resume()
    }
    
    func dialogMessage() {
        let dialogMessage = UIAlertController(title: jobAcceptedFromSegue.job_name, message: "Successfully Start Job", preferredStyle: .alert)
        
        let submit = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        
        dialogMessage.addAction(submit)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func startJob(completed: @escaping () -> ()) {
        let url = GlobalVariable.urlJobStart

        var components = URLComponents(string: url)!
        components.queryItems = [
            URLQueryItem(name: "id_job", value: String(jobAcceptedFromSegue!.id))
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        var request = URLRequest(url:components.url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(GlobalVariable.tempToken, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    completed()
                }
            }
        }.resume()
    }

}
