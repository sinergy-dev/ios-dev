//
//  DashboardViewController.swift
//  layout
//
//  Created by Sinergy on 9/4/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var TVJobList: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var NameLabel: UILabel!
    
    var jobList:Job!
    var dataUser:UserSingle!
    
    var expandedCellPaths = Set<IndexPath>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupView()
        setupView()
        setupView()
        setupView()
        setupView()
        setupView()
        setupView()
        setupView()
        setupView()
        setupView()
        setupView()
        
        TVJobList.rowHeight = UITableView.automaticDimension
        TVJobList.estimatedRowHeight = 50.0

        getData {
//            print(self.jobList.job![0].category?.category_name)
            self.TVJobList.reloadData()
        }
        
        getUser {
            self.NameLabel.text? = self.dataUser!.user.name
        }
        
        TVJobList.delegate = self
        TVJobList.dataSource = self
    }
    
    func getUser(completed: @escaping () -> ()){
        let url = URL(string: GlobalVariable.urlGetAccount)
            
        var request = URLRequest(url:url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(GlobalVariable.tempToken, forHTTPHeaderField: "Authorization")
            
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
    
    private func setupView(){
        
        let buttonCategory = UIButton()
        buttonCategory.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonCategory.widthAnchor.constraint(equalToConstant: 50).isActive = true

        let url = URL(string: "https://development.sinergy-dev.xyz:2096/storage/android/image/category_image/ios.png")!
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    buttonCategory.setBackgroundImage(UIImage(data: data), for: .normal)
                }
            }
        }

        let textButtonCategory = UILabel()
        textButtonCategory.widthAnchor.constraint(equalToConstant: 60).isActive = true
        textButtonCategory.text = "Frontend Development"
        textButtonCategory.font = UIFont.systemFont(ofSize: 9.0)
        textButtonCategory.numberOfLines = 2
        textButtonCategory.textAlignment = .center

        let stackViewButton   = UIStackView()
        stackViewButton.axis  = NSLayoutConstraint.Axis.vertical
        stackViewButton.distribution  = UIStackView.Distribution.equalSpacing
        stackViewButton.alignment = UIStackView.Alignment.center
        stackViewButton.spacing   = 5.0

        stackViewButton.addArrangedSubview(buttonCategory)
        stackViewButton.addArrangedSubview(textButtonCategory)
        stackViewButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(stackViewButton)
    }
    
    func getData(completed: @escaping () -> ()){
        let url = URL(string: GlobalVariable.urlGetJobListSumm)
            
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.jobList == nil {
            return 0
        }
        return self.jobList.job!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JobListCell", for: indexPath) as? JobListCell else {
            print("failed to get cell")
            return UITableViewCell()
        }
        
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.numberStyle = .currency
        let formattedJobPrice = formatter.string(from: NSNumber(value: Int(jobList.job![indexPath.row].job_price)) as NSNumber)

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
        
        cell.CatLabel.text = jobList.job![indexPath.row].category?.category_name
        cell.JobLabel.text = jobList.job![indexPath.row].job_name
        cell.CusLabel.text = jobList.job![indexPath.row].customer?.customer_name
        cell.LocLabel.text = jobList.job![indexPath.row].location?.long_location
        cell.FeeLabel.text = formattedJobPrice
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? JobListCell {
            cell.NextView.isHidden = !cell.NextView.isHidden
            if cell.NextView.isHidden {
                expandedCellPaths.remove(indexPath)
            } else {
                expandedCellPaths.insert(indexPath)
                performSegue(withIdentifier: "toDetailJobList", sender: self)
            }
            tableView.beginUpdates()
            tableView.endUpdates()
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? DetailJobListController {
////            destination.jobListFromSegue = jobList.job![(TVJobList.indexPathForSelectedRow?.row)!]
////            print(jobList.job![(TVJobList.indexPathForSelectedRow?.row)!])
//        }
        if let destination = segue.destination as? DetailJobListController {
//            print(TVJobList.indexPathForSelectedRow?.row)
            destination.jobListFromSegue = jobList.job![1]
        }
    }
}
