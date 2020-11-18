//
//  JobListAllController.swift
//  layout
//
//  Created by Rama Agastya on 08/09/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit
import SkeletonView

class JobListAllController: UIViewController, UITableViewDelegate, SkeletonTableViewDataSource {
    
    var jobList:Job!

    @IBOutlet weak var TVJobListAll: UITableView!
    
    let refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TVJobListAll.refreshControl = refresher
                    
        TVJobListAll.delegate = self
        TVJobListAll.dataSource = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {

            self.TVJobListAll.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.2))
        })
    }
    
    
    @objc
    private func refresh(sender: UIRefreshControl){
        getData {
            self.TVJobListAll.reloadData()
        }
        sender.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.jobList == nil {
            TVJobListAll.isSkeletonable = true
            TVJobListAll.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .concrete), animation: nil, transition: .crossDissolve(0.2))
        }
        getData {
            self.TVJobListAll.reloadData()
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "JobListAllCell"
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
        
        let url = URL(string: GlobalVariable.urlGetJobListbyEngineer)
            
        var request = URLRequest(url:url!)
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
        performSegue(withIdentifier: "toDetailJobListAll", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailJobListController {
            destination.jobListFromSegue = jobList.job![(TVJobListAll.indexPathForSelectedRow?.row)!]
        }
    }

}
