//
//  PaymentDetailController.swift
//  layout
//
//  Created by Rama Agastya on 27/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class PaymentDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var IVTransfer: UIImageView!
    @IBOutlet weak var IVPayment: UIImageView!
    @IBOutlet weak var JobLabel: UILabel!
    @IBOutlet weak var TVPaymentDetail: UITableView!
    @available(iOS 13.0, *)
    @IBAction func btnImage(_ sender: Any) {
        /*let dialogMessage = UIAlertController(title: "Transfer", message: paymentFromSegue.job.job_name, preferredStyle: .alert)
        
        let image = URL(string: paymentFromSegue.payment_invoice_URL)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: image!)
                if let data = data {
                   let image = UIImage(data: data)
                   DispatchQueue.main.async {
                        dialogMessage.addImage(image: image!)
                    }
                }
            }
        
        dialogMessage.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        
        self.present(dialogMessage, animated: true, completion: nil)*/
        
        let ImageView:DetailImagePaymentController = self.storyboard?.instantiateViewController(identifier: "DetailImagePaymentController") as! DetailImagePaymentController
        
        ImageView.selectedImage = self.paymentFromSegue.payment_invoice_URL
        
        self.navigationController?.pushViewController(ImageView, animated: true)
    }
    
    var paymentFromSegue:PaymentList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageURL = URL(string: paymentFromSegue.job_category_image) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.IVPayment.image = image
                    }
                }
            }
        }
        
        self.JobLabel.text? = self.paymentFromSegue.job.job_name
        
        if let imageURL2 = URL(string: paymentFromSegue.payment_invoice_URL) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL2)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.IVTransfer.image = image
                    }
                }
            }
        }
        
        TVPaymentDetail.delegate = self
        TVPaymentDetail.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentFromSegue!.progress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentDetailCell") as? PaymentDetailCell else { return UITableViewCell() }
        
        let sourceFormat = DateFormatter()
        sourceFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let destinationFormat = DateFormatter()
        destinationFormat.dateFormat = "dd MMMM yyyy"

        let dateTime = destinationFormat.string(from: sourceFormat.date(from: self.paymentFromSegue!.progress[indexPath.row].date_time)!)
        
        cell.DateDetailLabel.text = dateTime
        
        cell.StatusDetailLabel.text = paymentFromSegue!.progress[indexPath.row].activity
        
        if paymentFromSegue!.progress[indexPath.row].activity == "Update Payment"{
            DispatchQueue.main.async {
                cell.IVStatusPayment.image = UIImage(named: "payment_update")
            }
        } else if paymentFromSegue!.progress[indexPath.row].activity == "Make Payment"{
            DispatchQueue.main.async {
                cell.IVStatusPayment.image = UIImage(named: "make_payment")
            }
        } else {
            DispatchQueue.main.async {
                cell.IVStatusPayment.image = UIImage(named: "payment_complete")
            }
        }
        
        return cell
        
    }

}
