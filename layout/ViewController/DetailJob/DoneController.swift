//
//  DoneController.swift
//  layout
//
//  Created by Rama Agastya on 31/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit
import SkeletonView

class DoneController: UIViewController, UITableViewDelegate, SkeletonTableViewDataSource {

    @IBOutlet weak var TVDone: UITableView!
    var jobList:Job!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TVDone.refreshControl = refresher
                    
        TVDone.delegate = self
        TVDone.dataSource = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {

            self.TVDone.stopSkeletonAnimation()
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
            self.TVDone.reloadData()
        }
        sender.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.jobList == nil {
            TVDone.isSkeletonable = true
            TVDone.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .concrete), animation: nil, transition: .crossDissolve(0.2))
        }
        getData {
            self.TVDone.reloadData()
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "DoneCell"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.jobList == nil {
            return 0
        }
        return self.jobList.job!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DoneCell") as? DoneCell else { return UITableViewCell() }
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
                        cell.IVDone.image = image
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
            URLQueryItem(name: "job_status", value: "Done")
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
        performSegue(withIdentifier: "toDoneDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DoneDetailController {
            destination.jobDoneFromSegue = jobList.job![(TVDone.indexPathForSelectedRow?.row)!]
        }
    }

}
