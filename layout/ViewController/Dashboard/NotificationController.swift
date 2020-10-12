//
//  NotificationController.swift
//  layout
//
//  Created by Rama Agastya on 12/10/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class NotificationController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TVNotif: UITableView!
    
    var data = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TVNotif.dataSource = self
        TVNotif.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            for _ in 0..<30 {
                self.data.append("Hello")
            }
            self.TVNotif.reloadData()
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as? NotificationCell else { return UITableViewCell() }
        
        cell.JobLabel.text = data[indexPath.row]
        
        return cell
    }
    
}
