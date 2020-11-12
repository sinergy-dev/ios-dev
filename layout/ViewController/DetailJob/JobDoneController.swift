//
//  JobDoneController.swift
//  layout
//
//  Created by Rama Agastya on 17/09/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class JobDoneController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var jobProgressFromSegue:JobList!
    
    @IBOutlet weak var backgroundView: UIView!
    var imagePicker  = UIImagePickerController()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var inputSummary: UITextField!
    @IBOutlet weak var inputRootCause: UITextField!
    @IBOutlet weak var inputCounterMeasure: UITextField!
    
    @IBOutlet weak var jobDonePicture: UIImageView!
    @IBOutlet weak var jobDonePicturePickButton: UIButton!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.isHidden = true
        jobDonePicture.isHidden = true
        imagePicker.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func jobDonePicturePick(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            jobDonePicture.image = image
            jobDonePicture.isHidden = false
            jobDonePicturePickButton.isHidden = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func jobDoneSubmit(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Job Done", message: "Are you sure to submit this job?", preferredStyle: .alert)
        
        let submit = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            self.backgroundView.isHidden = false
            self.scrollView.isHidden = true
            
            self.activityIndicator.center = self.backgroundView.center
            self.activityIndicator.hidesWhenStopped = true
            if #available(iOS 13.0, *) {
                self.activityIndicator.style = .large
            } else {
                // Fallback on earlier versions
            }
            self.activityIndicator.color = .black
            self.backgroundView.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
            self.navigationController?.navigationBar.isHidden = true
            self.submitJobDone(image: self.jobDonePicture.image!){
                self.activityIndicator.stopAnimating()
                self.backgroundView.isHidden = true
                self.scrollView.isHidden = false
                self.navigationController?.navigationBar.isHidden = false
                self.showAlertSuccess()
//                _ = self.navigationController?.popViewController(animated: true)
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel){ (action) -> Void in
            print("Cancel button tapped")
        }
        
        dialogMessage.addAction(submit)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func showAlertSuccess() {
        let dialogMessage = UIAlertController(title: "Success", message: "Data telah ditambah", preferredStyle: .alert)
        
        let submit = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            
            _ = self.navigationController?.popViewController(animated: true)
        })
        
        dialogMessage.addAction(submit)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func submitJobDone( image:UIImage ,completed: @escaping () -> ()){
        let url = GlobalVariable.urlUpdateJobDone

        var components = URLComponents(string: url)!
        components.queryItems = [
            URLQueryItem(name: "id_job", value: String(jobProgressFromSegue!.id)),
            URLQueryItem(name: "job_summary", value: inputSummary.text),
            URLQueryItem(name: "job_rootcause", value: inputRootCause.text),
            URLQueryItem(name: "job_countermeasure", value: inputCounterMeasure.text)
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        let filename = "job_report.jpeg"
        let boundary = UUID().uuidString

        var request = URLRequest(url:components.url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(UserDefaults.standard.string(forKey: "Token")!, forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"job_documentation\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(image.jpegData(compressionQuality: 1)!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        URLSession.shared.uploadTask(with: request, from: data) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    completed()
                }
            }
        }.resume()
    }
    
    

}
