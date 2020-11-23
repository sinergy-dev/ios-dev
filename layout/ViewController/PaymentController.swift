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
    
    let refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        //refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TVPayment.refreshControl = refresher
        
        TVPayment.delegate = self
        TVPayment.dataSource = self
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {

            self.TVPayment.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.2))
        })
    }
    
    @objc
    private func refresh(sender: UIRefreshControl){
        getData {
            self.TVPayment.reloadData()
        }
        sender.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.paymentList == nil {
            TVPayment.isSkeletonable = true
            TVPayment.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .crossDissolve(0.2))
        }
        getData {
            self.TVPayment.reloadData()
        }
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
        
        if self.paymentList.payment!.count == 0 {
            tableView.SetView(title: "You don't have payment history.", message: "Please finish your job", messageImage: #imageLiteral(resourceName: "not_found"))
        }
        else {
            tableView.restoreView()
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
        cell.TimeLabel.text = paymentList.payment![indexPath.row].date_huminize
        
        
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

extension UITableView {
    
    func SetView(title: String, message: String, messageImage: UIImage) {
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let messageImageView = UIImageView()
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        messageImageView.backgroundColor = .clear
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageImageView)
        emptyView.addSubview(messageLabel)
        
        messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -20).isActive = true
        messageImageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        messageImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 10).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageImageView.image = messageImage
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        UIView.animate(withDuration: 1, animations: {
            
            messageImageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
        }, completion: { (finish) in
            UIView.animate(withDuration: 1, animations: {
                messageImageView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 10))
            }, completion: { (finishh) in
                UIView.animate(withDuration: 1, animations: {
                    messageImageView.transform = CGAffineTransform.identity
                })
            })
            
        })
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restoreView() {
        
        self.backgroundView = nil
        self.separatorStyle = .singleLine
        
    }
    
}
