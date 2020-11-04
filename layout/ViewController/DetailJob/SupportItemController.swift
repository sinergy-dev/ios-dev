//
//  SupportItemController.swift
//  layout
//
//  Created by Rama Agastya on 17/09/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class SupportItemController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var jobProgressFromSegue:JobList!
    
    var imagePicker  = UIImagePickerController()
    
    @IBOutlet weak var inputProblem: UITextField!
    @IBOutlet weak var inputReason: UITextField!
    @IBOutlet weak var jobSupportPicture: UIImageView!
    @IBOutlet weak var jobSupportPicturePickButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        jobSupportPicture.isHidden = true
        imagePicker.delegate = self
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
            self.submitJobSupport(image: self.jobSupportPicture.image!){
                _ = self.navigationController?.popViewController(animated: true)
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel){ (action) -> Void in
            print("Cancel button tapped")
        }
        
        dialogMessage.addAction(submit)
        dialogMessage.addAction(cancel)
        
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
