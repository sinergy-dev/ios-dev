//
//  SupportItemController.swift
//  layout
//
//  Created by Rama Agastya on 17/09/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class SupportItemController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    var jobProgressFromSegue:JobList!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var baseView: UIView!
    var imagePicker  = UIImagePickerController()
    
    @IBOutlet weak var inputProblem: UITextField!
    @IBOutlet weak var inputReason: UITextField!
    @IBOutlet weak var jobSupportPicture: UIImageView!
    @IBOutlet weak var jobSupportPicturePickButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.isHidden = true
        jobSupportPicture.isHidden = true
        imagePicker.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func jobSupportPicturePick(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            jobSupportPicture.image = image
            jobSupportPicture.isHidden = false
            jobSupportPicturePickButton.isHidden = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func jobSupportSubmit(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Job Support", message: "Are you sure to submit this support?", preferredStyle: .alert)
        
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
            self.submitJobSupport(image: self.jobSupportPicture.image!){
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
    
    func submitJobSupport( image:UIImage ,completed: @escaping () -> ()){
        let url = GlobalVariable.urlUpdateJobSupport

        var components = URLComponents(string: url)!
        components.queryItems = [
            URLQueryItem(name: "id_job", value: String(jobProgressFromSegue!.id)),
            URLQueryItem(name: "problem_support", value: inputProblem.text),
            URLQueryItem(name: "reason_support", value: inputReason.text)
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        let filename = "job_support.jpeg"
        let boundary = UUID().uuidString

        var request = URLRequest(url:components.url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(UserDefaults.standard.string(forKey: "Token")!, forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"picture_support\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
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
