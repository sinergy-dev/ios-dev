//
//  AcceptedController.swift
//  layout
//
//  Created by Rama Agastya on 31/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class AcceptedController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var TVAccepted: UITableView!
    var jobList:Job!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData {
//            print("Successfull")
            
            self.TVAccepted.reloadData()
        }
        
        TVAccepted.refreshControl = refresher
                            
        TVAccepted.delegate = self
        TVAccepted.dataSource = self
    }
    
    let refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    @objc
    private func refresh(sender: UIRefreshControl){
        getData {
            self.TVAccepted.reloadData()
        }
        sender.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.jobList == nil {
            return 0
        }
        return self.jobList.job!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AcceptedCell") as? AcceptedCell else { return UITableViewCell() }
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
                        cell.IVAccepted.image = image
                    }
                }
            }
        }
        return cell
    }
    
    func getData(completed: @escaping () -> ()){
            
        let url = GlobalVariable.urlGetJobList
        
        var components = URLComponents(string: url)!
        components.queryItems = [
            URLQueryItem(name: "job_status", value: "Ready")
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            
        var request = URLRequest(url:components.url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(UserDefaults.standard.string(forKey: "Token")!, forHTTPHeaderField: "Authorization")
        
        
            
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
        performSegue(withIdentifier: "toAcceptedDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AcceptedDetailController {
            destination.jobAcceptedFromSegue = jobList.job![(TVAccepted.indexPathForSelectedRow?.row)!]
        }
    }

}
