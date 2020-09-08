//
//  ProgressDetailController.swift
//  layout
//
//  Created by Rama Agastya on 02/09/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class ProgressDetailController: UIViewController{

    @IBOutlet weak var IVProgressDetail: UIImageView!
    @IBOutlet weak var JobLabel: UILabel!
    @IBOutlet weak var JobdesLabel: UILabel!
    @IBOutlet weak var JobreqLabel: UILabel!
    @IBOutlet weak var TVProgressJob: UITableView!
    
    var jobProgressFromSegue:JobList!
    var jobDetail:JobSingle!
    
    var expandedIndexSet : IndexSet = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        JobLabel.text? = jobProgressFromSegue!.job_name
        JobdesLabel.text? = jobProgressFromSegue!.job_description
        JobreqLabel.text? = jobProgressFromSegue!.job_requrment
        if let imageURL = URL(string: jobProgressFromSegue!.category!.category_image_url) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.IVProgressDetail.image = image
                    }
                }
            }
        }
        
        getData {
            self.TVProgressJob.reloadData()
        }
        
        TVProgressJob.delegate = self
        TVProgressJob.dataSource = self
        
        TVProgressJob.rowHeight = UITableView.automaticDimension
        TVProgressJob.estimatedRowHeight = 280.0
    }
    
    func getData(completed: @escaping () -> ()){
                
        let url = GlobalVariable.urlGetProgressJob
        
        var components = URLComponents(string: url)!
        components.queryItems = [
            URLQueryItem(name: "id_job", value: String(self.jobProgressFromSegue!.id))
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        var request = URLRequest(url:components.url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(GlobalVariable.tempToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                do {
                    self.jobDetail = try JSONDecoder().decode(JobSingle.self, from: data!)
                    
                    var jobTemp = try JSONDecoder().decode(JobSingle.self, from: data!)
                    jobTemp.job!.progress = jobTemp.job!.progress!.filter{$0.id_activity == "5"}
                    var dateTemp = [String]()
                    var tempDetail_activity = String()
                    var jobProgresTemp = [JobProgress]()
                    for progres in jobTemp.job!.progress! {
                        if !dateTemp.contains(String(progres.date_time.prefix(10))) {
                            dateTemp.append(String(progres.date_time.prefix(10)))
                            tempDetail_activity = " - " + String(progres.detail_activity.components(separatedBy: " - ")[1]) + "\n"
                            jobProgresTemp.append(
                                JobProgress(
                                    id: progres.id,
                                    id_job: progres.id_job,
                                    id_user: progres.id_user,
                                    id_activity: progres.id_activity,
                                    date_time: progres.date_time,
                                    detail_activity: " - " + String(progres.detail_activity.components(separatedBy: " - ")[1]) + "\n"
                                )
                            )
                        } else {
                            tempDetail_activity += " - " + String(progres.detail_activity.components(separatedBy: " - ")[1]) + "\n"
                            jobProgresTemp[jobProgresTemp.count - 1].detail_activity = tempDetail_activity
                        }
                        
                    }
                    self.jobDetail.job!.progress! = jobProgresTemp
//                    for progressTemp in jobProgresTemp {
//                        print("Date " + progressTemp.date_time)
//                        print("Activity \n" + progressTemp.detail_activity)
//                    }
                    
                    
                    
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

extension ProgressDetailController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.jobDetail == nil {
            return 0
        }
        return self.jobDetail.job!.progress!.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProgressJobCell", for: indexPath) as? ProgressJobCell else {
            print("failed to get cell")
            return UITableViewCell()
        }
        
        let sourceFormat = DateFormatter()
        sourceFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let destinationFormat = DateFormatter()
        destinationFormat.dateFormat = "dd MMMM yyyy"
        
        let dateTime = destinationFormat.string(from: sourceFormat.date(from:self.jobDetail.job!.progress![indexPath.row].date_time)!)
    
        cell.DayLabel.text = "Day"
        cell.DateLabel.text = dateTime
        cell.ActivityLabel.text = jobDetail.job!.progress![indexPath.row].detail_activity
        //if the cell is expanded
        if expandedIndexSet.contains(indexPath.row) {
          // the label can take as many lines it need to display all text
          cell.ActivityLabel.numberOfLines = 0
        } else {
          // if the cell is contracted
          // only show first 3 lines
          cell.ActivityLabel.numberOfLines = 1
        }
        
        
        return cell
    }
}

extension ProgressDetailController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // if the cell is already expanded, remove it from the indexset to contract it
        if(expandedIndexSet.contains(indexPath.row)){
            expandedIndexSet.remove(indexPath.row)
        } else {
            // if the cell is not expanded, add it to the indexset to expand it
            expandedIndexSet.insert(indexPath.row)
        }
        
        // the animation magic happens here
        // this will call cellForRow for the indexPath you supplied, and animate the changes
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
