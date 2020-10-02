//
//  SupportController.swift
//  layout
//
//  Created by Rama Agastya on 27/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class SupportController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TVSupport: UITableView!
    
    var supportList:Support!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData {
//            print("Successfull")
            self.TVSupport.reloadData()
        }
                    
        TVSupport.delegate = self
        TVSupport.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.supportList == nil {
            return 0
        }
        return self.supportList.job_support!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SupportCell") as? SupportCell else {return UITableViewCell()}
        
        if self.supportList == nil {
            return cell
        }
        
        cell.JobLabel.text = supportList.job_support![indexPath.row].job.job_name
        
        let sourceFormat = DateFormatter()
        sourceFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let destinationFormat = DateFormatter()
        destinationFormat.dateFormat = "dd MMMM yyyy"

        let dateTime = destinationFormat.string(from: sourceFormat.date(from:self.supportList.job_support![indexPath.row].date_add)!)
        
        cell.DateLabel.text = dateTime
        
        cell.StatusLabel.text = supportList.job_support![indexPath.row].status
        
        if let imageURL = URL(string: supportList.job_support![indexPath.row].job_category.category_image_url) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.IVSupport.image = image
                    }
                }
            }
        }
        
        return cell
    }
    
    func getData(completed: @escaping() -> ()){
        let url = URL(string: GlobalVariable.urlGetSupport)
        
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(UserDefaults.standard.string(forKey: "Token")!, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                do {
                    self.supportList = try JSONDecoder().decode(Support.self, from: data!)
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
        performSegue(withIdentifier: "toSupportDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SupportDetailController {
            destination.supportFromSegue = supportList.job_support![(TVSupport.indexPathForSelectedRow?.row)!]
        }
    }
}
