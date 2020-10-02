//
//  AppliedDetailController.swift
//  layout
//
//  Created by Rama Agastya on 01/09/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class AppliedDetailController: UIViewController {

    @IBOutlet weak var FeeLabel: UILabel!
    @IBOutlet weak var PICLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var LevelLabel: UILabel!
    @IBOutlet weak var LocLabel: UILabel!
    @IBOutlet weak var CusLabel: UILabel!
    @IBOutlet weak var JobreqLabel: UILabel!
    @IBOutlet weak var JobdesLabel: UILabel!
    @IBOutlet weak var IVDetailApplied: UIImageView!
    @IBOutlet weak var JobLabel: UILabel!
    
    var jobDetail:JobSingle!
    var jobAppliedFromSegue:JobList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        JobLabel.text? = jobAppliedFromSegue!.job_name
        JobdesLabel.text? = jobAppliedFromSegue!.job_description
        JobreqLabel.text? = jobAppliedFromSegue!.job_requrment
        if let imageURL = URL(string: jobAppliedFromSegue!.category!.category_image_url) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.IVDetailApplied.image = image
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
            URLQueryItem(name: "id_job", value: String(self.jobAppliedFromSegue!.id))
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

}
