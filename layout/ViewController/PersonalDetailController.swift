//
//  PersonalDetailController.swift
//  layout
//
//  Created by Rama Agastya on 18/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class PersonalDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var jobList:Job!

    @IBOutlet weak var TVPersonalDetail: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getData {
//            print("Successfull")
            self.TVPersonalDetail.reloadData()
        }
                    
        TVPersonalDetail.delegate = self
        TVPersonalDetail.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.jobList == nil {
            return 0
        }
        return self.jobList.job!.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JobCell") as? PersonalDetailCell else { return UITableViewCell() }
        if self.jobList == nil {
            return cell
        }
        cell.JobLabel.text = jobList.job![indexPath.row].job_name
        cell.CategoryLabel.text = jobList.job![indexPath.row].category?.category_name
        cell.LocLabel.text = jobList.job![indexPath.row].location?.long_location
        cell.CusLabel.text = jobList.job![indexPath.row].customer?.customer_name
        cell.StatusLabel.text = jobList.job![indexPath.row].job_status
        
        if let imageURL = URL(string: jobList.job![indexPath.row].category!.category_image_url) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.IVPersonalDetail.image = image
                    }
                }
            }
        }
            
        return cell
    }
        
    func getData(completed: @escaping () -> ()){
            
        let url = URL(string: GlobalVariable.urlGetJobList)
            
        var request = URLRequest(url:url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(GlobalVariable.tempToken, forHTTPHeaderField: "Authorization")
            
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                do {
                    self.jobList = try JSONDecoder().decode(Job.self, from: data!)
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
