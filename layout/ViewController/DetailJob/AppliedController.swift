//
//  AppliedController.swift
//  layout
//
//  Created by Rama Agastya on 31/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit
import SkeletonView

class AppliedController: UIViewController, UITableViewDelegate, SkeletonTableViewDataSource {

    @IBOutlet weak var TVApllied: UITableView!
    var jobList:Job!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TVApllied.refreshControl = refresher
                    
        TVApllied.delegate = self
        TVApllied.dataSource = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {

            self.TVApllied.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.2))
        })
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
            self.TVApllied.reloadData()
        }
        sender.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.jobList == nil {
            TVApllied.isSkeletonable = true
            TVApllied.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .concrete), animation: nil, transition: .crossDissolve(0.2))
        }
        getData {
            self.TVApllied.reloadData()
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "AppliedCell"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.jobList == nil {
            return 0
        }
        return self.jobList.job!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AppliedCell") as? AppliedCell else { return UITableViewCell() }
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
                        cell.IVApplied.image = image
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
            URLQueryItem(name: "job_status", value: "Open")
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
        performSegue(withIdentifier: "toAppliedDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AppliedDetailController {
            destination.jobAppliedFromSegue = jobList.job![(TVApllied.indexPathForSelectedRow?.row)!]
        }
    }
}
