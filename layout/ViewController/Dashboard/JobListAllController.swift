//
//  JobListAllController.swift
//  layout
//
//  Created by Rama Agastya on 08/09/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class JobListAllController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var jobList:Job!

    @IBOutlet weak var TVJobListAll: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        getData {
            self.TVJobListAll.reloadData()
        }
                    
        TVJobListAll.delegate = self
        TVJobListAll.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.jobList == nil {
            return 0
        }
        return self.jobList.job!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JobListAllCell") as? JobListAllCell else { return UITableViewCell() }
        if self.jobList == nil {
            return cell
        }
        cell.JobLabel.text = jobList.job![indexPath.row].job_name
        cell.CatLabel.text = jobList.job![indexPath.row].category?.category_name
        cell.LocLabel.text = jobList.job![indexPath.row].location?.long_location
        cell.CusLabel.text = jobList.job![indexPath.row].customer?.customer_name
        
        if let imageURL = URL(string: jobList.job![indexPath.row].category!.category_image_url) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.IVJobList.image = image
                    }
                }
            }
        }
        return cell
    }
    
    func getData(completed: @escaping () -> ()){
            
        let url = GlobalVariable.urlGetJobListSumm
        
        var components = URLComponents(string: url)!
        components.queryItems = [
            URLQueryItem(name: "job_status", value: "Open")
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            
        var request = URLRequest(url:components.url!)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailJobListAll", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailJobListController {
            destination.jobListFromSegue = jobList.job![(TVJobListAll.indexPathForSelectedRow?.row)!]
        }
    }

}
