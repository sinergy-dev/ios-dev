//
//  ProgressDetailController.swift
//  layout
//
//  Created by Rama Agastya on 02/09/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class ProgressDetailController: UIViewController{
    
    var actionButton : ActionButton!

    @IBOutlet weak var IVProgressDetail: UIImageView!
    @IBOutlet weak var JobLabel: UILabel!
    @IBOutlet weak var JobdesLabel: UILabel!
    @IBOutlet weak var JobreqLabel: UILabel!
    @IBOutlet weak var TVProgressJob: UITableView!
    
    var jobProgressFromSegue:JobList!
    var jobDetail:JobSingle!
    
    var isJobDone = false
    
    let alertService = AlertService()
    
    var expandedIndexSet : IndexSet = []
    var dayCounter=[String]()
    
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
        
        print(self.isJobDone)
        print("tes")
        
        getData {
            self.TVProgressJob.reloadData()
//            self.TVProgressJob.layoutIfNeeded()
//            self.TVProgressJob.heightAnchor.constraint(equalToConstant: self.TVProgressJob.contentSize.height).isActive = true
        }
        
        TVProgressJob.delegate = self
        TVProgressJob.dataSource = self
        
        TVProgressJob.rowHeight = UITableView.automaticDimension
        TVProgressJob.estimatedRowHeight = 280.0
        
        if !isJobDone {
            setupButtons()
        }
        print(self.isJobDone)
        
    }
    
    func setupButtons() {
        let progress = ActionButtonItem(title: "Progress", image: #imageLiteral(resourceName: "job_on_progress"))
        progress.action = {
            item in self.Progress()
            self.actionButton.toggleMenu()
        }
        let request = ActionButtonItem(title: "Request", image: #imageLiteral(resourceName: "job_request"))
        request.action = {
            item in self.RequestItem()
            self.actionButton.toggleMenu()
        }
        let done = ActionButtonItem(title: "Job Done", image: #imageLiteral(resourceName: "job_done"))
        done.action = {
            item in self.JobDone()
            self.actionButton.toggleMenu()
        }
        let support = ActionButtonItem(title: "Get Support", image: #imageLiteral(resourceName: "get_help"))
        support.action = {
            item in self.SupportItem()
            self.actionButton.toggleMenu()
        }
        actionButton = ActionButton(attachedToView: self.view, items: [progress, request, support, done])
        actionButton.setTitle("+", forState: UIControl.State())
        actionButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        actionButton.action = { button in button.toggleMenu()}
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toJobDoneView" {
            if let destination = segue.destination as? JobDoneController {
                destination.jobProgressFromSegue = self.jobProgressFromSegue
            }
        }
        
        if segue.identifier == "toJobRequestSupportView" {
            if let destination = segue.destination as? SupportItemController {
                destination.jobProgressFromSegue = self.jobProgressFromSegue
            }
        }
        
        if segue.identifier == "toJobRequestItemView" {
            if let destination = segue.destination as? RequestItemController {
                destination.jobProgressFromSegue = self.jobProgressFromSegue
            }
        }
    }
    
    func RequestItem() {
        performSegue(withIdentifier: "toJobRequestItemView", sender: nil)
    }
    
    func SupportItem() {
        performSegue(withIdentifier: "toJobRequestSupportView", sender: nil)
    }
    
    func JobDone() {
        performSegue(withIdentifier: "toJobDoneView", sender: nil)
    }
    
    func Progress() {
//        let alert = alertService.alert(title: "Job Progress", buttonTitle: "Submit"){
//            print("you tapped submit button")
//            print(self.alertService.getInput())
//            self.updateJobProgress(updateNote: (self.alertService.getInput())){
//                self.TVProgressJob.reloadData()
//            }
//        }
//        present(alert, animated: true)
        performSegue(withIdentifier: "toJobProgressView", sender: nil)
        
    }
    
//    func Progress() {
//        // Declare Alert message
//        let dialogMessage = UIAlertController(title: "Job Progress", message: "Please Insert your progress", preferredStyle: .alert)
//        // Add text field
//        dialogMessage.addTextField(configurationHandler: { textField in
//            textField.placeholder = "Add Progress Here"
//        })
//
//        let submit = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
//            print("Ok button tapped")
//            self.updateJobProgress(updateNote: (dialogMessage.textFields?.first?.text ?? "")){
//                self.TVProgressJob.reloadData()
//            }
//            print("Job Progress = \(dialogMessage.textFields?.first?.text ?? "")")
//        })
//
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel){ (action) -> Void in
//            print("Cancel button tapped")
//        }
//
//        dialogMessage.addAction(submit)
//        dialogMessage.addAction(cancel)
//
//        self.present(dialogMessage, animated: true, completion: nil)
//    }
    
    func updateJobProgress(updateNote:String, completed: @escaping () -> ()){
        let url = GlobalVariable.urlUpdateJobProgress

        var components = URLComponents(string: url)!
        components.queryItems = [
            URLQueryItem(name: "id_job", value: String(jobProgressFromSegue!.id)),
            URLQueryItem(name: "detail_activity", value: updateNote)
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        var request = URLRequest(url:components.url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(UserDefaults.standard.string(forKey: "Token")!, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                do {
                    print(data!)
                    let jobProgressTemp:JobProgress = try JSONDecoder().decode(JobProgress.self, from: data!)
                    if(self.jobDetail != nil){
                        if(self.jobDetail.job!.progress![self.jobDetail.job!.progress!.count - 1].date_time.prefix(10) == jobProgressTemp.date_time.prefix(10)){
                            self.jobDetail.job!.progress![self.jobDetail.job!.progress!.count - 1].detail_activity = self.jobDetail.job!.progress![self.jobDetail.job!.progress!.count - 1].detail_activity + " - " +  String(jobProgressTemp.detail_activity.components(separatedBy: " - ")[1])
                        } else {
                            self.jobDetail.job!.progress?.append(jobProgressTemp)
                        }
                    }
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print("JSON Error")
                }
            }
        }.resume()
    }
    
    @IBAction func btnProgress(_ sender: Any) {
        self.Progress()
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
        request.setValue(UserDefaults.standard.string(forKey: "Token")!, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                do {
                    self.jobDetail = try JSONDecoder().decode(JobSingle.self, from: data!)
                    
                    for progresTemp in self.jobDetail.job!.progress! {
                        if progresTemp.id_activity == "6" {
                            self.isJobDone = true
                        }
                    }
                    print(self.isJobDone)
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
                            self.dayCounter.append("Day 13")
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

@available(iOS 13.0, *)
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
    
//        cell.DayLabel.text = dayCounter[indexPath.row]
        cell.DayLabel.text = "1"
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

@available(iOS 13.0, *)
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
