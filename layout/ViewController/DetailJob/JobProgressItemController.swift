//
//  JobProgressItemController.swift
//  layout
//
//  Created by SIP_Sales on 03/12/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class CellClass: UITableViewCell {
    
}

class JobProgressItemController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSelectProgressJob: UIButton!
    @IBOutlet weak var jobProgressPicturePickButton: UIButton!
    @IBOutlet weak var jobProgressPicture: UIImageView!
    @IBOutlet weak var inputProgress: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var jobProgressFromSegue:JobList!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var imagePicker  = UIImagePickerController()
    
    let transparentView = UIView()
    let tableView = UITableView()
    
    var selectedButton = UIButton()
    var dataSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.isHidden = true
        jobProgressPicture.isHidden = true
        imagePicker.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//
//        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        tableView.reloadData()
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
        }, completion: nil)
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
    
    @objc func removeTransparentView(){
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
    
    @IBAction func onClickSelectProgressJob(_ sender: Any) {
        dataSource = ["Backup semua switch existing", "Dokumentasi foto switch existing", "Pelabelan kabel", "Pre-UAT", "Migrasi Switch Aggregate", "Migrasi Switch Access", "Final UAT", "Dokumentasi Foto Switch Baru", "Penuntasan Dokumen Administrasi"]
        selectedButton = btnSelectProgressJob
        addTransparentView(frames: btnSelectProgressJob.frame)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        removeTransparentView()
        print(dataSource[indexPath.row])
    }
    
    @IBAction func jobProgressPick(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            jobProgressPicture.image = image
            jobProgressPicture.isHidden = false
            jobProgressPicturePickButton.isHidden = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func jobProgressSubmit(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Job Progress", message: "Are you sure to submit this progress?", preferredStyle: .alert)
        
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
            self.submitJobProgress(image: self.jobProgressPicture.image!){
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
    
    func submitJobProgress( image:UIImage ,completed: @escaping () -> ()){
        let url = GlobalVariable.urlUpdateJobProgress

        var components = URLComponents(string: url)!
        components.queryItems = [
            URLQueryItem(name: "id_job", value: String(jobProgressFromSegue!.id)),
            URLQueryItem(name: "detail_activity", value: inputProgress.text)
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        let filename = "job_progress.jpeg"
        let boundary = UUID().uuidString

        var request = URLRequest(url:components.url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(UserDefaults.standard.string(forKey: "Token")!, forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"documentation_progress\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
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
