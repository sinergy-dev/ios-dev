//
//  DetailJobListController.swift
//  layout
//
//  Created by Rama Agastya on 08/09/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class DetailJobListController: UIViewController {
    
    @IBOutlet weak var IVDetailJob: UIImageView!
    @IBOutlet weak var JobLabel: UILabel!
    @IBOutlet weak var JobDescLabel: UILabel!
    @IBOutlet weak var JobReqLabel: UILabel!
    @IBOutlet weak var CusLabel: UILabel!
    @IBOutlet weak var LocLabel: UILabel!
    @IBOutlet weak var LevelLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var PICLabel: UILabel!
    @IBOutlet weak var FeeLabel: UILabel!

    
    var jobListFromSegue:JobList!
    var jobDetail:JobSingle!
    
    @IBAction func btnApply(_ sender: Any) {
        self.dialogMessage()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        print(jobListFromSegue!)

        JobLabel.text? = jobListFromSegue!.job_name
        JobDescLabel.text? = jobListFromSegue!.job_description
        JobReqLabel.text? = jobListFromSegue!.job_requrment
        if let imageURL = URL(string: jobListFromSegue!.category!.category_image_url) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.IVDetailJob.image = image
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
            
        let url = GlobalVariable.urlGetJobOpen
        
        var components = URLComponents(string: url)!
        components.queryItems = [
            URLQueryItem(name: "id_job", value: String(self.jobListFromSegue!.id))
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        var request = URLRequest(url:components.url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(UserDefaults.standard.string(forKey: "Token")!, forHTTPHeaderField: "Authorization")
        
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
        let dialogMessage = UIAlertController(title: "Are you sure to take this job?", message: jobListFromSegue!.job_name , preferredStyle: .alert)
        
        let submit = UIAlertAction(title: "Accept", style: .default, handler: { (action) -> Void in
            self.applyJob {
                self.navigationController?.popViewController(animated: true)
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel){ (action) -> Void in
        }
        
        dialogMessage.addAction(submit)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func applyJob(completed: @escaping () -> ()) {
        let url = GlobalVariable.urlApplyJob

        var components = URLComponents(string: url)!
        components.queryItems = [
            URLQueryItem(name: "id_job", value: String(jobListFromSegue!.id))
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

}
