//
//  PaymentController.swift
//  layout
//
//  Created by Rama Agastya on 24/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit
import SkeletonView

class PaymentController: UIViewController, UITableViewDelegate, SkeletonTableViewDataSource  {
    
    @IBOutlet weak var TVPayment: UITableView!
    
    var paymentList:Payment!
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.showAnimatedGradientSkeleton()
        getData {
//            print("Successfull")
            self.TVPayment.reloadData()
            self.view.hideSkeleton()
        }
        TVPayment.refreshControl = refresher
                    
        TVPayment.delegate = self
        TVPayment.dataSource = self
    }
    
    @objc
    private func refresh(sender: UIRefreshControl){
        getData {
            self.TVPayment.reloadData()
        }
        sender.endRefreshing()
    }
    
    func getData(completed: @escaping () -> ()){
        
        let url = URL(string: GlobalVariable.urlGetPayment)
        
        var request = URLRequest(url:url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(UserDefaults.standard.string(forKey: "Token")!, forHTTPHeaderField: "Authorization")
            
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                do {
                    self.paymentList = try JSONDecoder().decode(Payment.self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print("JSON Error")
                }
            }
        }.resume()
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "PaymentCell"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.paymentList == nil {
            return 0
        }
        return self.paymentList.payment!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell") as? PaymentCell else { return UITableViewCell() }
        if self.paymentList == nil {
            return cell
        }
        cell.JobLabel.text = paymentList.payment![indexPath.row].job.job_name
        cell.StatusLabel.text = paymentList.payment![indexPath.row].lastest_progress.activity
        
        
        if paymentList.payment![indexPath.row].lastest_progress.activity == "Update Payment"{
            DispatchQueue.main.async {
                cell.IVPayment.image = UIImage(named: "payment_update")
            }
        } else if paymentList.payment![indexPath.row].lastest_progress.activity == "Make Payment"{
            DispatchQueue.main.async {
                cell.IVPayment.image = UIImage(named: "make_payment")
            }
        } else {
            DispatchQueue.main.async {
                cell.IVPayment.image = UIImage(named: "payment_complete")
            }
        }
        
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toPaymentDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PaymentDetailController {
            destination.paymentFromSegue = paymentList.payment![(TVPayment.indexPathForSelectedRow?.row)!]
        }
    }
}
