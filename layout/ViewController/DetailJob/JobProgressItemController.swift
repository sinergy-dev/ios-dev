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

class JobProgressItemController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnSelectProgressJob: UIButton!
    @IBOutlet weak var backgroudView: UIView!
    @IBOutlet weak var jobProgressPicturePickButton: UIButton!
    @IBOutlet weak var jobProgressPicture: UIImageView!
    @IBOutlet weak var inputProgress: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    let transparentView = UIView()
    let tableView = UITableView()
    
    var selectedButton = UIButton()
    var dataSource = [String]() 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroudView.isHidden = true
        jobProgressPicture.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
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
    
}
